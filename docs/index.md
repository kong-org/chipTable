# Solidity API

## IChipTable

Interface for ChipTable

### TSMRegistered

```solidity
event TSMRegistered(address tsmAddress, bytes32 tsmId, string tsmName, string tsmUri)
```

Registered TSM

### TSMApproved

```solidity
event TSMApproved(bytes32 tsmId, address operator)
```

TSM approved operator

### ChipRegistered

```solidity
event ChipRegistered(bytes32 chipId, bytes32 tsmId)
```

Chip Registered with ERS

### registerTSM

```solidity
function registerTSM(address tsmAddress, string tsmName, string tsmUri) external
```

Registers a TSM 
Permissions: Owner

### registerChipIds

```solidity
function registerChipIds(bytes32 tsmId, bytes32[] chipIds) external
```

Registers Chip Ids without signatures
Permissions: Owner

### totalTSMs

```solidity
function totalTSMs() external view returns (uint256)
```

Returns the number of registered TSMs

### tsmIdByIndex

```solidity
function tsmIdByIndex(uint256 index) external view returns (bytes32)
```

Returns the TSM Id by Index

### tsmName

```solidity
function tsmName(bytes32 tsmId) external view returns (string)
```

Returns the TSM name

### tsmUri

```solidity
function tsmUri(bytes32 tsmId) external view returns (string)
```

Returns the TSM uri

### tsmAddress

```solidity
function tsmAddress(bytes32 tsmId) external view returns (address)
```

Returns the TSM address

### tsmOperator

```solidity
function tsmOperator(bytes32 tsmId) external view returns (address)
```

Returns the TSM operator

### approve

```solidity
function approve(bytes32 tsmId, address operator) external
```

Approves an operator for a TSM

### addChipId

```solidity
function addChipId(bytes32 tsmId, bytes32 chipId, bytes signature) external
```

Adds a ChipId
requires a signature
Permissions: TSM

### addChipIds

```solidity
function addChipIds(bytes32 tsmId, bytes32[] chipIds, bytes[] signatures) external
```

Adds ChipIds
requires a signature
Permissions: TSM

### chipTSMId

```solidity
function chipTSMId(bytes32 chipId) external view returns (bytes32)
```

gets a Chip's TSM Id

### chipUri

```solidity
function chipUri(bytes32 chipId) external view returns (string)
```

Gets the Chip Redirect Uri

## ChipTable

### TSM

```solidity
struct TSM {
  address _address;
  address _operator;
  string _name;
  string _uri;
}
```

### ChipInfo

```solidity
struct ChipInfo {
  bytes32 _tsmId;
}
```

### _tsms

```solidity
mapping(bytes32 => struct ChipTable.TSM) _tsms
```

### _chipIds

```solidity
mapping(bytes32 => struct ChipTable.ChipInfo) _chipIds
```

### _tsmIndex

```solidity
mapping(uint256 => bytes32) _tsmIndex
```

### _tsmCount

```solidity
uint256 _tsmCount
```

### SIGNATURE_MESSAGE

```solidity
string SIGNATURE_MESSAGE
```

### SIGNATURE_HASH

```solidity
bytes32 SIGNATURE_HASH
```

### constructor

```solidity
constructor(address _contractOwner) public
```

### registerTSM

```solidity
function registerTSM(address _address, string _name, string _uri) external
```

### registerChipIds

```solidity
function registerChipIds(bytes32 _tsmId, bytes32[] __chipIds) external
```

### onlyTSM

```solidity
modifier onlyTSM(bytes32 _tsmId)
```

### onlyTSMOrApproved

```solidity
modifier onlyTSMOrApproved(bytes32 _tsmId)
```

### _registerTSM

```solidity
function _registerTSM(bytes32 _tsmId, address _address, string _name, string _uri) internal
```

### _tsmExists

```solidity
function _tsmExists(bytes32 _tsmId) internal view returns (bool)
```

### _checkTSM

```solidity
function _checkTSM(bytes32 _tsmId) internal view
```

### _checkTSMOrApproved

```solidity
function _checkTSMOrApproved(bytes32 _tsmId) internal view
```

### totalTSMs

```solidity
function totalTSMs() external view returns (uint256)
```

Returns the number of registered TSMs

### tsmIdByIndex

```solidity
function tsmIdByIndex(uint256 _index) external view returns (bytes32)
```

### tsmName

```solidity
function tsmName(bytes32 _tsmId) external view returns (string)
```

### tsmUri

```solidity
function tsmUri(bytes32 _tsmId) public view returns (string)
```

### tsmAddress

```solidity
function tsmAddress(bytes32 _tsmId) public view returns (address)
```

### tsmOperator

```solidity
function tsmOperator(bytes32 _tsmId) public view returns (address)
```

### approve

```solidity
function approve(bytes32 _tsmId, address _operator) external
```

### addChipId

```solidity
function addChipId(bytes32 _tsmId, bytes32 _chipId, bytes _signature) external
```

### addChipIds

```solidity
function addChipIds(bytes32 _tsmId, bytes32[] __chipIds, bytes[] _signatures) external
```

### _chipExists

```solidity
function _chipExists(bytes32 _chipId) internal view returns (bool)
```

### _isValidChipSignature

```solidity
function _isValidChipSignature(bytes32 _chipId, bytes _signature) internal view returns (bool)
```

### _addChipSafe

```solidity
function _addChipSafe(bytes32 _tsmId, bytes32 _chipId, bytes _signature) internal
```

### _addChip

```solidity
function _addChip(bytes32 _tsmId, bytes32 _chipId) internal
```

### chipTSMId

```solidity
function chipTSMId(bytes32 _chipId) public view returns (bytes32)
```

### chipUri

```solidity
function chipUri(bytes32 _chipId) external view returns (string)
```

