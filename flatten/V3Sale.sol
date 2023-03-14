// SPDX-License-Identifier: MIT

// Sources flattened with hardhat v2.9.1 https://hardhat.org

// File contracts/interfaces/IClonesneverdie.sol

pragma solidity ^0.8.10;

interface IClonesNeverDie {
	function mint(address to) external;

	function ownerOf(uint256 tokenId) external view returns (address owner);

	function transferFrom(address from, address to, uint256 tokenId) external;

	function totalSupply() external view returns (uint256);

	function getMaxSupply() external view returns (uint256);
}

// File contracts/openzeppelin/contracts/utils/Context.sol

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
	function _msgSender() internal view virtual returns (address) {
		return msg.sender;
	}

	function _msgData() internal view virtual returns (bytes calldata) {
		return msg.data;
	}
}

// File contracts/openzeppelin/contracts/access/Ownable.sol

// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
	address private _owner;

	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	/**
	 * @dev Initializes the contract setting the deployer as the initial owner.
	 */
	constructor() {
		_transferOwnership(_msgSender());
	}

	/**
	 * @dev Returns the address of the current owner.
	 */
	function owner() public view virtual returns (address) {
		return _owner;
	}

	/**
	 * @dev Throws if called by any account other than the owner.
	 */
	modifier onlyOwner() {
		require(owner() == _msgSender(), "Ownable: caller is not the owner");
		_;
	}

	/**
	 * @dev Leaves the contract without owner. It will not be possible to call
	 * `onlyOwner` functions anymore. Can only be called by the current owner.
	 *
	 * NOTE: Renouncing ownership will leave the contract without an owner,
	 * thereby removing any functionality that is only available to the owner.
	 */
	function renounceOwnership() public virtual onlyOwner {
		_transferOwnership(address(0));
	}

	/**
	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
	 * Can only be called by the current owner.
	 */
	function transferOwnership(address newOwner) public virtual onlyOwner {
		require(newOwner != address(0), "Ownable: new owner is the zero address");
		_transferOwnership(newOwner);
	}

	/**
	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
	 * Internal function without access restriction.
	 */
	function _transferOwnership(address newOwner) internal virtual {
		address oldOwner = _owner;
		_owner = newOwner;
		emit OwnershipTransferred(oldOwner, newOwner);
	}
}

// File contracts/v3-sale/V3Sale.sol

pragma solidity ^0.8.10;

contract V3Sale is Context, Ownable {
	address public cnd;
	address public dsc;
	bool public isSale = false;
	uint256 internal salePrice;
	uint256 public perMintMaxCount;
	uint256 public constant startUnixTime = 1678719600;
	mapping(uint256 => uint256) public freeSaleCount;
	mapping(uint256 => mapping(address => bool)) public freeSaleCountPerAddress;
	mapping(uint256 => mapping(address => uint256)) public saleCountPerAddress;

	IClonesNeverDie public nft;

	modifier saleMintRole(uint256 numberOfTokens) {
		require(isSale, "The sale has not started.");
		require(numberOfTokens <= perMintMaxCount, "Can only mint 20 Clones at a time");
		require(nft.totalSupply() + numberOfTokens <= nft.getMaxSupply(), "Purchase would exceed max supply of Clones");
		require(saleCountPerAddress[getSaleEpoch()][msg.sender] < perMintMaxCount, "Can only mint 9 Clones at a time");
		require(saleCountPerAddress[getSaleEpoch()][msg.sender] + numberOfTokens <= perMintMaxCount, "Can only mint 9 Clones at a time");
		require(salePrice * numberOfTokens == msg.value, "Klay value sent is not correct");
		_;
	}

	modifier onlyCND() {
		require(cnd == _msgSender(), "only CND: caller is not the CND");
		_;
	}

	modifier onlyDSC() {
		require(dsc == _msgSender(), "only DSC: caller is not the DSC");
		_;
	}

	modifier onlyCreator() {
		require(cnd == _msgSender() || dsc == _msgSender() || owner() == _msgSender(), "onlyCreator: caller is not the creator");
		_;
	}

	constructor(address _nftCA, address _cnd, address _dsc) {
		nft = IClonesNeverDie(_nftCA);
		cnd = _cnd;
		dsc = _dsc;
		setPerMintMaxCount(9);
		setSale();
		setSalePrice(2000000000000000000); // 2 KLAY
	}

	function withdraw() public payable onlyCreator {
		(bool success1, ) = cnd.call{ value: address(this).balance / 2 }("");
		(bool success2, ) = dsc.call{ value: address(this).balance / 2 }("");
		if (!success1 || !success2) {
			revert("Ether transfer failed");
		}
	}

	function saleMint(uint256 _amount) external payable saleMintRole(_amount) {
		for (uint256 i = 0; i < _amount; i++) {
			nft.mint(msg.sender);
			saleCountPerAddress[getSaleEpoch()][msg.sender]++;
		}
	}

	function freeSaleMint() external {
		require(freeSaleCount[getSaleEpoch()] < 10, "freeSaleMint: free sale mint limit reached");
		require(freeSaleCountPerAddress[getSaleEpoch()][msg.sender] == false, "freeSaleMint: free sale mint limit reached");
		nft.mint(msg.sender);
		freeSaleCount[getSaleEpoch()]++;
		freeSaleCountPerAddress[getSaleEpoch()][msg.sender] = true;
	}

	function getSaleEpoch() public view returns (uint256) {
		return (block.timestamp - startUnixTime) / 86400;
	}

	function getSalePrice() public view returns (uint256) {
		return salePrice;
	}

	function setCND(address changeAddress) public onlyCND {
		cnd = changeAddress;
	}

	function setDSC(address changeAddress) public onlyDSC {
		dsc = changeAddress;
	}

	function setSalePrice(uint256 _salePrice) public onlyOwner {
		salePrice = _salePrice;
	}

	function setPerMintMaxCount(uint256 _num) public onlyOwner {
		perMintMaxCount = _num;
	}

	function setSale() public onlyOwner {
		isSale = !isSale;
	}
}
