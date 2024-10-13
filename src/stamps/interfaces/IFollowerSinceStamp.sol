// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IStamp } from "./IStamp.sol";

/// @title IFollowerSinceStamp
/// @notice Interface for a stamp that represents a follower relationship on a platform
interface IFollowerSinceStamp is IStamp {
	// Custom errors for specific validation failures
	/// @notice Thrown when the recipient address is invalid
	error InvalidRecipient();

	/// @notice Thrown when the follower identifier is invalid
	error InvalidFollower();

	/// @notice Error thrown when a follower attempts to mint a stamp more than once
	error FollowerAlreadyMinted();

	// View functions to get stamp-specific information
	/// @notice The platform identifier for this stamp (e.g., "Twitter", "Instagram")
	function PLATFORM() external view returns (string memory);

	/// @notice The identifier of the followed account on the platform
	function FOLLOWED() external view returns (string memory);

	/// @notice Mapping to store the "since" timestamp for each stamp token ID
	function followStartTimestamp(uint256 stampId) external view returns (uint256);

	/// @notice Check if a follower has already minted a stamp
	/// @param follower The identifier of the follower on the platform
	/// @return True if the follower has already minted a stamp, false otherwise
	function hasFollowerMinted(string calldata follower) external view returns (bool);

	/// @notice Mints a new follower since stamp
	/// @dev This function verifies the signature, mints a new stamp, and prevents duplicate minting
	/// @param follower The identifier of the follower on the platform
	/// @param since The timestamp since when the user has been following
	/// @param deadline The timestamp after which the signature is no longer valid
	/// @param signature The signature authorizing the minting, signed by a trusted authority
	/// @return stampId The ID of the newly minted stamp
	function mintStamp(
		string calldata follower,
		uint256 since,
		uint256 deadline,
		bytes calldata signature
	) external returns (uint256 stampId);

	/// @notice Get the follower since timestamp for a given address
	/// @param follower The address to check
	/// @return The timestamp when the follower started following, or 0 if not found or if the follower has no stamps
	function getFollowerSinceTimestamp(address follower) external view returns (uint256);

	/// @notice Emitted when a new follower since stamp is minted
	/// @param platform The platform identifier
	/// @param followed The identifier of the followed account
	/// @param follower The identifier of the follower
	/// @param since The timestamp since when the user has been following
	/// @param stampId The ID of the minted stamp
	/// @param owner The address of the stamp owner (likely the follower's address)
	event FollowerSince(
		string platform,
		string followed,
		string follower,
		uint256 since,
		uint256 stampId,
		address owner
	);
}
