// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IV3LevelStorage {
	event SetSetter(address _setter);
	event SetLevelState(uint256 indexed _tokenId, uint256 _level);

	function levelState(uint256 _tokenId, uint256 _level) external;

	function levelState(uint256 _tokenId) external view returns (uint256);
}
