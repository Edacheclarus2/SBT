// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";
import {Strings} from  "@openzeppelin/contracts/utils/Strings.sol";


contract FreedomSBT is ERC721Enumerable, Ownable, Pausable {
    uint256 public Max_Supply = 20;
    string _baseTokenURI;
    bool private _paused;
    using Strings for uint256;

    mapping(address => bool) private _hasMinted;

    constructor(string memory baseURI) ERC721("LIFE BOND", "LIFE") {
        setBaseURI(baseURI);
        _safeMint(msg.sender, 0);
        _safeMint(msg.sender, 3);
        _paused = false;
    }

    event SuccessFulMint(uint256 tokenId, string messages);
    event SuccessfulBurn(uint256 tokenId, string messages);

    modifier onlyOneMintPerAddress(address account) {
        require(!_hasMinted[account], "Address has already minted a token");
        _;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }



    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "Token does not exist");

    string memory baseURI = _baseURI();

    // Construct the full token URI by appending the token ID to the base URI
    string memory metadataUri = string(abi.encodePacked(baseURI, tokenId.toString()));

    return metadataUri;
}

    //     function _tokenUri(uint256) internal pure returns (string memory) {
    //     // Return the JPEG image hash as the token's metadata URI
    //     return "QmNRkm4D2eM2rVqW7FhJscA8GY2ddhmGBciLvZHEutvK9g";
    // }


    function mintToken(address recipient, uint256 tokenId) external onlyOneMintPerAddress(recipient) {
        require(totalSupply() < Max_Supply, "ALL  TOKENS MINTED OUT");
        _safeMint(recipient, tokenId);
        _hasMinted[recipient] = true;

        emit SuccessFulMint(tokenId, "Successfully Minted");
    }

    function _transfer(address, address, uint256) internal virtual override {
        revert("Token transfers are not allowed.");
    }

    function burnToken(uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId), "Not Token OWner");
        super._burn(tokenId);
        emit SuccessfulBurn(tokenId, "Successfully burnt from existence");
    }

    function getTotalSupply() external view returns (uint256) {
        return totalSupply();
    }

    function getBasicURI() external view returns (string memory) {
        return _baseURI();
    }

    function getMaxSupply() external view returns (uint256) {
        return Max_Supply;
    }

    function getSymbol() external view returns (string memory) {
        return symbol();
    }

    function getName() external view returns (string memory) {
        return name();
    }

    function getCurrentStatus() external view returns (bool) {
        return _paused;
    }

    function getMintedStatus(address test) external view returns (bool) {
        return _hasMinted[test];
    }
}
