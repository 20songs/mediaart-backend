pragma solidity ^0.4.22;



/// @title Base contract for CryptoKitties. Holds all common structs, events and base variables.
/// @author Axiom Zen (https://www.axiomzen.co)
/// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.

contract MediaartBase {
    /*** EVENTS ***/
   
    event Create(address owner, uint256 mediaartId, uint256 propertymediaArt);

    /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a kitten
    ///  ownership is assigned, including births.
    event Transfer(address from, address to, uint256 tokenId);

   
    struct Mediaart {
        
        uint256 property;
        uint64 createTime;
       

    }


    uint256 public secondsPerBlock = 15;


    Mediaart[] mediaarts;


    mapping (uint256 => address) public mediaartIndexToOwner;


    mapping (uint256 => address) public mediaartIndexToApproved;

    mapping (address => address) ownershipTokenCount;

    SaleClockAuction public saleAuction;

    

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        // Since the number of kittens is capped to 2^32 we can't overflow this
       
       ownershipTokenCount[_to]++;
        mediaartIndexToOwner[_tokenId] = _to;
        // When creating new kittens _from is 0x0, but we can't account that address.
        if (_from != address(0)) {
           ownershipTokenCount[_from]--;
            delete kittyIndexToApproved[_tokenId];
        }
        // Emit the transfer event.
        Transfer(_from, _to, _tokenId);
    }

    function _createMediaart(
        uint256 _propertymediaart,
        address _owner
    )
        internal
        returns (uint)
    {
       
        Mediaart memory _mediaart = Mediaart({
            property: _propertymediaart,
            createTime: uint64(now),
         
        });
        
        uint256 newmediaartId = mediaarts.push(_mediaart) - 1;

        // It's probably never going to happen, 4 billion cats is A LOT, but
        // let's just be 100% sure we never let this happen.
        require(newmediaartId == uint256(uint32(newmediaartId)));
//     event Create(address owner, uint256 mediaartId, uint256 propertymediaArt);
        // emit the birth event
        Create(
            _owner,
            newmediaartId,
            _mediaart.property
         
        );

        // This will assign ownership, and also emit the Transfer event as
        // per ERC721 draft
        _transfer(0, _owner, newmediaartId);

        return newmediaartId;
    }

   
}