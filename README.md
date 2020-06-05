## 미디어 아트 DApp - ABC

### 스마트 컨트랙트 Getter & Setter 
```solidity
  
    struct Mediaart {
        //모양, 색깔 지정
        //creater
      
        string name;
        string p5_code;
        uint64 createTime; // 최초 생성 시간
        uint256[] childArtIds ; // 누가 이 미디어 아트를 참조하는지
        uint256[] parentArtIds ; // 이 미디어 아트가 누구를 참조하고 있는지
        uint64 likey;
        bool selling;
    }
    
    function getMediaart(uint256 mediaArtId) 
    function getMediaart_name(uint256 mediaArtId
    function getMediaart_p5_code(uint256 mediaArtId) 
    function getMediaart_createTime(uint256 mediaArtId) 
    function getMediaart_childArtIds(uint256 mediaArtId) 
    function getMediaart_parentArtIds(uint256 mediaArtId) 
    function getMediaart_likey(uint256 mediaArtId) 
    function twicelikey(uint256 mediaartId)
 
    function ReferMediaart (
        uint256 parentArtId, uint256 mediaArtId
    ) 
    
    function deleteMediaart (
        uint256 mediaartId,
        address _owner
    ) 
    function createMediaart(
        string _name,
        string _p5_code,
        address _owner
    )
    function balanceOf(address _owner) public view returns (uint256 count) 
    function transfer (address _to, uint256 _tokenId) 
    function approve(
        address _to,
        uint256 _tokenId
    )
    function getreference_code(address _owner, uint256 id) view returns (string[]) {
        require(mediaartIndexToOwner[id] == _owner);
        uint256[] a = mediaarts[id].parentArtIds;
        string[] result;
        for (uint i =0 ; i<a.length ; i++)
        {
            result.push(mediaarts[a[i]].p5_code);
        }
        return result;
    }
    
    function edit(address _owner, uint256 id, string code) external {
        require(mediaartIndexToOwner[id] == _owner);
        mediaarts[id].p5_code = code;
    }
    
    


``` 
