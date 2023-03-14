// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../interfaces/IClonesneverdie.sol";
import "../openzeppelin/contracts/utils/Context.sol";
import "../openzeppelin/contracts/access/Ownable.sol";

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
