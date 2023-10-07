

whats wrong about the above code?
ChatGPT

3 / 3

The code you provided seems to have an issue with the _baseURI function. The _baseURI function should return the base URI for your token's metadata, but in your code, it returns "ipfs://".

Here's the relevant part of your code:

solidity
Copy code
function _baseURI() internal pure override returns (string memory) {
    return "ipfs://";
}
This means that the base URI for your token's metadata is set to "ipfs://", which is not a valid IPFS URI for accessing metadata. To make your code work as expected, you should set the correct base URI for your metadata, which should point to the root directory of your metadata on IPFS, as mentioned in your previous messages.

Replace the _baseURI function with the correct base URI, like this:

solidity
Copy code
function _baseURI() internal view override returns (string memory) {
    return _baseTokenURI;
}
With this change, your code will use the base URI that you set using the setBaseURI function, and it will correctly construct the token's metadata URI by combining the base URI and the token URI.







// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";

contract FreedomSBT is ERC721Enumerable, Ownable, Pausable {
    uint256 public Max_Supply = 20;
    string private _baseTokenURI; // Change to private
    bool private _paused;

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

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");

        string memory tokenUri = _tokenUri(tokenId);

        // Construct the full metadata URI by combining the baseURI and tokenUri
        string memory metadataUri = string(abi.encodePacked(_baseURI(), tokenUri));

        return metadataUri;
    }

    function _tokenUri(uint256) internal pure returns (string memory) {
        // Return the token's metadata URI, which should point to the JSON file with image and other data
        return "QmNRkm4D2eM2rVqW7FhJscA8GY2ddhmGBciLvZHEutvK9g.json";
    }

    // Rest of your contract...
}





