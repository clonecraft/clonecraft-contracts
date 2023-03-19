// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../interfaces/IV3LevelStorage.sol";
import "../openzeppelin/contracts/utils/Context.sol";
import "../openzeppelin/contracts/access/Ownable.sol";

contract V3LevelStorage is IV3LevelStorage, Context, Ownable {
	mapping(address => bool) internal _isAllow;
	mapping(uint256 => uint256) internal _levelState;

	modifier onlySetter() {
		require(_isAllow[_msgSender()], "This address is not allowed");
		_;
	}

	function setSetterContract(address _addr, bool _allow) public onlyOwner {
		_isAllow[_addr] = _allow;
		emit SetSetter(_addr);
	}

	function levelState(uint256 _tokenId, uint256 _level) public onlySetter {
		_levelState[_tokenId] = _level;
		emit SetLevelState(_tokenId, _level);
	}

	function levelStateBatch(uint256[] memory _tokenIds, uint256[] memory _levels) public onlySetter {
		for (uint256 i = 0; i < _tokenIds.length; i++) {
			levelState(_tokenIds[i], _levels[i]);
		}
	}

	function levelState(uint256 _tokenId) public view returns (uint256) {
		return _levelState[_tokenId];
	}
}
