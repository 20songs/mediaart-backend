pragma solidity ^0.4.22;

/// @title The facet of the CryptoKitties core contract that manages ownership, ERC-721 (draft) compliant.
/// @author Axiom Zen (https://www.axiomzen.co)
/// @dev Ref: https://github.com/ethereum/EIPs/issues/721
///  See the KittyCore contract documentation to understand how the various contract facets are arranged.



contract MediaartPractice {
    event Transfer(address from, address to, uint256 tokenid);
    event Create(address owner, uint256 mediaartId, uint64 ballSize, uint64 ballColor); // 미디어아트id, 
    event Delete(address owner, uint256 mediaartId, uint64 ballSize, uint64 ballColor); // 지우기
    event Reference(uint256 parentartId, uint256 mediaartId);

  //  event Transfer(address from, address to, uint256 tokenId); // from 에서 to로 tokenid 소유권 이전
  //  event Reference(address from, address to, uint256 tokenId); // from을 to라는 사람이 참조

    Mediaart[] mediaarts;
    mapping (uint256 => address) public mediaartIndexToOwner;


    mapping (uint256 => address) public mediaartIndexToApproved;

    mapping (address => uint256) ownershipTokenCount;
    /* READ */
    // erc-721 에 종속된 고유 값 불러오기

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        // Since the number of kittens is capped to 2^32 we can't overflow this
       
       ownershipTokenCount[_to]++;
        mediaartIndexToOwner[_tokenId] = _to;
        // When creating new kittens _from is 0x0, but we can't account that address.
        if (_from != address(0)) {
           ownershipTokenCount[_from]--;
            delete mediaartIndexToApproved[_tokenId];
        }
        // Emit the transfer event.
        Transfer(_from, _to, _tokenId);
    }


    struct Mediaart {
        //모양, 색깔 지정
        //creater
      
        uint64 ballSize;
        uint64 ballColor;
        uint64 createTime; // 최초 생성 시간
        uint256[] childArtIds ; // 누가 이 미디어 아트를 참조하는지
        uint256[] parentArtIds ; // 이 미디어 아트가 누구를 참조하고 있는지

    }

    function getMediaart(uint256 mediaArtId) external view returns(
        
        uint64 ballSize,
        uint64 ballColor,
        uint64 createTime,
        uint256[] childArtIds,
        uint256[] parentArtIds 
        ) {
     Mediaart storage medart = mediaarts[mediaArtId];
     ballSize = medart.ballSize;
     ballColor = medart.ballColor;
     createTime = medart.createTime;
     childArtIds = medart.childArtIds;
     parentArtIds = medart.parentArtIds;
    }
    
   
    function ReferMediaart (
        uint256 parentArtId, uint256 mediaArtId
    ) external {
        require(msg.sender == mediaartIndexToOwner[mediaArtId]);
        Mediaart storage parent = mediaarts[parentArtId];
        parent.childArtIds.push(mediaArtId);
        Mediaart storage self = mediaarts[mediaArtId];
        self.parentArtIds.push(parentArtId); 
        emit Reference(parentArtId, mediaArtId);
    }
    
    //event Delete(address owner, uint256 mediaartId, uint64 ballSize, uint64 ballColor);
    

    function deleteMediaart (
        uint256 mediaartId,
        address _owner
    ) external returns(string) {
       
        emit Delete(
            _owner,
            mediaartId,
            mediaarts[mediaartId].ballSize,
            mediaarts[mediaartId].ballColor
         
        );
        delete mediaarts[mediaartId];
       
        return "Delete Complete";
    }
    
   function createMediaart(
        uint64 _ballSize,
        uint64 _ballColor,
        address _owner
    )
        external
        returns (uint)
    {
       
        Mediaart memory _mediaart = Mediaart({
            ballSize : _ballSize,
            ballColor : _ballColor,
            createTime: uint64(now),
            
            childArtIds : new uint256[](0),
            parentArtIds : new uint256[](0)
      
         
        });
        
        uint256 newmediaartId = mediaarts.push(_mediaart) - 1;

        require(newmediaartId == uint256(uint32(newmediaartId)));
//     event Create(address owner, uint256 mediaartId, uint256 propertymediaArt);
        // emit the birth event
        emit Create(
            _owner,
            newmediaartId,
            _mediaart.ballSize,
            _mediaart.ballColor
         
        );

        // This will assign ownership, and also emit the Transfer event as
        // per ERC721 draft
      //  _transfer(0, _owner, newmediaartId);

        return newmediaartId;
    }
    
}

