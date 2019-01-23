# Creating a fundraising contract

Now that you master modifiers, structs, arrays and payables we are going to implement a fundraising contract.

## Contract behaviour

The behaviour of our fundraising contract is rather simple. It lets anyone donate ether to the contract. Only the owner of the contract is allowed to redeem the ether collected and may only do so once the goal has been reached. Besides, the owner may only collect the funds once, after which the contract will be destroyed.



{% exercise %}
Write a function called `redeem` which is `public`, may only be run by the `owner` of the contract. It should destroy the contract and send its funds to the owner if the goal has been reached or return the funds to the donators otherwise.

{% hints %}
The `selfdestruct(address recipient)` function destroys a contract and sends its funds to the `recipient` address.

{% initial %}
pragma solidity ^0.4.24;

contract Fundraising {
  bytes32 name;
  address public owner;
  uint public goal = 0.1 ether;
  uint public total = 0 ether;
  struct Donation {
    address donator;
    uint amount;
  }
  Donation[] public donations;

  constructor (bytes32 _name) public {
      name = _name;
      owner = msg.sender;
  }
  
  modifier securityCheck {
    require(msg.sender == owner);
    _;
  }
  
  // Donation function
  function donate() public payable {
    require(msg.value > 0);
    donations.push(Donation({donator: msg.sender, amount: msg.value}));
    total += msg.value;
  }
  
  // Write the redeem function: sends funds to the owner if goal has been reached, otherwise return funds

}

{% solution %}
pragma solidity ^0.4.24;

contract Fundraising {
  bytes32 name;
  address public owner;
  uint public goal = 0.1 ether;
  uint public total = 0 ether;
  struct Donation {
    address donator;
    uint amount;
  }
  Donation[] public donations;

  constructor (bytes32 _name) public {
      name = _name;
      owner = msg.sender;
  }
  
  modifier securityCheck {
    require(msg.sender == owner);
    _;
  }
  
  // Donation function
  function donate() public payable {
    require(msg.value > 0);
    donations.push(Donation({donator: msg.sender, amount: msg.value}));
    total += msg.value;
  }
  
  // Redeem function: sends funds to the owner if goal has been reached, otherwise return funds
  function redeem() public securityCheck {
      if (total >= goal) {
          // destroy the contract and send funds to the owner
          selfdestruct(owner);
      } else {
          // If goal not reacher send ether back to donators
          for (uint i=0; i<donations.length; i++) {
              donations[i].donator.transfer(donations[i].amount);
          }
      }
  }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Fundraising.sol';

contract TestFundraising {
   
    Fundraising fundraisingToTest = new Fundraising("My cool project");
    
    function checkReturn () public {
        uint myFirstBalance = address(this).balance;
        fundraisingToTest.donate.value(0.01 ether)();
        uint mySecondBalance = address(this).balance;
        fundraisingToTest.redeem();
        uint myThirdBalance = address(this).balance;
        Assert.isAbove(myFirstBalance, mySecondBalance, "Amount should be sent to contract");
        Assert.isAbove(myThirdBalance, mySecondBalance, "Amount should be returned");
        Assert.equal(address(this), fundraisingToTest.owner, "Contract should still exist and be owned by me");
    }
    
    function checkDestruction () public {
        address owner = address(this);
        fundraisingToTest.donate.value(0.1 ether)();
        uint ownerBalance = owner.balance;
        fundraisingToTest.redeem();
        Assert.equal(fundraisingToTest.owner(), uint(0), "Contract should be destroyed");
        Assert.isAbove(owner.balance, ownerBalance, "Owner should receive funds");
    }
}

{% endexercise %}
