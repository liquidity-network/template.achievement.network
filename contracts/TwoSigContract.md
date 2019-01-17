# Two-signature contract


## What is a two-signature contract ?

Imagine that you and a business partner are running a successful business together. To simplify money management, the two of you decide to set up a joint wallet where all your benefits go into. However as much as you respect your colleague, you're not sure you can trust him no to run away with the bank. How can you make sure that you're both involved in every operation regarding that account ?

That is where the two-signature contract comes into play. You and your partner would first feed your respective addresses into the contract. Then the contract would require that both of you "sign the contract" - meaning explicitly authorize a payment - before allowing it to proceed.

A two-signature is just a particular case of a [multisignature contract](https://en.bitcoin.it/wiki/Multisignature) which are widely used in Ethereum. As the name suggests, the principle remains the same except that the contract now supports an arbitrary number of participants.

In its most simple form that we're going to implement in this exercise, the contract follows this procedure:

1. It instantiates addresses of the two participants and a pair of flags (to keep track of participants that have given their consent)
2. It actively checks incoming transaction and raises one of the flag if a participant is the author of a received transaction
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


## Checking signatures

Every time the contract receives a transaction, it should check the sender's address contained in `msg.sender`. If that address matches one of the two parties and if that address has not already been registered, we set the register flag to `true` for that address. You should make use of modifiers for these checks.


## Implementing the action

Finally we implement the action to perform when all participants have given their consent. The function `action()` should check if both parties are registered, run the operation then reset the register flags to `false`.

In our case we will sent the contract's balance to one of the participant but in reality this is where payment are sent, usually to a third party.


## Going further

This exercise implements a very basic multisignature contract with only two participants allowed. You can extend this exercise by allowing more participants using an array of addresses for instance.

Another useful application of multisignature contract is *M-of-N transactions* where only M participants need to agree on a operation for it to be run by the contract.

There are a lot of ways to derivate this exercise and many resources on the web on multisignature contracts if you're interested by this subject ([this one](https://medium.com/@ChrisLundkvist/exploring-simpler-ethereum-multisig-contracts-b71020c19037) for instance).
