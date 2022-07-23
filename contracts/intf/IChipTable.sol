pragma solidity ^0.8.5;


/**
 * Interface for ChipTable
 *
 *
 */
interface IChipTable
{
  /**
   * Registered TSM
   */
  event TSMRegistered(address tsmAddress, bytes32 tsmId, string tsmName, string tsmUri);
  
  /**
   * TSM approved operator
   */
  event TSMApproved(bytes32 tsmId, address operator);

  /**
   * Chip Registered with ERS
   */
  event ChipRegistered(bytes32 chipId, bytes32 tsmId);

  /**
   * Registers a TSM 
   * Permissions: Owner
   */
  function registerTSM(
    address tsmAddress, 
    string calldata tsmName,
    string calldata tsmUri) external;
  
  /**
   * Registers Chip Ids without signatures
   * Permissions: Owner
   */
  function registerChipIds(
    bytes32 tsmId,
    bytes32[] calldata chipIds
  ) external;

  /**
   * Returns the number of registered TSMs
   */
  function totalTSMs() 
    external view returns (uint256);

  /**
   * Returns the TSM Id by Index
   */
  function tsmIdByIndex(uint256 index) 
    external view returns (bytes32);

  /**
   * Returns the TSM name
   */
  function tsmName(bytes32 tsmId) 
    external view returns (string memory);

  /**
   * Returns the TSM uri
   */
  function tsmUri(bytes32 tsmId) 
    external view returns (string memory);

  /**
   * Returns the TSM address
   */
  function tsmAddress(bytes32 tsmId) 
    external view returns (address);

  /**
   * Returns the TSM operator
   */
  function tsmOperator(bytes32 tsmId) 
    external view returns (address);

  /**
   * Approves an operator for a TSM
   */
  function approve(bytes32 tsmId, address operator) external;

  /**
   * Adds a ChipId
   * requires a signature
   * Permissions: TSM
   */
  function addChipId(
    bytes32 tsmId, 
    bytes32 chipId, 
    bytes calldata signature) external;

  /**
   * Adds ChipIds
   * requires a signature
   * Permissions: TSM
   */
  function addChipIds(
    bytes32 tsmId,
    bytes32[] calldata chipIds,
    bytes[] calldata signatures
  ) external;

  /**
   * gets a Chip's TSM Id
   */
  function chipTSMId(bytes32 chipId) 
    external view returns (bytes32);

  /**
   * Gets the Chip Redirect Uri
   */
  function chipUri(bytes32 chipId) 
    external view returns (string memory);
}