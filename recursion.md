# Simple recursion

## What is recursion

Recursion can be easily understood as a behavior that a function calls it self. Your job in this exercise is to write a simple recursion function in smart contract.

## ?: Syntax

In this exercise, you would probably need the ?: syntax. The ?: syntax is ' bool expression ? expression A : expression B '. If the bool expression is true, the result of this syntax(just like the return of a function) will be expression A, otherwise it will be expression B.

## Writing the contract

{% exercise %}
recursion

{% hints %}
- If you want a recursion to stop at some point, you need to give it a condition which the contract can use to decide whether to go further or not.
- You would probably use the ?: syntax above to create a condition.


{% initial %}
pragma solidity ^0.4.24;

contract CookieTokenAuction {
    
    uint public MuffinCount = 10;
    // At first you have 10 muffins;

    function TriedToTakeOneMuffinButCouldntStop() public{

        // Implement this function
        // You should continuously take one muffin until the total number of muffins goes to zero
        // When you took all the muffins, you should return the number of remain muffins

    }

}

{% solution %}
pragma solidity ^0.4.24;

contract Recursion {
    
    uint public MuffinCount = 10;
    // At first you have 10 muffins;

    function TriedToTakeOneMuffinButCouldntStop() public returns(uint){

        MuffinCount = MuffinCount - 1;
        // Take one muffin

        return MuffinCount > 0 ? TriedToTakeOneMuffinButCouldntStop() : MuffinCount;
        // Look into the remain muffins. If they are more than zero, take another one.

    }

}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Recursion.sol';

contract TestRecursion {

  //I didn't came up with a better test
  //Let's just assume that students really want to create their recursion function and they are honest.......

  Recursion deployedRecursion = Recursion(__ADDRESS__);

  function testRecursion() public {

  uint result = deployedRecursion.TriedToTakeOneMuffinButCouldntStop();
  uint expected = 0;

  Assert.equal(result,expected,"Recursion was not correctly done");

}

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

## More about recursion

This exercise is just the easiest one. There are many types of recursion(like direct recursion and indirect recursion) and many optimization algorithms about recursion(like memory based search algorithm). It's time to learn more!