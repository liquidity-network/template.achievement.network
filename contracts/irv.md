# Democracy on the Blockchain

In the following example, we will learn how to build a simple voting system.

Smart contracts are no strangers to voting. In fact, voting is possibly one of
the best and most obvious use cases for them - a smart contract allows complete
transparency in the voting process and avoids common pitfalls in conventional
voting which may involve ballot stuffing, malicious actors changing your vote,
and your vote not being considered at all. Election fraud is a common problem
in many countries around the world, but smart contracts can change that!

## First Past The Post (FPTP)

One common way of performing a vote is by using what's known as 'First Past The
Post' (FPTP) or 'simple plurality'. This is the system used in the United
Kingdom. Simply put, it means that every voter gets to choose one option from
a list, and the option with the greatest number of votes is declared the
winner.

First past the post works in some scenarios, but it has a number of problems:
For example, an option can win the vote with a very small number of total 
votes as long as it has more than any other individual option, and voters may 
end up voting not for whichever option they want, but rather against options 
they don't want.

## Instant-Runoff Voting (IRV)

Instant-Runoff Voting is a different type of voting system which has been
used for votes in some countries like Australia, India, and Ireland. The basic 
idea behind it is that you don't just vote for one option, but rather you rank 
all options in order of your preferences. Then, the option with the least 
'first ranked' votes get eliminated, and the voters for that option have their 
second preferences redistributed, until there are just two options left. Then,
the two options can be compared head-to-head in order to find the winner. In 
real life elections, this form of voting allows for proportional 
representation and allows minority groups to be represented -- essentially it 
is a fairer method of voting that more properly represents the way people 
voted.

That was a lot of explanation, so let's try to implement some of this!

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

## Just For Fun

{% e.g. add a payable for bribery %} 
