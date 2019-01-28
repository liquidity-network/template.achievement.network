# Functions

We have gone through variables, but what's next?

## Declare functions

Let's start with an example.
```solidity
contract Muffin {
  uint people = 0;

  // Eat the virtual muffin and tell you how many people tried to do it (you included)
  function eat() public returns (uint) {
    people = people + 1;
    return people;
  }
}
```

{% exercise %}
Write a function called `like` which is `public` and returns a `bool` equal to `true`

{% initial %}
pragma solidity ^0.4.24;

contract Muffin {
  uint people = 0;

  // Eat the virtual muffin and tell you how many people tried to do it (you included)
  function eat() public returns (uint) {
    people = people + 1;
    return people;
  }

  // Declare your function below

}

{% solution %}
pragma solidity ^0.4.24;

contract Muffin {
  uint people = 0;

  // Eat the virtual muffin and tell you how many people tried to do it (you included)
  function eat() public returns (uint) {
    people = people + 1;
    return people;
  }

  // Declare your function below
  function like() pure public returns (bool) {
    return true;
  }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Muffin.sol';

contract TestMuffin {
  Muffin muffin = Muffin(__ADDRESS__);

  function testPeopleLikeMuffins() public {
    bool result = muffin.like();
    bool expected = true;
    Assert.equal(result, expected, "People likes muffin and you are telling the opposite");
  }

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

Now you've mastered functions in Solidity! (Still plently to say, but let see what's after)
