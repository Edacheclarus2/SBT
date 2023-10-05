// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";

contract FreedomSBT is ERC721Enumerable, Ownable, Pausable {
    uint256 public Max_Supply = 4;
    bool private _paused;

    mapping(address => bool) private _hasMinted;

    constructor() ERC721("LIFE BOND", "LIFE") {
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

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://bafybeigogdgnc7ernxrve2s6gu2zovigtstt5rrlguu6pg6s46bibwbg3m/";
    }

    function mintToken(address recipient, uint256 tokenId) external onlyOneMintPerAddress(recipient) {
        require(totalSupply() < Max_Supply, "ALL  TOKENS MINTED OUT");
        _safeMint(recipient, tokenId);
        _hasMinted[recipient] = true;
        tokenURI(tokenId);
        emit SuccessFulMint(tokenId, "Successfully Minted");
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual override whenPaused {}

    function burnToken(uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId), "Not Token OWner");
        super._burn(tokenId);
        emit SuccessfulBurn(tokenId, "Successfully burnt from existence");
    }

    function getTotalSupply() external view returns (uint256) {
        return totalSupply();
    }

    function getBasicURI() external pure returns (string memory) {
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
