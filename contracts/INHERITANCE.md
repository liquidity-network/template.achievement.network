# Functions

Now that we have explained classes, it's time to move on and discuss inheritance.

## Extend classes

Let's start with an example.
```solidity
contract SpaceMuffin {
  uint public count = 0;
    
  function like() public returns (uint) { 
    count = count + 1;
    return count;
  }
}

// Use the keyword "is" to derive from another contract
// You can then add extra functionality
contract SpaceChocolateMuffin is SpaceMuffin {
    
  function extraLike() public returns (uint) { 
    count = count + 2;
    return count;
  }
}
```

## Abstract Contracts

Contracts are marked as abstract when at least one of their functions lacks an implementation.

Abstract contracts cannot be compiled (even if they have some implemented functions alongside non-implemented ones), but they can be used as base contracts.

In the following exercise, SpaceMuffin is an example of an abstract contract.

{% exercise %}
Make the code compile and deploy the contract. The function should return the string 'chocolate'.

{% initial %}
pragma solidity ^0.4.24;

contract SpaceMuffin {
  function name() public returns (bytes32);
}

contract SpaceChocolateMuffin is SpaceMuffin {
  // your code goes here
}


{% solution %}
pragma solidity ^0.4.24;

contract SpaceMuffin {
  function name() public returns (bytes32);
}

contract SpaceChocolateMuffin is SpaceMuffin {
  function name() public returns (bytes32) { 
    return 'chocolate';
  }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'SpaceMuffin.sol';
import 'SpaceChocolateMuffin.sol';

contract TestMuffin {
  SpaceChocolateMuffin muffin = SpaceChocolateMuffin(__ADDRESS__);
  
  function testPeopleLikeMuffins() public {
    bytes32 result = muffin.name();
    bytes32 expected = 'chocolate';
    Assert.equal(result, expected, "People love chocolate muffins");
  }

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

If a contract inherits from an abstract contract and does not implement all non-implemented functions by overriding, it will itself be abstract.

## Visibility modifiers and inheritance

Remember the 4 visibility modifiers? It's time to use them again, but in the context of inheritance.

{% exercise %}
Change the visibility of state variable `count` in SpaceMuffin which is currently `private` to make it accessible from the subcontract

{% initial %}
pragma solidity ^0.4.24;

contract SpaceMuffin {
  // change the visibility qualifier to let SpaceChocolateMuffin update this value
  // public is not the right answer here
  uint private count = 0;
    
  function like() public returns (uint);
    
  function total() external view returns (uint) {
    return count;
  }
}

contract SpaceChocolateMuffin is SpaceMuffin {
  uint private chocolateCount = 0;
    
  function like() public returns (uint) { 
    count = count + 1;
    chocolateCount = chocolateCount + 1;
    return chocolateCount;
  }
}


{% solution %}
pragma solidity ^0.4.24;

contract SpaceMuffin {
  // try not to use public by default
  // in this case, internal would suffice
  uint internal count = 0;
    
  function like() public returns (uint);
    
  function total() external view returns (uint) {
    return count;
  }
}

contract SpaceChocolateMuffin is SpaceMuffin {
  uint private chocolateCount = 0;
    
  function like() public returns (uint) { 
    count = count + 1;
    chocolateCount = chocolateCount + 1;
    return chocolateCount;
  }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'SpaceMuffin.sol';
import 'SpaceChocolateMuffin.sol';

contract TestMuffin {
  SpaceChocolateMuffin muffin = SpaceChocolateMuffin(__ADDRESS__);
  
  function testPeopleLikeMuffins() public {
    uint result = muffin.like();
    uint expected = 1;
    Assert.equal(result, expected, "People love chocolate muffins");
  }

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

## Multiple Inheritance and Linearization

Languages that allow multiple inheritance have to deal with several problems, one of them being the Diamond Problem (link). Solidity follows the approach of Python and uses Linearization to enforce a specific order in the graph of base classes. This approach will disallow some inheritance graphs. This is why the order in which the base classes are listed in the is directive is important. 

In the following code, Solidity will give the compilation TypeError "Linearization of inheritance graph impossible".

```solidity
pragma solidity ^0.4.24;

contract X {
    
}

contract A is X {
    
}

// The order matters!
contract C is A, X {
  uint public x = 0;
  function like() public returns (uint) {
    x = x + 1;
    return x;
  }
}
```
The correct way should be:
```solidity
pragma solidity ^0.4.24;

contract X {
    
}

contract A is X {
    
}

// Just swap the base classes
contract C is X, A {
  uint private x = 0;
  
  function like() public returns (uint) {
    x = x + 1;
    return x;
  }
}
```


> Now you've mastered the basics of contract inheritance in Solidity! (Still plently to say, but let see what's after)

