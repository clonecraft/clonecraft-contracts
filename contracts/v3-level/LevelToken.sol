// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "../openzeppelin/contracts/utils/Context.sol";
import "../openzeppelin/contracts/utils/Strings.sol";
import "../openzeppelin/contracts/access/Ownable.sol";
import "../openzeppelin/contracts/security/Pausable.sol";
import "../openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "../openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract LevelToken is Context, ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply {
	using Strings for uint256;

	event SetBlacklist(address indexed user, bool state);

	string private baseURI;
	string public constant NAME = "Clonecraft Level Token";
	string public constant SYMBOL = "CCLT";
	address public devAddress;

	mapping(address => bool) public allowedMintAddressList;
	mapping(address => bool) public allowedProxyAddressList;
	mapping(address => bool) public blacklist;

	modifier onlyDev() {
		require(_msgSender() == devAddress);
		_;
	}

	modifier onlyMinter() {
		require(allowedMintAddressList[_msgSender()], "This address is not allowed to mint");
		_;
	}

	constructor(address _dev, string memory _baseURI) ERC1155(_baseURI) {
		setDevAddress(_dev);
		setURI(_baseURI);
	}

	function setURI(string memory newuri) public onlyDev {
		baseURI = newuri;
	}

	function pause() public onlyDev {
		_pause();
	}

	function unpause() public onlyDev {
		_unpause();
	}

	function mint(
		address account,
		uint256 id,
		uint256 amount,
		bytes memory data
	) public onlyMinter {
		_mint(account, id, amount, data);
	}

	function mintBatch(
		address to,
		uint256[] memory ids,
		uint256[] memory amounts,
		bytes memory data
	) public onlyMinter {
		_mintBatch(to, ids, amounts, data);
	}

	function setDevAddress(address _devAddress) public onlyOwner {
		devAddress = _devAddress;
	}

	function setMintContract(address _ca, bool _isAllow) public onlyDev {
		allowedMintAddressList[_ca] = _isAllow;
	}

	function setProxyContract(address _ca, bool _isAllow) public onlyDev {
		allowedProxyAddressList[_ca] = _isAllow;
	}

	function setBlacklist(address user, bool state) external onlyDev {
		blacklist[user] = state;
		emit SetBlacklist(user, state);
	}

	function name() external pure returns (string memory) {
		return NAME;
	}

	function symbol() external pure returns (string memory) {
		return SYMBOL;
	}

	function uri(uint256 tokenId) public view virtual override returns (string memory) {
		require(exists(tokenId), "ERC1155Supply: URI query for nonexistent token");
		return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
	}

	function isApprovedForAll(address _owner, address _operator) public view override returns (bool isOperator) {
		if (allowedProxyAddressList[_operator]) {
			return true;
		}
		return super.isApprovedForAll(_owner, _operator);
	}

	function _beforeTokenTransfer(
		address operator,
		address from,
		address to,
		uint256[] memory ids,
		uint256[] memory amounts,
		bytes memory data
	) internal override(ERC1155, ERC1155Supply) whenNotPaused {
		super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
		require(!blacklist[from] && !blacklist[to], "BLACKLIST");
	}
}
