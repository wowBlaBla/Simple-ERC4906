// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title EIP-721 Metadata Update Extension
interface IERC4906 is IERC165{
    /// @dev This event emits when the metadata of a token is changed.
    /// So that the third-party platforms such as NFT market could
    /// timely update the images and related attributes of the NFT.
    event MetadataUpdate(uint256 _tokenId);

    /// @dev This event emits when the metadata of a range of tokens is changed.
    /// So that the third-party platforms such as NFT market could
    /// timely update the images and related attributes of the NFTs.    
    event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);
}

contract TestUpgradableNFT is ERC721URIStorage, IERC4906 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_){
    }
    
    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC721)
        returns (bool) 
    {
        return interfaceId == bytes4(0x49064906) || super.supportsInterface(interfaceId);
    }

    function mint(string calldata tokenURI)
        external
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function updateItem(uint256 tokenId, string calldata newTokenUri)
        external
        returns (bool)
    {
        require(_exists(tokenId), "Non-exist item");

        _setTokenURI(tokenId, newTokenUri);
        emit MetadataUpdate(tokenId);
        
        return true;
    }
}
