// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDreamers is ERC721Enumerable, Ownable {
    string _baseTokenURI;
    uint public _price = 0.1 ether;
    bool public _paused = true;
    uint public _maxMint = 20;
    uint public tokenIDs;
    IWhitelist whitelist;
    bool public preSaleStarted;
    uint public preSaleEnded;

    modifier onlyWhenNotPaused() {
        require(!_paused, "Contarct currently paused");
        _;
    }

    constructor(string memory baseURI, address whitelistContract)
        ERC721("CryptoDreamers", "CDr")
    {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        preSaleStarted = true;
        preSaleEnded = block.timestamp + 15 minutes;
    }

    function preSaleMint() public payable onlyWhenNotPaused {
        require(
            preSaleStarted && block.timestamp < preSaleEnded,
            "Presale is not acrive"
        );
        require(
            whitelist.whitelistedAddresses(msg.sender),
            "You are not whitelisted"
        );
        require(tokenIDs < _maxMint, "All tokens have been minted");
        require(msg.value >= _price, "Insufficient funds");
        tokenIDs++;
        _safeMint(msg.sender, tokenIDs);
    }

    function mint() public payable onlyWhenNotPaused {
        require(
            preSaleStarted && block.timestamp > preSaleEnded,
            "Presale is still active"
        );
        require(tokenIDs < _maxMint, "All tokens have been minted");
        require(msg.value >= _price, "Insufficient funds");
        tokenIDs++;
        _safeMint(msg.sender, tokenIDs);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    receive() external payable {}

    fallback() external payable {}
}
