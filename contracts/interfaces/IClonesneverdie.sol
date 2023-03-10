// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IClonesNeverDie {
	function mint(address to) external;
	function ownerOf(uint256 tokenId) external view returns (address owner);
	function transferFrom(address from, address to, uint256 tokenId) external;
	function totalSupply() external view returns (uint256);
	function getMaxSupply() external view returns (uint256);
}
