// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../interfaces/IV3LevelStorage.sol";
import "../interfaces/IClonesneverdie.sol";
import "../interfaces/ILevelToken.sol";
import "../openzeppelin/contracts/utils/Context.sol";
import "../openzeppelin/contracts/access/Ownable.sol";
import "../openzeppelin/contracts/utils/math/SafeMath.sol";

contract V3LevelUp is Context, Ownable {
	// using SafeMath for uint256;

	IV3LevelStorage private v3LevelStorage;
	IClonesNeverDie private v3;
  ILevelToken private levelToken;

	uint256 public maxLevel;

  modifier levelUpRole(uint256 _tokenId) {
    require(v3.ownerOf(_tokenId) == _msgSender(), "This address is not owner of v3 nft");
    require(v3Level(_tokenId) < maxLevel, "This v3 nft is already max level");
    require(levelToken.balanceOf(_msgSender(), 0) >= levelUpTokenCalculator(v3Level(_tokenId)), "This address is not enough level up token");
		_;
	}

	constructor(address _v3LevelStorage, address _v3, address _levelToken, uint256 _maxLevel) {
		v3LevelStorage = IV3LevelStorage(_v3LevelStorage);
		v3 = IClonesNeverDie(_v3);
    levelToken = ILevelToken(_levelToken);
		setMaxLevel(_maxLevel);
	}

	function initialV3Level() public pure returns (uint256) {
		return 1;
	}

	function v3Level(uint256 _tokenId) public view returns (uint256) {
		uint256 _level = v3LevelStorage.levelState(_tokenId);
		if (_level == 0) {
			return initialV3Level();
		} else {
			return _level;
		}
	}

	function levelUp(uint256 _tokenId) public levelUpRole(_tokenId) {
		uint256 _level = v3Level(_tokenId);
    uint256 levelTokenAmount = levelUpTokenCalculator(_level);
    levelToken.burn(_msgSender(), 0, levelTokenAmount);
		v3LevelStorage.levelState(_tokenId, _level + 1);
	}

	function setMaxLevel(uint256 _maxLevel) public onlyOwner {
		maxLevel = _maxLevel;
	}

	function levelUpTokenCalculator(uint256 _thisLevel) public pure returns (uint256) {
		 return ((_thisLevel * (_thisLevel + 1)) / 2) * 100;
	}
}
