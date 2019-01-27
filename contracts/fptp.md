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
the concept of a vote and a candidate (that's who you vote for!). A candidate 
has a name and a party that they are representing. A vote should record which
candidate was voted for and the address of whoever voted so we can find out
who voted for who later.

{% exercise %}
Write a struct for a `Vote` with `voter` and `votedFor` 
fields (which store address and the candidate index), and a `Candidate` with 
`name` and `party` fields.

{% initial %}
pragma solidity ^0.4.24;

contract Election {

  // Fill in the fields for these two structs!
  struct Candidate { /***/ }

  struct Vote { /***/ }

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
  struct Vote {
    address voter;
    uint8 votedFor;
  }

}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Election.sol';

contract TestElection {

  // Nothing to test here. It's just a struct.

}

{% endexercise %}

Did you get it right? Great! Now we have our notion of votes and candidates. 

## Creating the Variables

Let's keep track of the votes we have recorded, the number of votes we have
had, and an array of our candidates.

```solidity
  // This contains all the votes we have recorded and which candidate they were
  // for. We use the uint as an index.
  mapping(uint => Vote) votes;
  // We will keep track of how many votes we have recorded so far.
  uint8 numVotes;
  // Our array of candidates.
  Candidate[] candidates;
```

## Implementing Some Functionality!

You're really getting the hang of this. Now let's move on to the meat of
the contract -- the methods!

Then, we'll need to create three methods:

* `constructor(uint8 _numCandidates)`: When the contract is created, introduce
  a constructor that sets the length of the candidates array to be how many
  candidates we requested as the parameter.
* `vote(uint8 _votedFor)`: Given an index into the `candidates` array, this
  method should place the vote for that candidate on behalf of the user that
  called the method. Essentially, you'll want to add a new Vote into our map
  of votes.
* `getWinner()`: This method should return the index of the winning
  `candidate`. You can do this by iterating over the votes and tallying up the
  votes for each candidate.

Think you got it? Try out the exercise! There are some hints below if you get
stuck.

{% exercise %}

Implement the `constructor(uint8 _numCandidates)`, 
`vote(uint8 _votedFor)`, and `getWinner()` methods as described.

{% hints %}

* Don't forget to validate the input to your vote function to make sure the
  supplied number is a real candidate.
* Think carefully about when numVotes needs to be incremented.
* You could use another array to tally up votes for each candidate in the 
  getWinner() function.

{% initial %}
pragma solidity ^0.4.24;

contract Election {

  struct Candidate {
    bytes32 name;
    bytes32 party;
  }

  struct Vote {
    address voter;
    uint8 votedFor;
  }

  mapping(uint => Vote) votes;
  uint8 numVotes = 0;
  Candidate[] candidates;
  
  constructor(uint8 _numCandidates) public {
    // Write your code here.
  }

  function vote(uint8 _votedFor) public {
    // Write your code here.
  }

  function getWinner() public view returns (uint8) {
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

  struct Vote {
    address voter;
    uint8 votedFor;
  }

  mapping(uint => Vote) votes;
  uint8 numVotes = 0;
  Candidate[] candidates;

  constructor(uint8 _numCandidates) public {
    // Simply set the `length` field of the candidates array.
    candidates.length = _numCandidates;
  }

  function vote(uint8 _votedFor) public {
    // Don't forget to add some validation to check that the vote isn't for a
    // non-existent candidate!
    require(_votedFor >= 0 && _votedFor < candidates.length);
    // You can initialise a struct this way - quite simple!
    // And of course, don't forget to increase the number of votes that you've
    // received. That's what the numVotes++ is doing.
    votes[numVotes++] = Vote(msg.sender, _votedFor);
  }

  function getWinner() public view returns (uint8) {
    // Store how many votes each candidate has received in an array.
    uint[] memory votesPerCandidate =  new uint[](candidates.length);
    // We'll also keep track of what the 'best' number of votes is so far,
    // and who the winning candidate is so far.
    uint winningVotes = 0;
    uint8 winner = 0;
    // Iterate through the votes received, and update the number of winning
    // votes and winner as you go.
    for (uint i = 0; i < numVotes; i++) {
      votesPerCandidate[votes[i].votedFor]++;
      if (votesPerCandidate[votes[i].votedFor] >= winningVotes) {
        winningVotes = votesPerCandidate[votes[i].votedFor];
        winner = votes[i].votedFor;
      }
    }
    // Return it!!
    return winner;
  }
}

{% validation %}

pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Election.sol';

contract TestElection {

  Election election = Election(__ADDRESS__, 3);
  
  function testVoteForOneCandidate() public {
    election.vote(1);

    uint actual = election.winner();
    uint expected = 1;
    Assert.equal(actual, expected, "Vote for candidate 1 did not change winner.");
  }
  
  function testVoteForTwoCandidates() public {
    election.vote(1);
    election.vote(2);
    election.vote(2);
    election.vote(2);

    uint actual = election.winner();
    uint expected = 2;
    Assert.equal(actual, expected, "Votes for candidate 2 did not change winner.");
  }

  function testNumVotesGetsIncremented() public {
    uint8 numVotesThen = numVotes;
    
    election.vote(1);

    uint8 actual = numVotes;
    uint expected = numVotesThen + 1;
    Assert.equal(actual, expected, "numVotes was not incremented correctly.");
  }

  event TestEvent(bool indexed result, string message);

}

{% endexercise %}

## Extensions

There you go! You have now created a very basic voting contract to allow you to
vote out of a selection of choices. Go you! If you want, why
not try extending the functionality of the contract? Here are some ideas for
what you could do:

* Allow users to delegate their vote to another user, just like in real life.

* Provide a method for finding out how many votes any candidate got, not just
  reporting the winner.

* Provide a method to add details for a candidate including
  the name and the party.

* Add functionality so that an address can only vote once. Currently, our
  program can allow an address to place as many votes as they want.

> **Food for Thought**: Voting on the blockchain has many advantages, but there
> are disadvantages too. For example, what if you don't want your vote to be
> publicly viewable? Can you think of any more disadvantages of this method?
