# Two-signature contract


## What is a two-signature contract?

Imagine that you and a business partner are running a successful business together. To simplify money management, the two of you decide to set up a joint wallet where all your benefits go into. However as much as you respect your colleague, you're not sure you can trust him no to run away with the bank. How can you make sure that you're both involved in every operation regarding that account?

That is where the two-signature contract comes into play. You and your partner would first feed your respective addresses into the contract. Then the contract would require that both of you "sign the contract" - meaning explicitly authorize a payment - before allowing it to proceed.

A two-signature is just a particular case of a [multisignature contract](https://en.bitcoin.it/wiki/Multisignature) which are widely used in Ethereum. As the name suggests, the principle remains the same except that the contract now supports an arbitrary number of participants.

In its most simple form that we're going to implement in this exercise, the contract follows this procedure:

1. It instantiates addresses of the two participants and a pair of flags (to keep track of participants that have given their consent)
2. It actively checks incoming messages and raises one of the flag if the author is a participant
3. When the two participants have been registered, a pre-defined action - often a payment to another entity - is executed


## Defining the two parties

First we need to define who the two parties are. Remember that they are uniquely identified by their addresses.

We also want a way to keep track of participants that have registered. For that we'll use a variable mapping the pair of addresses to a boolean, `true` if the contract has received a transaction from one of the address or else `false`.

### Constructor

A good practice is to declare variables at the start of the contract then initializing them in a special function, the *constructor*. The constructor of a contract is executed once at creation. Only one constructor is allowed per contract. Constructors are declared as follow:
```solidity
constructor([arg1, arg2, ...]) public {
    // Initialization of variables etc.
}
```
You should also always make your variables private by default unless they really need to be accessible from outside. In this tutorial, we leave them public for verification purposes.

{% exercise %}
Declare variables and initialize them in the constructor

{% initial %}
pragma solidity ^0.4.24;

contract TwoSig {

    // 'recipent' will receive the payment
    address public recipient;
    // Declare the addresses of two participants 'partyA' and 'partyB'

    // Declare the variable 'registered' which maps an address to a boolean

    constructor(address addrA, address addrB, address addrRecipient) public {
        recipient = addrRecipient;
        // Initialize the addresses of participants

        // Initialize the mapping for participants 'partyA' and 'partyB' to 'false'
    }
}

{% solution %}
pragma solidity ^0.4.24;

contract TwoSig {

    // 'recipent' will receive the payment
    address public recipient;
    // Declare the addresses of the two participants 'partyA' and 'partyB'
    address public partyA;
    address public partyB;
    // Declare the mapping 'registered' which maps an address to a boolean
    mapping(address => bool) public registered;

    constructor(address addrA, address addrB, address addrRecipient) public {
        recipient = addrRecipient;
        // Initialize the addresses of participants
        partyA    = addrA;
        partyB    = addrB;

        // Initialize the mapping for participants 'partyA' and 'partyB'
        registered[partyA] = false;
        registered[partyB] = false;
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'TwoSig.sol';

contract TestTwoSig {
    address private addrA = 0x4A40AEb30e521e00C68939cc903fd79dCbFACD77;
    address private addrB = 0x73B1E6210c336EbADc7a40C5CeCa0d70839b1107;
    address private addrC = 0x1a796C0429B1DB68E8ED43D45e51991Df51f2433;
    TwoSig testContract = new TwoSig(addrA, addrB, addrC);

    function testPartyA() public {
        address valueA    = testContract.partyA();
        address expectedA = addrA;
        Assert.equal(valueA, expectedA, "partyA is not properly initialized");
    }

    function testPartyB() public {
        address valueB    = testContract.partyB();
        address expectedB = addrB;
        Assert.equal(valueB, expectedB, "partyB is not properly initialized");
    }

    event TestEvent(bool indexed result, string message);
}


{% endexercise %}


## Checking signatures

Every time the contract receives a transaction, it should check the sender's address contained in `msg.sender`. If that address matches one of the two parties and if that address has not already register, we set the register flag to `true` for that address. We're going to make use of modifiers for these checks.

{% exercise %}
Implement the two modifiers and write public function `register()`

{% initial %}
pragma solidity ^0.4.24;

contract TwoSig {

    address public recipient;
    address public partyA;
    address public partyB;
    mapping(address => bool) public registered;

    constructor(address addrA, address addrB, address addrRecipient) public {
        recipient = addrRecipient;
        partyA    = addrA;
        partyB    = addrB;

        registered[partyA] = false;
        registered[partyB] = false;
    }

    modifier isParticipant() {
        // This modifier checks if a message is from one of the two participants
    }

    modifier isNotRegistered() {
        // This modifier checks if a participant has already registered
    }

    // Use the two modifiers above to create public function 'register'
    // This function registers a participant by setting the mapping to 'true'
}

{% solution %}
pragma solidity ^0.4.24;

contract TwoSig {

    address public recipient;
    address public partyA;
    address public partyB;
    mapping(address => bool) public registered;

    constructor(address addrA, address addrB, address addrRecipient) public {
        recipient = addrRecipient;
        partyA    = addrA;
        partyB    = addrB;

        registered[partyA] = false;
        registered[partyB] = false;
    }

    modifier isParticipant() {
        // This modifier checks if a message is from one of the two participants
        require (msg.sender == partyA || msg.sender == partyB);
        _;
    }

    modifier isNotRegistered() {
        // This modifier checks if a participant has already registered
        require (!registered[msg.sender]);
        _;
    }

    // Use the two modifiers above to create public function 'register'
    // This function registers a participant by updating the mapping
    function register() public isParticipant() isNotRegistered() {
        registered[msg.sender] = true;
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'TwoSig.sol';


{% endexercise %}

> **HINTS**
> * The logic operator **OR** is `||` in Solidity. It might be useful to implement `isParticipant()`
> * To get the address of a sender, use `msg.sender`
> * The signature of `register()` is ``function register() public isParticipant() isNotRegistered();`


## Implementing the action

Finally we implement the action to perform when all participants have given their consent. The function `action()` should check if both parties have registered, run the operation then reset the register flags to `false`.

In our case we will sent the contract's balance to one of the participant but in reality this is where payment are sent, usually to a third party.

{% exercise %}
Implement the modifier and write public function `action()`.

{% initial %}
pragma solidity ^0.4.24;

contract TwoSig {

    address public recipient;
    address public partyA;
    address public partyB;
    mapping(address => bool) public registered;

    constructor(address addrA, address addrB, address addrRecipient) public {
        recipient = addrRecipient;
        partyA    = addrA;
        partyB    = addrB;

        registered[partyA] = false;
        registered[partyB] = false;
    }

    modifier isParticipant() {
        require (msg.sender == partyA || msg.sender == partyB);
        _;
    }

    modifier isNotRegistered() {
        require (!registered[msg.sender]);
        _;
    }

    function register() public isParticipant() isNotRegistered() {
        registered[msg.sender] = true;
    }

    modifier allRegistered() {
        // This modifier checks if both participants have registered
    }

    // Use the modifier above to create public function 'action'
    // This function should transfer the contract's balance to 'recipient'
    // Don't forget to reset the mapping afterwards !
}

{% solution %}
pragma solidity ^0.4.24;

contract TwoSig {

    address public recipient;
    address public partyA;
    address public partyB;
    mapping(address => bool) public registered;

    constructor(address addrA, address addrB, address addrRecipient) public {
        recipient = addrRecipient;
        partyA    = addrA;
        partyB    = addrB;

        registered[partyA] = false;
        registered[partyB] = false;
    }

    modifier isParticipant() {
        require (msg.sender == partyA || msg.sender == partyB);
        _;
    }

    modifier isNotRegistered() {
        require (!registered[msg.sender]);
        _;
    }

    function register() public isParticipant() isNotRegistered() {
        registered[msg.sender] = true;
    }

    modifier allRegistered() {
        // This modifier checks if both participants have registered
        require (registered[partyA] && registered[partyB]);
        _;
    }

    // Use the modifier above to create public function 'action'
    // This function should transfer the contract's balance to 'recipient'
    // Don't forget to reset the mapping afterwards!
    function action() public allRegistered() {
        recipient.transfer(address(this).balance);
        registered[partyA] = false;
        registered[partyB] = false;
    }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'TwoSig.sol';


{% endexercise %}

> **HINTS**
> * The logic operator **AND** is `&&` in Solidity. It might be useful to implement `allRegistered()`
> * The signature of `action()` is ``function action() public allRegistered();``
> * To get a contract's balance, use `address(this).balance`
> * To transfer funds, use `<recipient's address>.transer(<amount>)`


## Going further

This exercise implements a very basic multisignature contract with only two participants. You can extend this exercise by allowing more participants, using an array of addresses for instance.

Another useful application of multisignature contract are *M-of-N transactions* where only M out of N participants need to agree on a operation for it to be run by the contract.

There are a lot of ways to derivate this exercise and many resources on the web on multisignature contracts if you're interested by this subject ([this one](https://medium.com/@ChrisLundkvist/exploring-simpler-ethereum-multisig-contracts-b71020c19037) for instance).
