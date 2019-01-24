# Exercise
This exercise consists of two programs. These will help you have more practice with the Solidity syntax and the language itself.

### Part 1
The first part of the exercise consists of a program that involves 4 different animals: a wolf, a goat, a bear and a farmer (the human). Each animal can do different things, including attacking, feeding or eating another animal.

{% exercise %}
Change the Farmer's name to Noah. Additionally, Noah is 22 years old and studies Computer Science.

{% initial %}
pragma solidity >=0.4.22 <0.6.0;

contract Farmer {

    bytes32 public name;
    uint public age;
    bytes32 public degree;
    uint public health = 5;

    function eat() public {
        health = health + 1;
    }
}

{% solution %}
pragma solidity >=0.4.22 <0.6.0;

contract Farmer {

    bytes32 public name = "Noah";
    uint public age = 22;
    bytes32 public degree = "Computer Science";
    uint public health = 5;

    function eat() public {
        health = health + 1;
    }
}

{% validation %}
// Tests need proper pragma
pragma solidity >=0.4.22 <0.6.0;
import 'Assert.sol';
// Import contracts, filenames should match contract names given in the solution
import 'Farmer.sol';

contract TestFarmer {
    // Declare variable associated to the contract you want to test
    // __ADDRESS__ specifies the contract is the one provided at runtime by the user
    Farmer f = Farmer(__ADDRESS__);

    // test function
    // IMPORTANT: only one assertion per function
    function testEat() public {
        f.eat();
        uint result = f.health;
        uint expected = 6;
        Assert.equal(result, expected, "Eat is not properly implemented");
    }
}

{% endexercise %}

{% exercise %}
1) Give the Wolf a health level of 10
2) Write a function called `attackFarmer` which is `public` and decrements the wolfs's health
3) Write a function called `eatGoat` which is `public`, increments the wolf's health and returns its current health
4) Write a function called `die` which is `public` and sets the wolf's health to 0
> **HINT**: The mutability of function 3) should be restricted to `view`


{% initial %}
pragma solidity >=0.4.22 <0.6.0;

contract Wolf {

    uint public health;

    // Implement your function for 2) here

    // Implement your function for 3) here

    // Implement your function for 4) here

}

{% solution %}
pragma solidity >=0.4.22 <0.6.0;

contract Wolf {

    uint public health = 10;

    // Implement your function for 2) here
    function attackFarmer() public {
        health = health - 1;
    }

    // Implement your function for 3) here
    function eatGoat() public view returns (uint) {
        return health + 1;
    }

    // Implement your function for 4) here
    function die() public {
        health = 0;
    }

}

{% validation %}
// Tests need proper pragma
pragma solidity >=0.4.22 <0.6.0;
import 'Assert.sol';
// Import contracts, filenames should match contract names given in the solution
import 'Wolf.sol';

contract TestWolf {
    // Declare variable associated to the contract you want to test
    // __ADDRESS__ specifies the contract is the one provided at runtime by the user
    Wolf w = Wolf(__ADDRESS__);

    // test function
    // IMPORTANT: only one assertion per function
    function testAttackFarmer() public {
        w.attackFarmer();
        uint result = w.health;
        uint expected = 9;
        Assert.equal(result, expected, "attackFarmer is not properly implemented");
        }

    function testEatGoat() public {
        uint result = w.eatGoat();
        uint expected = 11;
        Assert.equal(result, expected, "eatGoat is not properly implemented");
    }

    function testDie() public {
        w.die();
        result = w.health;
        uint expected = 0;
        Assert.equal(result, expected, "die is not properly implemented");
    }

}

{% endexercise %}

{% exercise %}
The poor goat cannot do anything. It only has health of value 2 :-(. Add this to the contract.

{% initial %}
pragma solidity >=0.4.22 <0.6.0;

contract Goat {

}

{% solution %}
pragma solidity >=0.4.22 <0.6.0;

contract Goat {
    uint public health = 2;
}

{% validation %}
// Tests need proper pragma
pragma solidity >=0.4.22 <0.6.0;
import 'Assert.sol';
// Import contracts, filenames should match contract names given in the solution
import 'Goat.sol';

contract TestWolf {
    // Declare variable associated to the contract you want to test
    // __ADDRESS__ specifies the contract is the one provided at runtime by the user
    Goat g = Goat(__ADDRESS__);

    // test function
    // IMPORTANT: only one assertion per function
    function testHealth() public {
        uint result = g.health;
        uint expected = 2;
        Assert.equal(result, expected, "The variable is not properly initialised");
    }

}

{% endexercise %}

{% exercise %}
Implement a `public` function called `decrementHealth` that will decrement the Bear's health by one.
Attacking the Wolf, Farmer or Goat should decrement the Bear's health (by calling your decrementHealth() function). Implement a `public` function `getHealth` that will return the Bear's current health and a `public` function `setHealth` that will set the Bear's health to a `uint` value called newHealth passed in as a parameter argument.
> **HINT**: The mutability of the getHealth function should be restricted to `view`


{% initial %}
pragma solidity >=0.4.22 <0.6.0;

contract Bear {

    uint private health = 15;

    // Implement the decrementHealth function here


    // attacking the Wolf, Farmer or Goat should decrement the Bear's health - call decrementHealth()
    /*
    function attackWolf() public {

    }

    function attackFarmer() public {

    }

    function attackGoat() public {

    }
    */

    // Implement the function `getHealth`

    // Implement the function `setHealth`

}

{% solution %}
pragma solidity >=0.4.22 <0.6.0;

contract Bear {

    uint private health = 15;

    // Implement the decrementHealth function here
    function decrementHealth() public {
        health = health - 1;
    }

    // attacking the Wolf, Farmer or Goat should decrement the Bear's health - call decrementHealth()
    function attackWolf() public {
        decrementHealth();
    }

    function attackFarmer() public {
        decrementHealth();
    }

    function attackGoat() public {
        decrementHealth();
    }

    // Implement the function `getHealth`
    function getHealth() view public returns (uint) {
        return health;
    }

    // Implement the function `setHealth`
    function setHealth(uint newHealth) public {
        health = newHealth;
    }

}
{% validation %}
// Tests need proper pragma
pragma solidity >=0.4.22 <0.6.0;
import 'Assert.sol';
// Import contracts, filenames should match contract names given in the solution
import 'Bear.sol';

contract TestBear {
    // Declare variable associated to the contract you want to test
    // __ADDRESS__ specifies the contract is the one provided at runtime by the user
    Bear b = Bear(__ADDRESS__);

    // test function
    // IMPORTANT: only one assertion per function
    function testDecrementHealth() public {
        b.decrementHealth();
        uint result = b.health;
        uint expected = 14;
        Assert.equal(result, expected, "decrementHealth is not properly implemented");
    }

    function testAttackWolf() public {
        b.attackWolf();
        uint result = b.health;
        uint expected = 13;
        Assert.equal(result, expected, "attackWolf is not properly implemented");
    }

    function testAttackFarmer() public {
        b.attackFarmer();
        uint result = b.health;
        uint expected = 12;
        Assert.equal(result, expected, "attackFarmer is not properly implemented");
    }

    function testAttackGoat() public {
        b.attackGoat();
        uint result = b.health;
        uint expected = 12;
        Assert.equal(result, expected, "attackGoat is not properly implemented");
    }

    function testGetHealth() public {
        uint result = b.getHealth();
        uint expected = 12;
        Assert.equal(result, expected, "getHealth is not properly implemented");
    }

    function testSetHealth() public {
        b.setHealth(15);
        uint result = b.health;
        uint expected = 15;
        Assert.equal(result, expected, "setHealth is not properly implemented");
    }
}

{% endexercise %}


### Part 2
This part of the exercise is a little example of a contract that allows Minters to send money to each other and mint coins.

{% exercise %}
A minter has the following variables: minter (the minter's address), key, name and balance. Declare the missing variables in the order specified.
1) Implement a function `sendCoin` that allows a Minter to send a coin to another Minter via a specified `address` called minterAddress. If the balance of the Minter who is sending is greater than 1 then this Minter's balance should be decremented and the receiving Minter's balance should be incremented. Return the sending Minter's new balance. REMEMBER: We do not want the balance to be found out by any other Minter...
2) Implement a function `mint` that will increment the Minter's balance and return the new balance.
> **HINT**: the address is the only thing that is `public` in a blockchain, so keep this in mind when declaring the variables, as well as the functions.

{% initial %}
pragma solidity >=0.4.22 <0.6.0;

contract Minter {

    // This is a mapping from address to uint, which stores each Minter's balance
    mapping (address => uint) private balances;
    // Declare the other variables here

    uint private balance;

    // Implement the sendCoin function here - HINT: use balances[minterAddress] to change the Minter's balance

    // Implement the mint function here

    function incrementBalance() private returns (uint) {
        balance = balance + 1;
        return balance;
    }

    function decrementBalance() private returns (uint) {
        balance = balance - 1;
        return balance;
    }
}

{% solution %}
pragma solidity >=0.4.22 <0.6.0;

contract Minter {

    // This is a mapping from address to uint, which stores each Minter's balance
    mapping (address => uint) private balances;
    // Declare the other variables here
    address public minter;
    uint private key;
    uint private name;
    uint private balance;

    // Implement the sendCoin function here - HINT: use balances[minterAddress] to change the Minter's balance
    function sendCoin(address minterAddress) private returns (uint) {
        if (balance > 1) {
            balances[minterAddress] += 1;
            uint newBalance = decrementBalance();
            balances[minter] = newBalance;
            return newBalance;
        }
    }

    // Implement the mint function here
    function mint() private returns (uint) {
        uint newBalance = incrementBalance();
        balances[minter] = newBalance;
        return newBalance;
    }

    function incrementBalance() private returns (uint) {
        balance = balance + 1;
        return balance;
    }

    function decrementBalance() private returns (uint) {
        balance = balance - 1;
        return balance;
    }
}

{% validation %}
// Tests need proper pragma
pragma solidity ^0.5.2;
import 'Assert.sol';
// Import contracts, filenames should match contract names given in the solution
import 'Minter.sol';

contract TestMinter {
    // Declare variable associated to the contract you want to test
    // __ADDRESS__ specifies the contract is the one provided at runtime by the user
    Minter m = Minter(__ADDRESS__);

    // test function
    // IMPORTANT: only one assertion per function
    function testSendCoin() public {
        uint initialBalance = m.balance;
        m.sendCoin(0xAEfDd387f782Dd6cDdba6Cf2645B8F8aC33F300C);
        uint expectedBalance = initialBalance - 1;
        uint actualBalance = m.balance;
        Assert.equal(actualBalance, expectedBalance, "sendCoin is not properly implemented");
    }

    function testSendCoin2() public {
        m.balance = 0;
        m.sendCoin(0xAEfDd387f782Dd6cDdba6Cf2645B8F8aC33F300C);
        Assert.equal(m.balance, 0, "sendCoin is not properly implemented");
    }

    function testMint() public {
        uint initialBalance = m.balance;
        m.mint();
        uint expectedBalance = initialBalance + 1;
        uint actualBalance = m.balance;
        Assert.equal(actualBalance, expectedBalance, "mint is not properly implemented");
    }

    function testIncrementBalance() public {
        uint initialBalance = m.balance;
        uint expectedBalance = initialBalance + 1;
        uint newBalance = m.incrementBalance();
        Assert.equal(newBalance, expectedBalance, "incrementBalance is not properly implemented");
    }

    function testDecrementBalance() public {
        uint initialBalance = m.balance;
        uint expectedBalance = initialBalance - 1;
        uint newBalance = m.incrementBalance();
        Assert.equal(newBalance, expectedBalance, "decrementBalance is not properly implemented");
    }
}

{% endexercise %}


Now you've mastered functions in Solidity! (Still plently to say, but let see what's after)

