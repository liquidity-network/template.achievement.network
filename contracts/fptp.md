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
they don't want. On the other hand, it's a very simple system to understand and
has proven to be fairly robust in elections around the world.

Let's try implementing our own FPTP system!

## Setting up Structures

Let's think about what we need to represent in our voting system. We will have
the concept of a voter (that's you!) and a candidate (that's who you vote
for!). A candidate has a name and a party that they are representing. A voter
should have the notion of whether they have voted, who they have voted for, and
whether they are eligible to vote in the first place (in real life, this could
be children or those who haven't registered to vote).

{% exercise %}
Write a struct for a `Voter` with `eligibleToVote`, `hasVoted`, and `votedFor` 
fields, and a `Candidate` with `name` and `party` fields.

{% initial %}
pragma solidity ^0.4.24;

contract Election {

  // Fill in the fields for these two structs!
  struct Candidate { /***/ }

  struct Voter { /***/ }

}

{% solution %}
pragma solidity ^0.4.24;

contract Election {

  // You can add even more fields here if you like. We'll use these for now.
  struct Candidate {
    // We use bytes instead of strings because they cost less gas, but a string
    // would also work fine.
    bytes32 name;
    bytes32 party;
  }

  // Did you get the types correct?
  struct Voter {
    bool eligibleToVote;
    bool hasVoted;
    uint8 votedFor;
  }

}

{% validation %}
pragma solidity ^0.4.24;

// Add validation here.

{% endexercise %}

Great! Now we have our notion of voters and candidates. 

## Creating the Variables

Let's keep track of addresses relating to voters, how many voters we have, our
list of candidates, and finally the address of a _regulator_. The regulator is
the address responsible for hosting the election - a bit like the electoral
commission.

```solidity
  // This holds the mapping from addresses to a voter struct, holding details
  // about whether or not the user has voted, and who for.
  mapping(address => Voter) voters;
  // We will keep track of how many people are eligible to vote.
  uint8 numVoters;
  // The regulator is the person responsible for deploying the smart contract
  // and giving people the right to vote.
  address regulator;
  // Our array of candidates.
  Candidate[] candidates;
```

Now imagine you are the regulator of the vote. 

{% exercise %}

Fill in the `Election` constructor method to initialise the regulator as the
`msg.sender`, and the length of the `Candidate` array to be the value of the
parameter passed into the method.

{% hints %}

All arrays have a `length` field which you can access and set.

{% initial %}
pragma solidity ^0.4.24;

contract Election {

  struct Candidate {
    bytes32 name;
    bytes32 party;
  }

  struct Voter {
    bool eligibleToVote;
    bool hasVoted;
    uint8 votedFor;
  }

  mapping(address => Voter) voters;
  uint8 numVoters;
  address regulator;
  Candidate[] candidates;

  constructor(uint8 _numCandidates) public {
    // Write your code in here.
  }

}

{% solution %}
pragma solidity ^0.4.24;

contract Election {

  struct Candidate {
    bytes32 name;
    bytes32 party;
  }

  struct Voter {
    bool eligibleToVote;
    bool hasVoted;
    uint8 votedFor;
  }

  mapping(address => Voter) voters;
  uint8 numVoters;
  address regulator;
  Candidate[] candidates;

  constructor(uint8 _numCandidates) public {
    // The regulator is the mediator of the vote, and the person/organisation 
    // that initiated the contract.
    regulator = msg.sender;
    // If you think the regulator should be able to vote, you can include this:
    // voters[regulator].eligibleToVote = true;
    // Set the length of the candidates array to how many candidates we have.
    candidates.length = _numCandidates;
  }

}

{% validation %}

// Add validation here.

{% endexercise %}

## Implementing Some Functionality!

Great! You're really getting the hang of this. Now let's move on to the meat of
the contract -- the methods!

You have previously seen _modifiers_. For this exercise, we'll create two. One,
`isRegulator` to check if the message sender is the regulator, and
`hasNotVoted` to check if an address has voted or not.

Then, we'll need to create three methods:

* `setEligibleToVote(addr voter)`: When a new `Voter` struct is created, the
  default value for the `eligibleToVote` function is `false`. This method
  should allow the regulator to give a voter the power to vote, as long as they
  haven't already voted.
* `vote(uint8 _votedFor)`: Given an index into the `candidates` array, this
  method should place the vote for that candidate on behalf of the user that
  called the method. Make sure that the user hasn't already voted!
* `getWinner()`: This method should return the index of the winning
  `candidate`. You can do this by iterating over the voters and tallying up the
  votes for each candidate.

Think you got it? Try out the exercise! There are some hints below if you get
stuck.

{% exercise %}

Implement the two modifiers and the `setEligibleToVote(addr voter)`, 
`vote(uint8 _votedFor)`, and `getWinner()` methods as described.

{% hints %}

* Don't forget to use the modifiers where appropriate.

{% initial %}
pragma solidity ^0.4.24;

contract Election {

  struct Candidate {
    bytes32 name;
    bytes32 party;
  }

  struct Voter {
    bool eligibleToVote;
    bool hasVoted;
    uint8 votedFor;
  }

  mapping(address => Voter) voters;
  uint8 numVoters;
  address regulator;
  Candidate[] candidates;
  
  constructor(uint8 _numCandidates) public {
    regulator = msg.sender;
    candidates.length = _numCandidates;
  }

  modifier isRegulator(address addr) {
    // Write your code here.
  }

  modifier hasNotVoted(address addr) {
    // Write your code here.
  }

  // Allow the voter to vote in the election
  function setEligibleToVote(address voter) public {
    // Write your code here.
  }

  function vote(uint8 _votedFor) public {
    // Write your code here.
  }

  function getWinner() public view returns (uint8 _winner) {
    // Write your code here.
  }

}

{% solution %}
pragma solidity ^0.4.24;

contract Election {

  struct Candidate {
    bytes32 name;
    bytes32 party;
  }

  struct Voter {
    bool eligibleToVote;
    bool hasVoted;
    uint8 votedFor;
  }

  mapping(address => Voter) voters;
  uint8 numVoters;
  address regulator;
  Candidate[] candidates;
  
  constructor(uint8 _numCandidates) public {
    regulator = msg.sender;
    candidates.length = _numCandidates;
  }

  modifier isRegulator(address addr) {
    // Simply check that the address provided matches that of the regulator.
    require(addr == regulator);
    _;
  }

  modifier hasNotVoted(address addr) {
    // Just check inside the voter's struct whether their hasVoted field is
    // set or not.
    require(!voters[addr].hasVoted);
    _;
  }

  // Allow the voter to vote in the election
  // Don't forget to include both modifiers!
  function setEligibleToVote(address voter) public isRegulator(msg.sender) 
      hasNotVoted(voter) {
    // Set the address as eligible to vote, and increase the number of voters
    // by one so we can keep track.
    voters[voter].eligibleToVote = true;
    numVoters++;
  }
  
  // Again, don't forget to make sure the user hasn't already voted!
  function vote(uint8 _votedFor) public hasNotVoted(msg.sender) {
    // Make sure that their vote is for a valid candidate...
    require(_votedFor >= 0 && _votedFor < candidates.length);
    // And then update their fields...
    Voter storage voter = voters[msg.sender];
    voter.votedFor = _votedFor;
    voter.hasVoted = true;
  }

  function getWinner() public view returns (uint8 _winner) {
    // Keep track of how many votes each candidate gets
    uint[] memory numVotes;
    // We'll also keep track of what the winning number of votes is so far...
    uint winningVotes = 0;
    for (uint8 i = 0; i < numVoters; i++) {
      // Increment the number of votes for that candidate
      numVotes[voters[i].votedFor]++;
      // And if that beats the current best, update who the winner is and what
      // the winning total is
      if (numVotes[voters[i].votedFor] >= winningVotes) {
        winningVotes = numVotes[voters[i].votedFor];
        _winner = voters[i].votedFor;
      }
    }
  }

}

{% validation %}

{% endexercise %}

## Extensions

You've now created a basic voting system in Solidity, go you! If you want, why
not try extending the functionality of the contract? Here are some ideas for
what you could do:

* Allow users to delegate their vote to another user, just like in real life.
  For this, you might need to change the struct of a voter to account for the
  fact that they might vote more than once.

* Provide a method for finding out how many votes any candidate got, not just
  reporting the winner.

* Provide a method for the regulator to add details for a candidate including
  the name and the party.

> **Food for Thought**: Voting on the blockchain has many advantages, but there
> are disadvantages too. For example, what if you don't want your vote to be
> publicly viewable? Can you think of any more disadvantages of this method?
