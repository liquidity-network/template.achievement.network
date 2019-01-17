
# Recursion


In this exercise we look at how to write recursive functions.

## What is it

**Recursion** is a common pattern in programming that is useful for solving problems by breaking the problem down into smaller instances. In programming, this is usually realised by allowing a function to call itself within the body of the function. Solidity is one such language that supports recursion.

## Example

Here is a simple example of recursion in Solidity. The function `eatMuffins` takes in a parameter `n` which describes how many muffins to eat, and it will repeatedly call itself until this number reaches 0.

```solidity
contract SpacecryptFactory {

	function eatMuffins(uint n) public {
		if (n == 0) {
			return;
		}
		eatMuffins(n-1);
	} 
}
```

## Call Stack

However, there is a limit to recursion. Each process has a finite address space and every time a function is called, the operating system will push the function onto the stack of the address space. This is needed so that when the function knows where to return once it has finished. The finite address space means that there is a limit to how many recursive calls can be made. If the process runs out of stack space, it will be unable to perform the recursive call and it will produce a stack overflow error.

```solidity
contract SpacecryptFactory {

	function eatMuffins() public pure {
		eatMuffins();
	} 
}
```
The above function never ends! This will quickly reach a stack overflow.

## Problem

Now that you are familiar with the idea, let's try an problem exercise. In this example, imagine you are an accountant and your boss has decided to ask you to work out how many different ways a number can be partitioned using a particular coin set. The coin set we will use is a subset of the GBP, which has denominations of {1, 2, 5, 20}. You can assume the given number will be between 1 and 500 inclusive. You must implement the solution using recursion. A stub function has been written to help you get started.

## Code

{% exercise %}
Recursion

{% initial %}
pragma solidity ^0.4.24;

contract Accountant {
  int[5] coinSet = [1,2,5,10,20];

  // Implement this function
  function partitions(int n) external view returns (uint) {
    
  }
}

{% solution %}
pragma solidity ^0.4.24;

contract Accountant {
  int[5] coinSet = [1,2,5,10,20];

  function partitions(int n) external view returns (uint) {
    return partitionsHelper(n, coinSet.length);
  }

  function partitionsHelper(int n, uint m) public view returns (uint) {
    if (n < 0) {
      return 0;
    } else if (n == 0) {
      return 1;
    } else if (m <= 0 && n >= 1) {
      return 0;
    } else {
      return partitionsHelper(n-coinSet[m-1], m) + partitionsHelper(n, m-1);
    }
  }
}

{% validation %}
// Tests need proper pragma
pragma solidity ^0.4.24;

// Assert library is available here
import 'Assert.sol';
// Import contracts, filenames should match contract names given in the solution
import 'Accountant.sol';

contract Tests {
  // Declare variable associated to the contract you want to test
  Accountant deployedAccountant = new Accountant();

  // test function
  // IMPORTANT: only one assertion per function
  function testPartitions1() public {
    uint result = deployedAccountant.partitions(5);
    uint expected = 4;
    Assert.equal(result, expected, "Partitions is not properly implemented");
  }
  
  //function testPartitions2() public {
  //  uint result = deployedAccountant.partitions(20);
  //  uint expected = 41;
  //  Assert.equal(result, expected, "Partitions is not properly implemented");
  //}
  //
  //function testPartitions3() public {
  //  uint result = deployedAccountant.partitions(50);
  //  uint expected = 450;
  //  Assert.equal(result, expected, "Partitions is not properly implemented");
  //}

  // event to communicate with the web interface
  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

The reason we only focus on a subset of the coin set is because as n gets larger the recursion tree exponentially grows in size, with lots of the smaller problems being calculated multiple times. This would mean computing higher values of n would take a long time. A better way would be to use dynamic programming, and I leave that implementation up to the curious reader.
