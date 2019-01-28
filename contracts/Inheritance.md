# Inheritance

We have gone through variables, but what's next?

## Protecting your SpaceMuffin

Let's start with an example.
In previous exercises, you ensured that the SpaceMuffin is protected by requiring a password to be able to take a bite. But everyone who knows the password, "Space Space Muffin" can take a bite out of the SpaceMuffin. What if we want only the owner of the SpaceMuffin (you) to be able to take a bite? 
The following code shows what you did until now.
```solidity
contract SpaceMuffin {
  uint private bite = 0;

  function eat(bytes32 _password) public {
    // It should require the correct password
    require(_password == "Space Space Muffin");
    // Then the hungry user is allow to take a bite
    bite = bite + 1;
  }

  function getNumberOfBites() public view returns (uint) {
    return bites;
  }
}
```

To achieve this we can use inheritance. 
In Solidity, inheritance is specified by using the "is" keyword when defining a contract. 
For example, if we have a contract called Muffin, and our SpaceMuffin contract, we can write "SpaceMuffin is Muffin".
Rememeber the internal keyword? A function or variable that is internal can be accessed from the contract in which it is defined and any derived contracts.
Our SpaceMuffin can use any member of the Muffin contract that is not private.

{% exercise %}
Use `internal` to let users bite and eat the `SpaceMuffin`.

{% initial %}
pragma solidity ^0.4.24;

contract Muffin {
  function bite() private pure returns (bool) {
    return true;
  }
}

contract SpaceMuffin is Muffin {
  function eat() public pure returns (bool) {
    return bite();
  }
}

{% solution %}
pragma solidity ^0.4.24;

contract Muffin {
  function bite() internal pure returns (bool) {
    return true;
  }
}

contract SpaceMuffin is Muffin {
  function eat() public pure returns (bool) {
    return bite();
  }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Muffin.sol';
import 'SpaceMuffin.sol';

contract TestMuffin {
  SpaceMuffin muffin = SpaceMuffin(__ADDRESS__);
  
  function testOnly() public {
    bool result = muffin.eat();
    bool expected = true;
    Assert.equal(result, expected, "You need to let SpaceMuffin access the bite function!");
  }

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

A common pattern in Solidity is defining a Owned contract with a modifier which gives only the contract owner address the ability to access certain functions.

{% exercise %}
Write a modifier called `onlyOwner` in `Owned` which checks that the `sender` is the `owner`, and then use the modifier to protect the `eat` function in `SpaceMuffin`.

{% initial %}
pragma solidity ^0.4.24;

contract Owned {
    address private owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
   // write your modifier here
   modifier 

   //don't touch this! this is required for testing
   function setOwner(address a) public { owner = a; }
}

contract SpaceMuffin is Owned {
  uint public bite = 0;

  function eat(bytes32 _password) /* your modifier here */ public {
    // Check the password
    require(_password == "Space Space Muffin");
    // Allow the user to take a bite
    bite = bite + 1;
  }
  
  function getNumberOfBites() public view returns (uint) {
    return bites;
  }
}



{% solution %}
pragma solidity ^0.4.24;

contract Owned {
    address private owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
   // write your modifier here
   modifier onlyOwner {
       require(msg.sender == owner);
       _;
   }
   
   //don't touch this! this is required for testing
   function setOwner(address a) public { owner = a; }
}

contract SpaceMuffin is Owned {
  uint public bites = 0;

  function eat(bytes32 _password) onlyOwner public{
    // Check the password
    require(_password == "Super Super Muffin");
    // Allow the user to take a bite
    bites = bites + 1;
  }
  
  function getNumberOfBites() public view returns (uint) {
    return bites;
  }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Owned.sol';
import 'SpaceMuffin.sol';

contract TestMuffin {
  SpaceMuffin muffin = SpaceMuffin(__ADDRESS__);
  
  function testOnly() public {
    muffin.setOwner(this);
    muffin.eat("Super Super Muffin");
    uint expected = 1;
    uint result = muffin.getNumberOfBites();
    Assert.equal(result, expected, "You did something wrong");
  }

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

Bonus: In the Owned contract I said that the function setOwner is required for testing. Can you think why?   

Hint: When testing, I use a SpaceMuffin contract as a member of a TestContract. If I call a function of the SpaceMuffin within my TestContract, who is the sender?  

Solution: The sender will be the address of the TestContract, which is different from the owner, which is your address. This is why, to be able to use the eat function I need to modify the owner to the address of the TestContract.  

Now you've discovered inheritance in Solidity! (Still plently to say, but let see what's after)

