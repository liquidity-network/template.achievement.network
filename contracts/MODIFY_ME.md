# Creating an Asset Trading and Investment Platform

Link to GitHub pull request: https://github.com/liquidity-network/template.achievement.network/pull/8

Blockchain brings trust in the marketplace through its append-only characteristic
and immutable transactions. Your task is to apply knowledge of writing smart
contracts to create a more transparent marketplace which provides visibility to the
assets owned by peers.


Topics: modifiers, mappings, events, data structure equality, inheritance,
buyer/seller interactions

## Trade Syndication


[](Exercise 1)
{% exercise %}
Write a function called `allocateAsset` which is `public` and does not return any
value. Instead, it lets the owner of the smart contract add assets in the portofolio
of a new address. First implement the modifier `onlyOwner`, which lets only
the owner of the smart contract allocate assets.

{% initial %}
pragma solidity ^0.4.24;

contract TradeSyndication {

    address public owner;
    uint public totalNumberOfAssets;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        // TODO: implement
    }

    struct Asset {
        string name;
        bool isSold;
    }

    mapping (address => mapping (uint256 => Asset)) public mapOwnerAssets;
    mapping (address => uint256) public mapOwnerAssetCount;

    event AssetAllocated(address indexed _verifiedOwner,
                         uint256 indexed _totalAssetCount, string _assetName);

    function allocateAsset(address _verifiedOwner,
                           string memory _assetName) public onlyOwner {
        // TODO: implement

        // Event: an event can help you debug the smart contract or it can
        // be used as an alert for the user of the wallet, signalling
        // some event
        emit AssetAllocated(_verifiedOwner, mapOwnerAssetCount[_verifiedOwner], _assetName);
    }

    function getMapOwnerAssetCount(address _addr) public view returns(uint) {
         return mapOwnerAssetCount[_addr];
    }
}

{% solution %}
pragma solidity ^0.4.24;

contract TradeSyndication {

    address public owner;
    uint public totalNumberOfAssets;

    mapping (address => mapping (uint256 => Asset)) public mapOwnerAssets;
    mapping (address => uint256) public mapOwnerAssetCount;

    struct Asset {
        string name;
        bool isSold;
    }

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event AssetAllocated(address indexed _verifiedOwner, uint256 indexed _totalAssetCount, string _assetName);

    function allocateAsset(address _verifiedOwner, string memory _assetName) public onlyOwner {

        uint assetIndex = mapOwnerAssetCount[_verifiedOwner];
        mapOwnerAssets[_verifiedOwner][assetIndex] = Asset({name : _assetName, isSold : false});
        mapOwnerAssetCount[_verifiedOwner]++;
        totalNumberOfAssets++;

        // Event
        emit AssetAllocated(_verifiedOwner, mapOwnerAssetCount[_verifiedOwner], _assetName);
    }

    function getMapOwnerAssetCount(address _addr) public view returns(uint) {
         return mapOwnerAssetCount[_addr];
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'TradeSyndication.sol';

contract TestTradeSyndication {
  TradeSyndication tis = TradeSyndication();

  function testAllocateAsset() public {
    tis.allocateAsset(msg.sender, "test asset");
    // uint result = tis.getMapOwnerAssetCount(msg.sender);
    // uint expected = 1;
    // Assert.equal(result, expected, "Asset has not been correctly allocated");
  }

  event TestEvent(bool indexed result, string message);

}


{% endexercise %}

[](----------------------------------------------------------------------------)

[](Exercise 2)
{% exercise %}
Write a function called `getOwnedAssetCountForAddress` which is `public` and returns a `uint256`.
The returned value represents the number of unsold assets that are registered
for `_ownerAddress`. Hint: use the asset count map to iterate over the owner's portofolio.

{% initial %}
pragma solidity ^0.4.24;

contract TradeSyndication {

    address public owner;
    uint public totalNumberOfAssets;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct Asset {
        string name;
        bool isSold;
    }

    mapping (address => mapping (uint256 => Asset)) public mapOwnerAssets;
    mapping (address => uint256) public mapOwnerAssetCount;

    event AssetAllocated(address indexed _verifiedOwner,
                         uint256 indexed _totalAssetCount, string _assetName);

    function allocateAsset(address _verifiedOwner,
                          string memory _assetName) public onlyOwner {
        uint assetIndex = mapOwnerAssetCount[_verifiedOwner];
        mapOwnerAssets[_verifiedOwner][assetIndex] = Asset({name : _assetName, isSold : false});
        mapOwnerAssetCount[_verifiedOwner]++;
        totalNumberOfAssets++;

        // Event
        emit AssetAllocated(_verifiedOwner, mapOwnerAssetCount[_verifiedOwner], _assetName);
    }

    function getOwnedAssetCountForAddress(address _ownerAddress) public view returns(uint256){
         // TODO: implement
    }
}

{% solution %}
pragma solidity ^0.4.24;

contract TradeSyndication {

    address public owner;
    uint public totalNumberOfAssets;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct Asset {
        string name;
        bool isSold;
    }

    mapping (address => mapping (uint256 => Asset)) public mapOwnerAssets;
    mapping (address => uint256) public mapOwnerAssetCount;

    event AssetAllocated(address indexed _verifiedOwner, uint256 indexed _totalAssetCount, string _assetName);

    function allocateAsset(address _verifiedOwner, string memory _assetName) public onlyOwner {
        uint assetIndex = mapOwnerAssetCount[_verifiedOwner];
        mapOwnerAssets[_verifiedOwner][assetIndex] = Asset({name : _assetName, isSold : false});
        mapOwnerAssetCount[_verifiedOwner]++;
        totalNumberOfAssets++;

        // Event
        emit AssetAllocated(_verifiedOwner, mapOwnerAssetCount[_verifiedOwner], _assetName);
    }

    function getOwnedAssetCountForAddress(address _ownerAddress) public view returns(uint256){
         uint count = 0;
         for(uint256 i = 0; i < mapOwnerAssetCount[_ownerAddress]; i++) {
             if(!mapOwnerAssets[_ownerAddress][i].isSold) {
               // if not sold, then he still owns it
               count++;
             }
         }
         return count;
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'TradeSyndication.sol';

contract TestTradeSyndication {
  TradeSyndication tis = TradeSyndication();

  function testAllocateAsset() public {
    tis.allocateAsset(msg.sender, "test asset");
    uint result = tis.getOwnedAssetCountForAddress(msg.sender);
    uint expected = 1;
    Assert.equal(result, expected, "Asset has not been correctly allocated");
  }

  function testAllocateMultipleAssets() public {
    tis.allocateAsset(msg.sender, "test asset 1");
    tis.allocateAsset(msg.sender, "test asset 2");
    tis.allocateAsset(msg.sender, "test asset 3");
    uint result = tis.getOwnedAssetCountForAddress(msg.sender);
    uint expected = 4; // Because test asset has been prev allocated in above test
    Assert.equal(result, expected, "Assets have not been correctly allocated");
  }

  event TestEvent(bool indexed result, string message);

}

{% endexercise %}

[](----------------------------------------------------------------------------)


[](Exercise 3)

{% exercise %}
Write a function called `isOwner` which checks whether a given asset is in the
portofolio of an address and that asset is not sold. Hint: you will need
to implement a helper function that checks if two strings are equal.

{% initial %}
pragma solidity ^0.4.24;

contract TradeSyndication {

    address public owner;
    uint public totalNumberOfAssets;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct Asset {
        string name;
        bool isSold;
    }

    mapping (address => mapping (uint256 => Asset)) public mapOwnerAssets;
    mapping (address => uint256) public mapOwnerAssetCount;

    event AssetAllocated(address indexed _verifiedOwner,
                         uint256 indexed _totalAssetCount, string _assetName);
    event AssetTransferred(address indexed _from, address indexed _to, string _assetName);

    function getOwnedAssetCountForAddress(address _ownerAddress) public view returns(uint256){
         uint count = 0;
         for(uint256 i = 0; i < mapOwnerAssetCount[_ownerAddress]; i++) {
             if(!mapOwnerAssets[_ownerAddress][i].isSold) {
               // if not sold, then he still owns it
               count++;
             }
         }
         return count;
    }

    function allocateAsset(address _verifiedOwner, string memory _assetName) public onlyOwner {
        uint assetIndex = mapOwnerAssetCount[_verifiedOwner];
        mapOwnerAssets[_verifiedOwner][assetIndex] = Asset({name : _assetName,
                                                           isSold : false});
        mapOwnerAssetCount[_verifiedOwner]++;
        totalNumberOfAssets++;

        // Event
        emit AssetAllocated(_verifiedOwner, mapOwnerAssetCount[_verifiedOwner], _assetName);
    }

    function isOwner(address _potentialOwner, string memory _assetName) public view returns(int) {
        // TODO: implement
    }

    function stringsEqual(string memory s1, string memory s2) private pure returns(bool) {
        // TODO: implement
    }

{% solution %}
pragma solidity ^0.4.24;

contract TradeSyndication {

    address public owner;
    uint public totalNumberOfAssets;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct Asset {
        string name;
        bool isSold;
    }

    mapping (address => mapping (uint256 => Asset)) public mapOwnerAssets;
    mapping (address => uint256) public mapOwnerAssetCount;

    event AssetAllocated(address indexed _verifiedOwner, uint256 indexed _totalAssetCount, string _assetName);
    event AssetTransferred(address indexed _from, address indexed _to, string _assetName);

    function getOwnedAssetCountForAddress(address _ownerAddress) public view returns(uint256){
         uint count = 0;
         for(uint256 i = 0; i < mapOwnerAssetCount[_ownerAddress]; i++) {
             if(!mapOwnerAssets[_ownerAddress][i].isSold) {
               // if not sold, then he still owns it
               count++;
             }
         }
         return count;
    }

    function allocateAsset(address _verifiedOwner, string memory _assetName) public onlyOwner {
        uint assetIndex = mapOwnerAssetCount[_verifiedOwner];
        mapOwnerAssets[_verifiedOwner][assetIndex] = Asset({name : _assetName, isSold : false});
        mapOwnerAssetCount[_verifiedOwner]++;
        totalNumberOfAssets++;

        // Event
        emit AssetAllocated(_verifiedOwner, mapOwnerAssetCount[_verifiedOwner], _assetName);
    }

    function isOwner(address _potentialOwner, string memory _assetName) public view returns(int) {
        for(uint256 i = 0; i < mapOwnerAssetCount[_potentialOwner]; i++) {
            string memory currentAssetName = mapOwnerAssets[_potentialOwner][i].name;
            if(stringsEqual(currentAssetName, _assetName)) {
               // if it is not sold, then he still owns it
               bool stillOwned = !mapOwnerAssets[_potentialOwner][i].isSold;
               return stillOwned ? int(i) : -1;
            }
        }
        return -1;
    }

    function stringsEqual(string memory s1, string memory s2) private pure returns(bool) {
        return keccak256(bytes(s1)) == keccak256(bytes(s2));
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'TradeSyndication.sol';

contract TestTradeSyndication {
  TradeSyndication tis = TradeSyndication();

  function testAllocateAsset() public {
    tis.allocateAsset(msg.sender, "test asset");
    uint result = tis.getOwnedAssetCountForAddress(msg.sender);
    uint expected = 1;
    Assert.equal(result, expected, "Asset has not been correctly allocated");
  }

  function testAllocateMultipleAssets() public {
    tis.allocateAsset(msg.sender, "test asset 1");
    tis.allocateAsset(msg.sender, "test asset 2");
    tis.allocateAsset(msg.sender, "test asset 3");
    uint result = tis.getOwnedAssetCountForAddress(msg.sender);
    uint expected = 4; // Because test asset has been prev allocated in above test
    Assert.equal(result, expected, "Assets have not been correctly allocated");
  }

  function testIsOwner() public {
    tis.allocateAsset(msg.sender, "test asset 4");
    int resultIndex   = tis.isOwner(msg.sender, "test asset 4");
    int expectedIndex = 4;
    Assert.equal(resultIndex, expectedIndex, "The message sender should own the asset");
    address someAddress = 0xeB69331eE6C91C97FDE4B11ab0f8b69F6c7fCf2D;
    resultIndex = tis.isOwner(someAddress, "test asset 4");
    expectedIndex = -1;
    Assert.equal(resultIndex, expectedIndex, "The random address should not own this asset");
  }

  event TestEvent(bool indexed result, string message);

}

{% endexercise %}



[](----------------------------------------------------------------------------)


[](Exercise 4)

{% exercise %}
Define a function `transerAsset` such that after it terminates, the asset appears
as sold in the seller's portofolio and the buyer's portofolio is populated with
a new (unsold) asset.

{% initial %}
pragma solidity ^0.4.24;

contract TradeSyndication {

    address public owner;
    uint public totalNumberOfAssets;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct Asset {
        string name;
        bool isSold;
    }

    mapping (address => mapping (uint256 => Asset)) public mapOwnerAssets;
    mapping (address => uint256) public mapOwnerAssetCount;

    event AssetAllocated(address indexed _verifiedOwner, uint256 indexed _totalAssetCount, string _assetName);
    // TODO: define event AssetTransferred

    function getOwnedAssetCountForAddress(address _ownerAddress) public view returns(uint256){
         uint count = 0;
         for(uint256 i = 0; i < mapOwnerAssetCount[_ownerAddress]; i++) {
             if(!mapOwnerAssets[_ownerAddress][i].isSold) {
               // if not sold, then he still owns it
               count++;
             }
         }
         return count;
    }

    function allocateAsset(address _verifiedOwner, string memory _assetName) public onlyOwner {
        uint assetIndex = mapOwnerAssetCount[_verifiedOwner];
        mapOwnerAssets[_verifiedOwner][assetIndex] = Asset({name : _assetName, isSold : false});
        mapOwnerAssetCount[_verifiedOwner]++;
        totalNumberOfAssets++;

        // Event
        emit AssetAllocated(_verifiedOwner, mapOwnerAssetCount[_verifiedOwner], _assetName);
    }

    function isOwner(address _potentialOwner, string memory _assetName) public view returns(int) {
        for(uint256 i = 0; i < mapOwnerAssetCount[_potentialOwner]; i++) {
            string memory currentAssetName = mapOwnerAssets[_potentialOwner][i].name;
            if(stringsEqual(currentAssetName, _assetName)) {
               // if it is not sold, then he still owns it
               bool stillOwned = !mapOwnerAssets[_potentialOwner][i].isSold;
               return stillOwned ? int(i) : -1;
            }
        }
        return -1;
    }

    function stringsEqual(string memory s1, string memory s2) private pure returns(bool) {
        return keccak256(bytes(s1)) == keccak256(bytes(s2));
    }


    function transferAsset(address _from, address _to, string memory _assetName) public returns(bool) {
        // TODO: implement
    }
}


{% solution %}
pragma solidity ^0.4.24;

contract TradeSyndication {

    address public owner;
    uint public totalNumberOfAssets;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct Asset {
        string name;
        bool isSold;
    }

    mapping (address => mapping (uint256 => Asset)) public mapOwnerAssets;
    mapping (address => uint256) public mapOwnerAssetCount;

    event AssetAllocated(address indexed _verifiedOwner, uint256 indexed _totalAssetCount, string _assetName);
    event AssetTransferred(address indexed _from, address indexed _to, string _assetName);

    function getOwnedAssetCountForAddress(address _ownerAddress) public view returns(uint256){
         uint count = 0;
         for(uint256 i = 0; i < mapOwnerAssetCount[_ownerAddress]; i++) {
             if(!mapOwnerAssets[_ownerAddress][i].isSold) {
               // if not sold, then he still owns it
               count++;
             }
         }
         return count;
    }

    function allocateAsset(address _verifiedOwner, string memory _assetName) public onlyOwner {
        uint assetIndex = mapOwnerAssetCount[_verifiedOwner];
        mapOwnerAssets[_verifiedOwner][assetIndex] = Asset({name : _assetName, isSold : false});
        mapOwnerAssetCount[_verifiedOwner]++;
        totalNumberOfAssets++;

        // Event
        emit AssetAllocated(_verifiedOwner, mapOwnerAssetCount[_verifiedOwner], _assetName);
    }

    function isOwner(address _potentialOwner, string memory _assetName) public view returns(int) {
        for(uint256 i = 0; i < mapOwnerAssetCount[_potentialOwner]; i++) {
            string memory currentAssetName = mapOwnerAssets[_potentialOwner][i].name;
            if(stringsEqual(currentAssetName, _assetName)) {
               // if it is not sold, then he still owns it
               bool stillOwned = !mapOwnerAssets[_potentialOwner][i].isSold;
               return stillOwned ? int(i) : -1;
            }
        }
        return -1;
    }

    function stringsEqual(string memory s1, string memory s2) private pure returns(bool) {
        return keccak256(bytes(s1)) == keccak256(bytes(s2));
    }


    function transferAsset(address _from, address _to, string memory _assetName) public returns(bool) {
        int assetIndex = isOwner(_from, _assetName);
        if(assetIndex == -1) {
           // he does not own the asset
           return false;
        } else {
          // owns the asset
          mapOwnerAssets[_from][uint(assetIndex)].isSold = true;
          allocateAsset(_to,_assetName);

          emit AssetTransferred(_from, _to, _assetName);
          return true;
        }
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'TradeSyndication.sol';

contract TestTradeSyndication {
  TradeSyndication testTradeInstance =  TradeSyndication();

  function testTransferScenario() public {
    address buyer = 0xeB69331eE6C91C97FDE4B11ab0f8b69F6c7fCf2D;
    address seller = 0x970746De145044Df2c1Ff2D4a6E4195f2BeB7533;

    testTradeInstance.allocateAsset(seller, "Asset");

    uint countSeller = testTradeInstance.getOwnedAssetCountForAddress(seller);
    Assert.equal(countSeller, 1, "seller should have one asset");
    int sellerIndex = testTradeInstance.isOwner(seller, "Asset");
    Assert.equal(sellerIndex, 0, "seller should have one asset at index 0");

    uint countBuyer = testTradeInstance.getOwnedAssetCountForAddress(buyer);
    Assert.equal(countBuyer, 0, "buyer should have zero assets");
    int buyerIndex = testTradeInstance.isOwner(buyer, "Asset");
    Assert.equal(buyerIndex, -1, "buyer should have zero assets, index -1");

    testTradeInstance.transferAsset(seller, buyer, "Asset");

    uint countSellerAfter = testTradeInstance.getOwnedAssetCountForAddress(seller);
    Assert.equal(countSellerAfter, 0, "seller should have zero assets");
    int sellerIndexAfter = testTradeInstance.isOwner(seller, "Asset");
    Assert.equal(sellerIndexAfter, -1, "seller should have zero assets, index -1");
    uint countBuyerAfter = testTradeInstance.getOwnedAssetCountForAddress(buyer);
    Assert.equal(countBuyerAfter, 1, "buyer should have one asset");
    int buyerIndexAfter = testTradeInstance.isOwner(buyer, "Asset");
    Assert.equal(buyerIndexAfter, 0, "buyer should have one aset at index 0");
  }

  event TestEvent(bool indexed result, string message);
}


{% endexercise %}




## Trade Invest Syndication

Now that you have visibility over the market, it is
time to invest resources in what you believe to be most valuable in the future and
see your investment grow. One of the best investments you can make right now is
to learn how to extend this market with the new functionality.

You will now create a contract called TradeInvestSyndication, which is derived
from TradeSyndication and adds extra functionality, letting you invest in assets.
In Solidity, inheritance is similar to other object oriented programming languages.


{% exercise %}
Write a function called `invest`, which uses the two defined events to register
the investment or to declare failure. The investment is registered if the
specified owner `isOwner` of the specified asset name. Hint: you have access
to all functions of the base asset! To thest your implementation, check that
the events are triggered in your wallet software.

{% initial %}
pragma solidity ^0.4.24;

contract TradeSyndication {

    address public owner;
    uint public totalNumberOfAssets;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct Asset {
        string name;
        bool isSold;
    }

    mapping (address => mapping (uint256 => Asset)) public mapOwnerAssets;
    mapping (address => uint256) public mapOwnerAssetCount;

    event AssetAllocated(address indexed _verifiedOwner, uint256 indexed _totalAssetCount, string _assetName);
    event AssetTransferred(address indexed _from, address indexed _to, string _assetName);

    function getOwnedAssetCountForAddress(address _ownerAddress) public view returns(uint256){
         uint count = 0;
         for(uint256 i = 0; i < mapOwnerAssetCount[_ownerAddress]; i++) {
             if(!mapOwnerAssets[_ownerAddress][i].isSold) {
               // if not sold, then he still owns it
               count++;
             }
         }
         return count;
    }

    function allocateAsset(address _verifiedOwner, string memory _assetName) public onlyOwner {
        uint assetIndex = mapOwnerAssetCount[_verifiedOwner];
        mapOwnerAssets[_verifiedOwner][assetIndex] = Asset({name : _assetName, isSold : false});
        mapOwnerAssetCount[_verifiedOwner]++;
        totalNumberOfAssets++;

        // Event
        emit AssetAllocated(_verifiedOwner, mapOwnerAssetCount[_verifiedOwner], _assetName);
    }

    function isOwner(address _potentialOwner, string memory _assetName) public view returns(int) {
        for(uint256 i = 0; i < mapOwnerAssetCount[_potentialOwner]; i++) {
            string memory currentAssetName = mapOwnerAssets[_potentialOwner][i].name;
            if(stringsEqual(currentAssetName, _assetName)) {
               // if it is not sold, then he still owns it
               bool stillOwned = !mapOwnerAssets[_potentialOwner][i].isSold;
               return stillOwned ? int(i) : -1;
            }
        }
        return -1;
    }

    function stringsEqual(string memory s1, string memory s2) private pure returns(bool) {
        return keccak256(bytes(s1)) == keccak256(bytes(s2));
    }


    function transferAsset(address _from, address _to, string memory _assetName) public returns(bool) {
        int assetIndex = isOwner(_from, _assetName);
        if(assetIndex == -1) {
           // he does not own the asset
           return false;
        } else {
          // owns the asset
          mapOwnerAssets[_from][uint(assetIndex)].isSold = true;
          allocateAsset(_to,_assetName);

          emit AssetTransferred(_from, _to, _assetName);
          return true;
        }
    }
}

contract TradeInvestSyndication is /*TODO: insert*/ {

    string public syndicationName;

    constructor(string memory _syndicationName) public TradeSyndication() {
       syndicationName = _syndicationName;
    }

    event InvestmentUnsuccessful(address _owner, uint _value, string _assetName);
    event RegisterInvestment(address _owner, uint _value, string _assetName);

    // Invest in someone's assetty
    function invest(address _owner, uint _value, string memory _assetName) public {
       // TODO: implement
    }
}



{% solution %}
pragma solidity ^0.4.24;


contract TradeSyndication {

    address public owner;
    uint public totalNumberOfAssets;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct Asset {
        string name;
        bool isSold;
    }

    mapping (address => mapping (uint256 => Asset)) public mapOwnerAssets;
    mapping (address => uint256) public mapOwnerAssetCount;

    event AssetAllocated(address indexed _verifiedOwner, uint256 indexed _totalAssetCount, string _assetName);
    event AssetTransferred(address indexed _from, address indexed _to, string _assetName);

    function getOwnedAssetCountForAddress(address _ownerAddress) public view returns(uint256){
         uint count = 0;
         for(uint256 i = 0; i < mapOwnerAssetCount[_ownerAddress]; i++) {
             if(!mapOwnerAssets[_ownerAddress][i].isSold) {
               // if not sold, then he still owns it
               count++;
             }
         }
         return count;
    }

    function allocateAsset(address _verifiedOwner, string memory _assetName) public onlyOwner {
        uint assetIndex = mapOwnerAssetCount[_verifiedOwner];
        mapOwnerAssets[_verifiedOwner][assetIndex] = Asset({name : _assetName, isSold : false});
        mapOwnerAssetCount[_verifiedOwner]++;
        totalNumberOfAssets++;

        // Event
        emit AssetAllocated(_verifiedOwner, mapOwnerAssetCount[_verifiedOwner], _assetName);
    }

    function isOwner(address _potentialOwner, string memory _assetName) public view returns(int) {
        for(uint256 i = 0; i < mapOwnerAssetCount[_potentialOwner]; i++) {
            string memory currentAssetName = mapOwnerAssets[_potentialOwner][i].name;
            if(stringsEqual(currentAssetName, _assetName)) {
               // if it is not sold, then he still owns it
               bool stillOwned = !mapOwnerAssets[_potentialOwner][i].isSold;
               return stillOwned ? int(i) : -1;
            }
        }
        return -1;
    }

    function stringsEqual(string memory s1, string memory s2) private pure returns(bool) {
        return keccak256(bytes(s1)) == keccak256(bytes(s2));
    }


    function transferAsset(address _from, address _to, string memory _assetName) public returns(bool) {
        int assetIndex = isOwner(_from, _assetName);
        if(assetIndex == -1) {
           // he does not own the asset
           return false;
        } else {
          // owns the asset
          mapOwnerAssets[_from][uint(assetIndex)].isSold = true;
          allocateAsset(_to,_assetName);

          emit AssetTransferred(_from, _to, _assetName);
          return true;
        }
    }
}

contract TradeInvestSyndication is TradeSyndication {

    string public syndicationName;

    constructor(string memory _syndicationName) public TradeSyndication() {
       syndicationName = _syndicationName;
    }

    event InvestmentUnsuccessful(address _owner, uint _value, string _assetName);
    event RegisterInvestment(address _owner, uint _value, string _assetName);

    // Invest in someone's assetty
    function invest(address _owner, uint _value, string memory _assetName) public {
      int assetIndex = isOwner(_owner, _assetName);
      if(assetIndex == -1) {
        emit InvestmentUnsuccessful(_owner, _value, _assetName);
      } else {
        emit RegisterInvestment(_owner, _value, _assetName);
      }
    }
}


{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'TradeSyndication.sol';
import 'TradeInvestSyndication.sol';

contract TestTradeInvestSyndication {
    TradeInvestSyndication tis =  TradeInvestSyndication();

    function testTransferScenario() public {
        tis.allocateAsset(msg.sender, "test asset 1");
        tis.invest(msg.sender, 10, "test asset 1");
    }

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}



Now you have the tools to extend the smart contract implementation with more
complex interactions. You should also know that deploying the derived smart
contract will copy the code of
the base contract into the deployed contract. If you think about it, the EVM
works with bytecode, so all you are doing by inheritance is using a sequence
of bytecode instructions from another contract.


Part of the tutorial adapted from: Building Ethereum Dapp using Solidity | Ethereum Dapp Tutorial |
Ethereum Developer Course | Edureka, https://www.youtube.com/watch?v=iRD07URfVdM
