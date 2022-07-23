pragma solidity ^0.8.5;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

import "../intf/IChipTable.sol";

contract ChipTable is IChipTable, Context, Ownable
{
  struct TSM 
  {
    address _address;
    address _operator;
    string _name;
    string _uri;
  }

  struct ChipInfo
  {
    bytes32 _tsmId;
  }

  mapping(bytes32 => TSM) private _tsms; /* mapping tsmId => tsm */
  mapping(bytes32 => ChipInfo) private _chipIds; /* mapping from chipId => tsmId */
  mapping(uint256 => bytes32) private _tsmIndex; /* mapping from TSM index => tsmId */
  uint256 private _tsmCount;

  /* constants */
  string constant private SIGNATURE_MESSAGE = "kong.land";
  bytes32 immutable private SIGNATURE_HASH;

  constructor(address _contractOwner)
  {
    transferOwnership(_contractOwner);
    SIGNATURE_HASH = keccak256(
      abi.encodePacked(
        "\x19Ethereum Signed Message:\n32",
        keccak256(abi.encodePacked(SIGNATURE_MESSAGE))
      )
    );
  }

  /*=== OWNER ===*/
  function registerTSM(
    address _address, 
    string calldata _name,
    string calldata _uri) external override onlyOwner 
  {
    bytes32 _tsmId = keccak256(abi.encodePacked(_name));
    
    _registerTSM(_tsmId, _address, _name, _uri);

    /* update indexing */
    _tsmIndex[_tsmCount] = _tsmId;
    _tsmCount = _tsmCount + 1;
  }

  function registerChipIds(
    bytes32 _tsmId,
    bytes32[] calldata __chipIds
  ) external override onlyOwner
  { 
    for(uint256 i = 0; i < __chipIds.length; i++)
    {
      _addChip(_tsmId, __chipIds[i]);
    }
  }
  /*=== END OWNER ===*/

  /*=== TSM ===*/
  modifier onlyTSM(bytes32 _tsmId) 
  {
    _checkTSM(_tsmId);
    _;
  }

  modifier onlyTSMOrApproved(bytes32 _tsmId)
  {
    _checkTSMOrApproved(_tsmId);
    _;
  }

  function _registerTSM(
    bytes32 _tsmId,
    address _address, 
    string calldata _name,
    string calldata _uri) internal
  {
    require(!_tsmExists(_tsmId), "Owner: TSM already registered");
    _tsms[_tsmId]._address = _address;
    _tsms[_tsmId]._operator = address(0);
    _tsms[_tsmId]._name = _name;
    emit TSMRegistered(_address, _tsmId, _name, _uri);
  }

  function _tsmExists(bytes32 _tsmId) internal view returns (bool)
  {
    return _tsms[_tsmId]._address != address(0);
  }

  function _checkTSM(bytes32 _tsmId) internal view
  {
    require(_msgSender() == tsmAddress(_tsmId), "TSM: caller is not TSM");
  }
  
  function _checkTSMOrApproved(bytes32 _tsmId) internal view
  {
    require(_msgSender() == tsmAddress(_tsmId) || _msgSender() == tsmOperator(_tsmId),
      "TSM: caller is not TSM or approved");
  }

  function totalTSMs() external override view returns (uint256)
  {
    return _tsmCount;
  }

  function tsmIdByIndex(uint256 _index) external override view returns (bytes32)
  {
    require(_index < _tsmCount, "TSM: index out of bounds");
    return _tsmIndex[_index];
  }

  function tsmName(bytes32 _tsmId) external override view returns (string memory)
  {
    require(_tsmExists(_tsmId), "TSM: tsm does not exist");
    return _tsms[_tsmId]._name;
  }

  function tsmUri(bytes32 _tsmId) public override view returns (string memory)
  {
    require(_tsmExists(_tsmId), "TSM: tsm does not exist");
    return _tsms[_tsmId]._uri;
  }

  function tsmAddress(bytes32 _tsmId) public override view returns (address)
  {
    require(_tsmExists(_tsmId), "TSM: tsm does not exist");
    return _tsms[_tsmId]._address;
  }
  
  function tsmOperator(bytes32 _tsmId) public override view returns (address)
  {
    require(_tsmExists(_tsmId), "TSM: tsm does not exist");
    return _tsms[_tsmId]._operator;
  }

  function approve(bytes32 _tsmId, address _operator) external override onlyTSM(_tsmId)
  {
    _tsms[_tsmId]._operator = _operator;
    emit TSMApproved(_tsmId, _operator);
  }

  function addChipId(
    bytes32 _tsmId, 
    bytes32 _chipId, 
    bytes calldata _signature) external override onlyTSMOrApproved(_tsmId)
  {
    _addChipSafe(_tsmId, _chipId, _signature);
  }

  function addChipIds(
    bytes32 _tsmId,
    bytes32[] calldata __chipIds,
    bytes[] calldata _signatures
  ) external override onlyTSMOrApproved(_tsmId)
  { 
    for(uint256 i = 0; i < __chipIds.length; i++)
    {
      _addChipSafe(_tsmId, __chipIds[i], _signatures[i]);
    }
  }
  /*=== END TSM ===*/

  /*=== CHIP ===*/
  function _chipExists(bytes32 _chipId) internal view returns (bool)
  {
    return _chipIds[_chipId]._tsmId != bytes32(0);
  }

  function _isValidChipSignature(bytes32 _chipId, bytes calldata _signature) internal view returns (bool)
  {
    address _signer;
    bytes32 _r;
    bytes32 _s;
    uint8 _v;

    /* Implementation for Kong Halo Chip 2021 Edition */
    require(_signature.length == 65, "Chip: invalid sig length");

      /* unpack v, s, r */
    _r = bytes32(_signature[0:32]);
    _s = bytes32(_signature[32:64]);
    _v = uint8(_signature[64]);

    if(uint256(_s) > 
      0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0)
    {
      revert("Chip: invalid sig `s`");
    }

    if(_v != 27 && _v != 28)
    {
      revert("Chip: invalid sig `v`");
    }

    _signer = ecrecover(SIGNATURE_HASH, _v, _r, _s);
    
    require(_signer != address(0x0), "Chip: invalid signer");

    return _signer == address(uint160(uint256(_chipId)));
  }

  function _addChipSafe(bytes32 _tsmId, bytes32 _chipId, bytes calldata _signature) internal
  {
    require(_isValidChipSignature(_chipId, _signature), "Chip: chip signature invalid");
    _addChip(_tsmId, _chipId);
  }

  function _addChip(bytes32 _tsmId, bytes32 _chipId) internal
  {
    require(!_chipExists(_chipId), "Chip: chip already exists");
    _chipIds[_chipId]._tsmId = _tsmId;
    emit ChipRegistered(_chipId, _tsmId);
  }

  function chipTSMId(bytes32 _chipId) public override view returns (bytes32)
  {
    require(_chipExists(_chipId), "Chip: chip doesn't exist");
    return _chipIds[_chipId]._tsmId;
  }
  
  function chipUri(bytes32 _chipId) external override view returns (string memory)
  {
    return tsmUri(chipTSMId(_chipId));
  }
  /*=== END CHIP ===*/
}