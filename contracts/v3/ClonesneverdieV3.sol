// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../openzeppelin/contracts/security/Pausable.sol";
import "../openzeppelin/contracts/access/Ownable.sol";
import "../openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "../openzeppelin/contracts/utils/Counters.sol";

contract ClonesNeverDieV3 is ERC721, ERC721Enumerable, Pausable, Ownable, ERC721Burnable {
	using Counters for Counters.Counter;
	event Mint(uint256 indexed tokenId, address indexed to);
	event SetBlacklist(address indexed user, bool status);
	event SetFreeze(uint256 indexed tokenId, bool status);

	string private _baseTokenURI;
	uint256 internal maxSupply;
	address public devAddress;
	address public mintContract;
	address public freezeContract;
	address public proxyContract;

	mapping(address => bool) public blacklist;
	mapping(uint256 => bool) public freeze;
	mapping(address => bool) public allowedMintAddressList;
	mapping(address => bool) public allowedFreezeAddressList;
	mapping(address => bool) public allowedProxyAddressList;

	Counters.Counter private _tokenIdCounter;

	constructor(address _dev, string memory _uri, uint256 _maxSupply) ERC721("Clones Never Die Omega", "CNDO") {
		setDevAddress(_dev);
		setBaseURI(_uri);
		setMaxSupply(_maxSupply);
	}

	modifier onlyDev() {
		require(_msgSender() == devAddress);
		_;
	}

	modifier onlyMinter() {
		require(allowedMintAddressList[_msgSender()], "This address is not allowed to mint");
		_;
	}

	modifier onlyFreezer() {
		require(allowedFreezeAddressList[_msgSender()], "This address is not allowed to freeze");
		_;
	}

	function mint(address to) public onlyMinter {
		require(totalSupply() < maxSupply, "Mint end.");
		uint256 tokenId = _tokenIdCounter.current();
		_mint(to, tokenId);
		_tokenIdCounter.increment();
		emit Mint(tokenId, to);
	}

	function pause() public onlyDev {
		_pause();
	}

	function unpause() public onlyDev {
		_unpause();
	}

	function setDevAddress(address _devAddress) public onlyOwner {
		devAddress = _devAddress;
	}

	function setBaseURI(string memory baseURI) public onlyDev {
		_baseTokenURI = baseURI;
	}

	function setMaxSupply(uint256 _maxSupply) public onlyDev {
		maxSupply = _maxSupply;
	}

	function getMaxSupply() public view returns (uint256) {
		return maxSupply;
	}

	function setMintContract(address _ca, bool _isAllow) public onlyDev {
		allowedMintAddressList[_ca] = _isAllow;
	}

	function setFreezeContract(address _ca, bool _isAllow) public onlyDev {
		allowedFreezeAddressList[_ca] = _isAllow;
	}

	function setProxyContract(address _ca, bool _isAllow) public onlyDev {
		allowedProxyAddressList[_ca] = _isAllow;
	}

	function setBlacklist(address user, bool status) external onlyDev {
		blacklist[user] = status;
		emit SetBlacklist(user, status);
	}

	function setFreeze(uint256 tokenId, bool status) public onlyFreezer {
		freeze[tokenId] = status;
		emit SetFreeze(tokenId, status);
	}

	function isApprovedForAll(address _owner, address _operator) public view override returns (bool isOperator) {
		if (allowedProxyAddressList[_operator]) {
			return true;
		}
		return ERC721.isApprovedForAll(_owner, _operator);
	}

	function _baseURI() internal view override returns (string memory) {
		return _baseTokenURI;
	}

	function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) whenNotPaused {
		super._beforeTokenTransfer(from, to, tokenId);
		require(!freeze[tokenId], "This token is frozen");
		require(!blacklist[from] && !blacklist[to], "BLACKLIST");
	}

	function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}
}
