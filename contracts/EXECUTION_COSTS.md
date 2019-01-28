# Execution costs

We have seen that Ethereum allows to remotely execute operations on a global machine, the *Ethereum Virtual Machine* (EVM). You are paying for the computation. This cost is quantified in Gas. Gas is the internal pricing for running a transaction or contract in Ethereum. This fee is paid to miners.
The more complex the commands you wish to execute, the more Gas you have to pay to the miners.

When you execute a transaction, two things are specified:
* __Gas Limit__: the maximum number of Gas you are willing to spend on the transaction. For each low level operation performed in the EVM, a certain amount of Gas is needed. Specifying a maximum amount of Gas to be burnt during the transaction protects the redeemer from spending too much (for example if he toggles an infinite while loop).
* __Gas Price__: in ETH (or GWEI=10<sup>-9</sup> ETH). It is the price you are willing to pay for a single unit of gas. A higher price of gas will get your transaction picked first by miners.

The following aims at demonstrating the above principles.

{% hints %} The Appendix G of [Ethereum's yellow paper](https://ethereum.github.io/yellowpaper/paper.pdf) specifies the gas cost for each operation.

## A dummy contract

Let's start with this very simple contract that stores a count of people.
```solidity
contract Counter {
  uint256 people = 0;
  
  // Tell you how many people have been counted
  function population() public view (uint256) {
    return people;
  }
}
```

Now, write two functions:
* `count1`, which is public and:
	* sets `people` to 0,
	* updates `people` to 10 000 in one operation,
	* returns `people`.
* `count2`, which is public and:
	* sets `people` to 0,
	* updates `people` to 10 000 by incrementing it 10 000 times in a for loop,
	* returns `people`.

These two functions have the same side effect, but `count2` does it far less efficiently. We will see this has an impact on the execution cost of the contract.

(read the next section before submitting)

{% exercise %}
Write the functions called `count1` and `count2` as specified above.

{% initial %}
pragma solidity ^0.4.24;

contract Counter {
  uint256 people = 0;
  
  // Tell you how many people have been counted
  function population() public view returns (uint256){
      return people;
  }
  
  // Declare your function below
}

{% solution %}
pragma solidity ^0.4.24;

contract Counter {
  uint256 people = 0;
  
  // Tell you how many people have been counted
  function population() public view returns (uint256){
      return people;
  }
  
  // Solution
  function count1() public returns (uint256)
  {
    people = 0;
    people = 10000;
    return people;
  }
    
  function count2() public returns (uint256)
  {
    people = 0;
    uint256 i;
    for(i=0; i<10001; i++)
    {
      people = i;
    }
    return people;
  }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Counter.sol';

contract TestCounter {
  Counter counter = Counter(__ADDRESS__);
  
  function testCounter1() public {
    uint256 result = counter.count1();
    uint256 expected = 10000;
    Assert.equal(result, expected, "Error counting people!");
  }
  
  function testCounter2() public {
    uint256 result = counter.count2();
    uint256 expected = 10000;
    Assert.equal(result, expected, "Error counting people!");
  }
  

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

## The impact on gas consumption

Now let's see how the inefficiency of `count2` impacts the redeemer.

When you submit the above contract, it is first deployed, and then `count1` and `count2` are called by the corresponding test contract. Each of those two calls is performed in a different transaction, hence the 2 contract interactions you have to confirm in Metamask.

Before confirming the contract interactions, edit the Gas Limit in Metamask (*Edit>Advanced>Gas Limit*). Try to set it to 50000 for both, then 500000, then 5000000 (without modifying the Gas price). You should observe the following:
* With Gas Limit = 50000: both transactions fail, because `count1` and `count2` both need more than 50000 Gas to run.
* With Gas Limit = 500000: one transaction fails, the other suceeds. The former corresponds to `count1`, the latter to `count2`.
* With Gas Limit = 5000000: both transactions succeed, since `count1` and `count2` both need less than 5000000 Gas to run.

This little experiment should make you realize the importance of writing efficient code for the EVM. Indeed, an inefficient code will have a higher cost of execution.


