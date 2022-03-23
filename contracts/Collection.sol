pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Collection is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;
    Counters.Counter private _totalMinted;
    mapping(address => uint8) private mintedAddress;
    mapping(string => uint8) private URIMapping;
    uint256 public PRICE_PRE_TOKEN = 0.01 ether;
    uint256 public LIMIT_PER_ADDRESS = 2;
    uint public MAX_SUPPLY = 5;

    constructor() ERC721("Collection", "NFT") {}
    function setPrice(uint256 price) external onlyOwner{
        PRICE_PRE_TOKEN = price;
    }
    function setLimit(uint256 limit) external onlyOwner{
        LIMIT_PER_ADDRESS = limit;
    }
    function maxSupply(uint256 supply) external onlyOwner{
        MAX_SUPPLY= supply;
    }

    function mintNFT(string memory tokenURI)
    payable
    external
    returns (uint256)
    {
        require(PRICE_PRE_TOKEN <= msg.value, "Ether paid is incorrect");
        require(mintedAddress[msg.sender] < LIMIT_PER_ADDRESS, "You have exceeded minting limit");
        require(_totalMinted.current() + 1 <= MAX_SUPPLY, "You have exceeded max supply");
        require(URIMapping[tokenURI] == 0, "This NFT has benn already minted");

        URIMapping[tokenURI] += 1;
        _tokenIDs.increment();
        _totalMinted.increment();

        uint256 newItemID = _tokenIDs.current();
        _mint(msg.sender, newItemID);
        _setTokenURI(newItemID, tokenURI);

        return newItemID;
    }
    function withdrawMoney() external onlyOwner {
        address payable to = payable(msg.sender);
        to.transfer(address(this).balance);
    }
}