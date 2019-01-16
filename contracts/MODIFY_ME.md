# Random Behaviour in Smart Contracts

As smart contracts are run on many nodes across the Ethereum network, their behaviour must be deterministic (or else two nodes could run the contract and get different results, like paying two different addresses).

This doesn't mean that random behaviour isn't possible in smart contracts! This exercise will show you how to hold a lottery between multiple addresses, and choose one as the winner.

## Obtaining Random Values

Since we can't generate a random value inside our smart contract, instead we'll get the users to provide the random values. To do this without any cheating, we can use the following set of steps:
- Each user submits a hash of a random number
- A user starts the lottery - the contract will no longer accept random hashes
- Each user submits their random number
  - The smart contract verifies that each number hashes to the hash that was provided previously
- Once all numbers have been obtained, the smart contract combines them to obtain a random number
- The random number is used to select the winner from the list of entrants

This prevents users from seeing what numbers other users have provided by requiring hashes to be submitted first, thus avoiding users from gaming the system. It also does not require the smart contract to generate any random numbers, and behaviour is fully deterministic.

{% exercise %}
The contract defined below will carry out the lottery procedure. Fill in the blanks in the code to implement the functionality of the lottery system.

{% hints %}
- The XOR operator can be used to find the value of exclusive-or between two numbers with `^`, e.g. `uint x = a ^ b`.
- The list of entrants is required to determine when the winner of the lottery can be decided.
- Use the `getHash` function defined in the contract for all your hashing needs.

{% initial %}
pragma solidity ^0.4.24;
contract Lottery {
    // The hashes each entract has provided.
    mapping(address => bytes32) private randomHashes;
    
    // The list of entrants.
    address[] private entrants;
    
    // The list of random numbers.
    uint[] private numbers;
    
    // Whether or not the lottery has begun.
    bool private lotteryStarted;
    
    // The winner of the lottery.
    address private winner;
    
    // Gets the hash of a bytes object.
    function getHash(uint n) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(bytes32(n)));
    }
    
    // Allows a user to provide the hash of their random number.
    function provideRandomHash(bytes32 h) external {
        require(!lotteryStarted && randomHashes[msg.sender] == "");
        
        // Add code to add the hashes to the mapping here, and update the list of entrants.

    }
    
    // Allows a user to move the contract to the winner selection step.
    function startLottery() external {
        require(entrants.length > 0);
        lotteryStarted = true;
    }
    
    // Allows a user to provide the random number corresponding with their provided hash.
    function provideRandomNumber(uint n) external {
        // Add code to ensure that the lottery has started, and that the address calling this function provided a hash previously.
        

        // Add code here to check that the given number matches the sender's hash provided earlier.
        

        numbers.push(n);
        
        // Add code here to call getWinner() when we have all the numbers we need.

    }
    
    // Allows a user to check if they have won.
    function hasWon() external view returns (bool) {
        require(winner != 0x0);
        
        return winner == msg.sender;
    }
    
    // Allows a user to reset the contract, so another lottery can be held.
    function reset() external {
        for (uint i = 0; i < entrants.length; i = i + 1) {
            address a = entrants[i];
            delete randomHashes[a];
        }
        delete winner;
        
        numbers.length = 0;
        entrants.length = 0;
        lotteryStarted = false;
    }
    
    // Calculates the winner of the lottery.
    function getWinner() private {
        // Add code here to combine the numbers provided by the entrants into an index, and set winner to the chosen entrant.
        
    }
}

{% solution %}
pragma solidity ^0.4.24;
contract Lottery {
    // The hashes each entract has provided.
    mapping(address => bytes32) private randomHashes;
    
    // The list of entrants.
    address[] private entrants;
    
    // The list of random numbers.
    uint[] private numbers;
    
    // Whether or not the lottery has begun.
    bool private lotteryStarted;
    
    // The winner of the lottery.
    address private winner;
    
    // Gets the hash of a bytes object.
    function getHash(uint n) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(bytes32(n)));
    }
    
    // Allows a user to provide the hash of their random number.
    function provideRandomHash(bytes32 h) external {
        require(!lotteryStarted && randomHashes[msg.sender] == "");
        
        randomHashes[msg.sender] = h;
        entrants.push(msg.sender);
    }
    
    // Allows a user to move the contract to the winner selection step.
    function startLottery() external {
        require(entrants.length > 0);
        lotteryStarted = true;
    }
    
    // Allows a user to provide the random number corresponding with their provided hash.
    function provideRandomNumber(uint n) external {
        require(lotteryStarted && randomHashes[msg.sender] != "");
        
        bytes32 h = randomHashes[msg.sender];
        if (getHash(n) != h) {
            return;
        }
        
        numbers.push(n);
        
        if (numbers.length == entrants.length) {
            getWinner();
        }
    }
    
    // Allows a user to check if they have won.
    function hasWon() external view returns (bool) {
        require(winner != 0x0);
        
        return winner == msg.sender;
    }
    
    // Allows a user to reset the contract, so another lottery can be held.
    function reset() external {
        for (uint i = 0; i < entrants.length; i = i + 1) {
            address a = entrants[i];
            delete randomHashes[a];
        }
        delete winner;
        
        numbers.length = 0;
        entrants.length = 0;
        lotteryStarted = false;
    }
    
    // Calculates the winner of the lottery.
    function getWinner() private {
        uint acc = 0;
        
        for (uint i = 0; i < entrants.length; i = i + 1) {
            acc = acc ^ numbers[i];
        }
        
        winner = entrants[acc % entrants.length];
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Lottery.sol';

contract TestLottery {
  Lottery lottery = Lottery(__ADDRESS__);
  bytes32 hash;

  function testLotteryProvideHash() public {
    lottery.reset();

    uint number = 1;

    bytes32 b = lottery.getHash(number);
    
    lottery.provideRandomHash(b);

    lottery.startLottery();

    lottery.provideRandomNumber(number);

    Assert.equal(lottery.hasWon(), true, "Lottery not implemented correctly. Single entrant does not win.");
  }

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

Now you can handle random operations in Solidity! While the lottery procedure can't be directly applied to every problem involving random values, the principles behind it are often applicable.
