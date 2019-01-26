# Become the bank

Now that you are becoming more fluent in Solidity, try a fun project!
In this exercise, you will create a replica of a good ol' fashioned bank 🏦

## First things first

Let's start by defining some principles to implement:
* The bank needs to keep track of all its clients and their balances
* Only clients can get their own balance
* Only the bank owner is allowed to add new clients

> **FYI**: Like a real bank, this one can make loans as long as it as enough money. The client's balance will then be negative.

> **Pro tip**: Notice that because a client with a balance of 0 is still a client, we are using a custom `struct` instead of a simple `mapping(address => int)`

{% exercise %}
Complete the functions and modifiers `getBalance`, `addClient`, `onlyOwner` and `isClient`.

{% initial %}
pragma solidity ^0.4.24;

contract MyBank {
    address public owner = msg.sender; //The person initiating the contract is the default owner
    struct Client {
        bool isClient;
        int balance;
    }
    mapping(address => Client) private accounts;

    modifier onlyOwner() {
        // Complete this function
    }

    modifier isClient() {
        // Your code goes here
    }

    function getBalance() /* are you thinking what I'm thinking? */ {
      // What should I do?
    }

    function addClient(address client) /* hmmmm */ {
        // Here you should create a client and add it to the accounts
    }
}

{% solution %}
pragma solidity ^0.4.24;

contract MyBank {
    address public owner = msg.sender; //The person initiating the contract is the default owner
    struct Client {
        bool isClient;
        int balance;
    }
    mapping(address => Client) private accounts;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this.");
        _;
    }

    modifier isClient() {
        require(accounts[msg.sender].isClient, "You have no account here.");
        _;
    }

    function getBalance() public view isClient returns (int) {
        return accounts[msg.sender].balance;
    }

    function addClient(address client) public onlyOwner {
        accounts[client] = Client({isClient: true, balance: 0});
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'MyBank.sol';

contract TestMyBank {
  MyBank mybank = MyBank(__ADDRESS__);
  
  function testAddClientAndGetBalance() public {
    int expected = 0;
    mybank.addClient(msg.sender);
    int result = mybank.getBalance();
    Assert.equal(result, expected, "Something is wrong here.");
  }

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

> **HINTS**
> * Be careful with the visibility, mutability and modifiers of those functions!

## Last but not least

Now, for this bank to really be useful, clients need to be able to:
* Make deposits
* Withdraw money

Trust yourself with this!

{% exercise %}
Complete the functions `withdraw` and `deposit`.

{% initial %}
pragma solidity ^0.4.24;

contract MyBank {
    address public owner = msg.sender; //The person initiating the contract is the default owner
    address public bank = address(this);
    struct Client {
        bool isClient;
        int256 balance;
    }
    mapping(address => Client) private accounts;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this.");
        _;
    }

    modifier isClient() {
        require(accounts[msg.sender].isClient, "You have no account here.");
        _;
    }

    function getBalance() public view isClient returns (int) {
        return accounts[msg.sender].balance;
    }

    function withdraw(uint128 amount) public isClient {
        // Your code goes here
    }

    function deposit() public payable isClient {
        // Your code goes here
    }

    function addClient(address client) public onlyOwner {
        accounts[client] = Client({isClient: true, balance: 0});
    }
}

{% solution %}
pragma solidity ^0.4.24;

contract MyBank {
    address public owner = msg.sender; //The person initiating the contract is the default owner
    address public bank = address(this);
    struct Client {
        bool isClient;
        int256 balance;
    }
    mapping(address => Client) private accounts;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this.");
        _;
    }

    modifier isClient() {
        require(accounts[msg.sender].isClient, "You have no account here.");
        _;
    }

    function getBalance() public view isClient returns (int) {
        return accounts[msg.sender].balance;
    }

    function withdraw(uint128 amount) public isClient {
        require(bank.balance >= amount, "The bank cannot make that loan.");
        accounts[msg.sender].balance -= amount;
        msg.sender.transfer(amount);
    }

    function deposit() public payable isClient {
        accounts[msg.sender].balance += int256(msg.value);
    }

    function addClient(address client) public onlyOwner {
        accounts[client] = Client({isClient: true, balance: 0});
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'MyBank.sol';

contract TestMyBank {
  MyBank mybank = MyBank(__ADDRESS__);
  
  function testAddClientAndGetBalance() public {
    int expected = 0;
    mybank.addClient(msg.sender, expected);
    int result = mybank.getBalance();
    Assert.equal(result, expected, "Something went wrong while adding a client and getting his balance.");
  }

  function testDeposit() public {
    int expected = mybank.getBalance() + msg.value;
    mybank.deposit.value(msg.value)();
    int result = mybank.getBalance();
    Assert.equal(result, expected, "The balance after a deposit is wrong.");
  }

  function testWithdraw() public {
    int expected = mybank.getBalance() - msg.value;
    mybank.withdraw(msg.value)();
    int result = mybank.getBalance();
    Assert.equal(result, expected, "The balance after a withdrawal is wrong.");
  }

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

> **HINTS**
> * `msg.value` will let you access the value sent to the contract.
> * Remember that the bank can let clients take money (make loans) as long as it has enough money.