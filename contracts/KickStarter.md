

# Build your own application

Now that you have experimented with Smart Contracts, it is time to try and build your own smart contract application.

## Kickstarter

### What it is

Kickstarter is the world's biggest crowdfunding platform where creators can share projects they'd like to launch. Every project is independently crafted and total strangers can fund them in return for rewards, or the finished product itself.

### With Smart Contracts

Smart Contracts offer a convenient way of implementing such an application, where the contract creator sets a goal, and anyone can send money to fund the project.

After a certain amount of time, if the goal is reached, the administrator can either retrieve the funds and launch their project, or give up and pay back the donators.

### Instructions
Using the knowledge you have on smart contract, complete the following  `KickStarter` contract.

{% exercise %}
Complete the `cancelDonations` and `retrieveFunds` functions.
{% initial %}
```solidity
pragma solidity ^0.4.24;

contract KickStarter {
  
  uint public raised = 0;
  uint public goal = 1000;
  
  address private owner;
  
  // Keep track of all donations, but don't disclose them!
  mapping (address => uint) private donations;
  
  // We suppose this function is called once upon the deployement
  // of the contract.
  function setOwner() public{
      require(owner == 0x0);
      owner = msg.sender;
  }
  
  function fund() public payable {
    require(msg.value > 0);
    donations[msg.sender] += msg.value;
    raised = address(this).balance;
  }
  
  // Anyone can decide to withdraw their donation
  function cancelDonations() public{ 
    // YOUR CODE HERE: find the donation, pay the sender back 
    // and update the variables.
  }
  
  // The project administrator can only retrieve the funds once
  // the goal is reached.
  function retrieveFunds() public{
    // YOUR CODE HERE: The owner retrieves the funds, and updates
    // the variables.
    require(address(this).balance >= goal);
    require(msg.sender == owner);
    msg.sender.transfer(address(this).balance);
    raised = address(this).balance;
  }
  
}
````
{% solution %}
```solidity
pragma solidity ^0.4.24;

contract KickStarter {
  
  uint public raised = 0;
  uint public goal = 1000;
  
  address private owner;
  
  // Keep track of all donations, but don't disclose them!
  mapping (address => uint) private donations;
  
  // We suppose this function is called once upon the deployement
  // of the contract.
  function setOwner() public{
      require(owner == 0x0);
      owner = msg.sender;
  }
  
  // Anyone can decide to withdraw their donation
  function fund() public payable {
    require(msg.value > 0);
    donations[msg.sender] += msg.value;
    raised = address(this).balance;
  }
  

  function cancelDonations() public{
    require(donations[msg.sender] > 0);
    msg.sender.transfer(donations[msg.sender]);
    donations[msg.sender] = 0;
    raised = address(this).balance;
  }
  
  // The project administrator can only retrieve the funds once
  // the goal is reached.
  function retrieveFunds() public{
    require(address(this).balance >= goal);
    require(msg.sender == owner);
    msg.sender.transfer(address(this).balance);
    raised = address(this).balance;
  }
  
}
````
{% validation %}
```solidity
pragma solidity ^0.4.24;

// Assert library is available here
import 'Assert.sol';
// Import contracts, filenames should match contract names given in the solution
import 'KickStarter.sol';

contract TestKickStarter {
  // Declare variable associated to the contract you want to test
  // __ADDRESS__ specifies the contract is the one provided at runtime by the user
  KickStarter deployedContract = KickStarter(__ADDRESS__);
                
  // test function
  // IMPORTANT: only one assertion per function
  function testRetrieve() public payable{
    msg.value.call(1000);
    deployedContract.fund();
    deployedContract.retrieveFunds(0x70617373776f7264313233); // password123 in hex
  }

  function testCancel() public payable{
    msg.value.call(1000);
    deployedContract.fund();
    deployedContract.cancelDonations(0x70617373776f7264313233); // password123 in hex
  }

  // event to communicate with the web interface
  event TestEvent(bool indexed result, string message);
}
````
{% endexercise %}

**Hints** The value is stored in the smart contract and can only be unlocked once the goal is reached, by the right owner. Don’t forget to update the `raised` variable at the end of every function.

