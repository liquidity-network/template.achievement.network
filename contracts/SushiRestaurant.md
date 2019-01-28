# Recursion
This exercise introduces a concept of for-loop.

## What is it
A **for-loop** is a control flow statement for specifying iteration. Many modern programming languages support this operation, including Solidity.

## Example
The code below specifies a simple example of for-loop in Solidity. The `sellSushi` function iteratively consumes the existing sushi of SushiRestaurant by `n` amount.


```solidity
contract SushiRestaurant {
    uint public numSushi = 50;

    function sellSushi(uint n) public {
        for (uint i = 0; i < n; i++) {
            if (numSushi == 0) {
                return;
            }
            numSushi -= 1;
        }
    }
}
```

## Decremental for-loop
Moreover, there is another way of specifying the for-loop, the is using decremental approach where it allows the loop to iterate from top to bottom. The functions above and below performs exactly the same operation.

```solidity
contract SushiRestaurant {
    uint public numSushi = 50;

    function sellSushi(uint n) public {
        for (uint i = n; i > 0; i--) {
            if (numSushi == 0) {
                return;
            }
            numSushi -= 1;
    }
}
```

## Problem
I hope this familiarised you with the idea for basic for-loop. In the following exercise, you will be the chef of the restaurant and have to make sushi every day before opening the restaurant. The number of sushi you need to make is externally determined and passed to the makeSushi function, therefore, you only need to focus on how to increment the number of sushi when making it. For simplicity of the exercise, you incremental approach.

## Code
{% exercise %}
For-loop

{% initial %}
pragma solidity ^0.4.24;

contract SushiRestaurant {
    // before making any sushi, there are 0 number of sushi
    public uint numSushi = 0;

    // Implement this function
    function makeSushi(uint n) external view returns (uint) {

    }
}

{% solution %}
pragma solidity ^0.4.24;

contract SushiRestaurant {
    public uint numSushi = 0;

    // Implement this function
    function makeSushi(uint n) external view returns (uint) {
        for (uint i = 0; i < n; i++) {
            sushi += 1;
        }
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'SushiRestaurant.sol';

contract TestForLoop {
    SushiRestaurant sushiRestaurant = new SushiRestaurant(__ADDRESS__);

    function testMakeSushi() public {
        uint result = sushiRestaurant.makeSushi(50);
        uint expected = 50;
        Assert.equal(result, expected, "makeSushi() is not implemented correctly");
    }

    event TestEvent(bool indexed result, string message);
}

{% endexercise %}

As mentioned above, for-loop is a fundamental but very important control flow in any programming language. Including the ones I have introduced you, there are many variation of the for-loop. There are tons of references you can look at in order to dive into the world of for-loop!
