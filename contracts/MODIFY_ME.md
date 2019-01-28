# Writing a MatchFund Contract

Using our knowledge of modifiers and msg attributes, let's try implementing a contract for a match fund.

Sometimes an entity may wish to give people an extra incentive to raise money for charity. A match fund achieves this by pledging that when someone makes a donation, the matching entity will make a donation of an equal value.

Our MatchFund contract wishes to do three things:
1. Allow anyone to become the fundraiser and set the charity.
2. Allow the fundraiser to pledge some funds upfront, and also any additional funds in the future.
4. Allow the fundraiser to end the fundraising, donating any matched funds.
3. Allow donations from anyone whilst funding is in progress.

But what happens if the donated value is fewer than that of the pledged funds?

## selfdestruct

`selfdestruct(address a)` is a function that destroys a contract and transfers all of the remaining money to the given address `a`. We can use this to transfer any accumulated money to an address once we are finished with a contract.

Here's an example:
```solidity
contract Piggybank {
  // Save it for a rainy day.
  function deposit() public payable {}
  
  // It's always a rainy day.
  function smash() public {
    selfdestruct(msg.sender)
  }
}
```

In the above example, the Piggybank contract will accumulate ether when it is paid via `deposit()`. Anyone can then `smash()` the Piggybank to receive the ether stored inside.

We are now ready to finish implementing our smart MatchFund.

{% exercise %}
Define the modifiers, add the relevant msg attributes, and finish `endFunding()` by filling in the `TODO`s.

{% hints %}
Does it make sense for `charity` to be `0`? How can we use interpret this value?

{% initial %}
pragma solidity ^0.4.24;

contract MatchFund {
    // Information about the fundraiser
    struct Fund {
        uint donated;
        address fundraiser;
    }
    Fund private fund;
    // Total donations made
    uint private donated;
    
    address private charity = 0;
    
    modifier charityNotSelected {
      // TODO: Enforce that a charity is not selected
    }
    
    modifier charitySelected {
      // TODO: Enforce that a charity is selected
    }
    
    modifier isFundraiser {
      // TODO: Enforce that the message came from the fundraiser
    }
    
    function startFunding(address newCharity) public charityNotSelected {
        charity = newCharity;
        fund.fundraiser = // TODO: Keep track of the fundraiser
    }
    
    function endFunding() public charitySelected isFundraiser {
        if(fund.donated > donated) {
            // Return unmatched funds
            fund.fundraiser.transfer(fund.donated - donated);
        }

        // TODO: Return the rest of the money to the fundraiser
    }
    
    function addFunds() public payable charitySelected isFundraiser {
        fund.donated += // TODO: Track the added matching funds
    }
    
    function donate() public payable charitySelected {
        donated += // TODO: Track the donated amount
    }
    
}

{% solution %}
pragma solidity ^0.4.24;

contract MatchFund {
    struct Fund {
        uint donated;
        address fundraiser;
    }
    Fund private fund;
    uint private donated;
    
    address private charity = 0;
    
    modifier charityNotSelected {
        require(charity == 0);
        _;
    }
    
    modifier charitySelected {
        require(charity != 0);
        _;
    }
    
    modifier isFundraiser {
        require(msg.sender == fund.fundraiser);
        _;
    }
    
    function startFunding(address newCharity) public charityNotSelected {
        charity = newCharity;
        fund.fundraiser = msg.sender;
    }
    
    function endFunding() public charitySelected isFundraiser {
        if(fund.donated > donated) {
            // Return unmatched funds
            fund.fundraiser.transfer(fund.donated - donated);
        }
        selfdestruct(charity);
    }
    
    function addFunds() public payable charitySelected isFundraiser {
        fund.donated += msg.value;
    }
    
    function donate() public payable charitySelected {
        donated += msg.value;
    }
    
}

{% validation %}
pragma solidity ^0.4.24;

import "Assert.sol";
import 'MatchFund.sol';

contract TestMatchFund {
    
    MatchFund mf = new MatchFund();
    
    function checkUnmatchedFunds() public {
      uint funded = 1 ether;
      address charity = 12345;
      
      mf.startFunding(charity);
      uint balanceBefore = address(this).balance;
      mf.addFunds.value(funded);
      mf.endFunding();
      uint balanceAfter = address(this).balance;
        
      Assert.equal(balanceBefore - funded, balanceAfter, "Unmatched fund should be returned");
    }
    
    function checkMatchedFunds() public returns (bool) {
      uint funded = 1 ether;
      uint donated = 1 ether;
      address charity = 12345;
      
      mf.startFunding(charity);
      uint balanceBefore = address(this).balance;
      mf.addFunds.value(funded);
      mf.donate.value(donated);
      mf.endFunding();
      uint balanceAfter = address(this).balance;
        
      Assert.equal(balanceBefore - funded, balanceAfter, "Matched fund should not be returned");
    }
    
    function checkOvermatchedFunds() public returns (bool) {
      uint funded = 1 ether;
      uint donated = 10 ether;
      address charity = 12345;
      
      mf.startFunding(charity);
      uint balanceBefore = address(this).balance;
      mf.addFunds.value(funded);
      mf.donate.value(donated);
      mf.endFunding();
      uint balanceAfter = address(this).balance;
        
      Assert.equal(balanceBefore - funded, balanceAfter, "Overmatched fund should not be returned");
    }
    
    function checkDoubleFunding() public returns (bool) {
      uint funded = 1 ether;
      uint repeat_funded = 1 ether;
      uint donated = 1.5 ether;
      uint difference = 0.5 ether;
      address charity = 12345;
      
      mf.startFunding(charity);
      uint balanceBefore = address(this).balance;
      mf.addFunds.value(funded);
      mf.donate.value(donated);
      mf.addFunds.value(repeat_funded);
      mf.endFunding();
      uint balanceAfter = address(this).balance;
        
      Assert.equal(balanceBefore - difference, balanceAfter, "Repeat funding should be allowed");
    }
    
    function checkDoubleDonation() public returns (bool) {
      uint funded = 2 ether;
      uint donated = 0.75 ether;
      uint repeat_donated = 0.75 ether;
      uint difference = 0.5 ether;
      address charity = 12345;
      
      mf.startFunding(charity);
      uint balanceBefore = address(this).balance;
      mf.addFunds.value(funded);
      mf.donate.value(donated);
      mf.donate.value(repeat_donated);
      mf.endFunding();
      uint balanceAfter = address(this).balance;
        
      Assert.equal(balanceBefore - difference, balanceAfter, "Repeat donations should be allowed");
    }
    
    function checkPartiallyMatchedFunds() public {
      uint funded = 1 ether;
      uint donated = 0.3 ether;
      uint difference = 0.7 ether;
      address charity = 12345;
      
      mf.startFunding(charity);
      uint balanceBefore = address(this).balance;
      mf.addFunds.value(funded);
      mf.donate.value(donated);
      mf.endFunding();
      uint balanceAfter = address(this).balance;
        
      Assert.equal(balanceBefore - difference, balanceAfter, "Partially matched fund difference should be returned");
    }
}


{% endexercise %}

You've created a match fund without pesky processing fees!

