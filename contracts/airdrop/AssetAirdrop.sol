// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../interfaces/IClonesneverdieAsset.sol";
import "../openzeppelin/contracts/access/Ownable.sol";

contract AssetAirdrop is Ownable {
	IClonesNeverDieAsset public assetNft;

	constructor(address _asset) {
		assetNft = IClonesNeverDieAsset(_asset);
	}

	function airdrop(address[] memory addresses, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public onlyOwner {
		for (uint256 i = 0; i < addresses.length; i++) {
			assetNft.mint(addresses[i], ids[i], amounts[i], data);
		}
	}
}
