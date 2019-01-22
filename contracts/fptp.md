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

Fill in the `Election` constructor method to initialise the regular as the
`msg.sender`, and the length of the `Candidate` array to be the value of the
parameter passed into the method.

{% initial %}

constructor(uint8 _numCandidates) public {
  // Write your code in here.
}

{% solution %}

constructor(uint8 _numCandidates) public {
  // The regulator is the mediator of the vote, and the person/organisation 
  // that initiated the contract.
  regulator = msg.sender;
  // If you think the regulator should be able to vote, you can include this:
  // voters[regulator].eligibleToVote = true;
  // Set the length of the candidates array to how many candidates we have.
  candidates.length = _numCandidates;
}

{% validation %}

{% endexercise %}

## Just For Fun

{% e.g. add a payable for bribery %} 
