# Making a Poll!

In the following exercise, you will learn to create a simple poll system.

This system allows an owner to initialize and create a poll; this part is already completed for you.
Polls are made up of an arbitrary number of options, in the form of strings.

Voters can see what the poll options are through the getPollOptions function, and vote for their choice (i.e. the index of the option) using the vote function.
`vote` should register a user's vote; it should correctly update `pollOptionsScores` and `voters`. Note that votes can be changed; if the given index is negative, the user wishes to remove their vote!

Have fun!

{% exercise %}

Implement the `vote` and `getMyVote` functions

{% hints %}

`vote`: What happens when a user votes on a poll which doesn't have options yet? What happens when a user updates their vote? Make sure all the edge cases are covered!

`getMyVote`: What happens when the user has not yet voted or has deleted their vote?

{% initial %}

pragma solidity ^0.4.24;

contract Poll {
    bytes32 name;
    address private owner;

    bytes32[] private pollOptions;
    uint32[] private pollOptionsScores;

    struct Voter {
        address addr;
        uint32 vote;
    }
    
    Voter[] voters;

    constructor (bytes32 _name) public {
        name = _name;
        owner = msg.sender;
    }

    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }

    function createPoll(bytes32[] options) public ownerOnly {
        pollOptions = options;
        pollOptionsScores = new uint32[](pollOptions.length);
    }

    function getPollOptions() external view returns (bytes32[]) {
        return pollOptions;
    }

    function getPollResults() external view returns (uint32[]) {
        return pollOptionsScores;
    }

    function vote(uint32 optionIndex) external {
        // Put your code here!
    }

    function getMyVote() external returns (uint32) {
        // Put your code here!
    }
}

{% solution %}

pragma solidity ^0.4.24;

contract Poll {
    bytes32 name;
    address private owner;

    bytes32[] private pollOptions;
    uint32[] private pollOptionsScores;

    struct Voter {
        address addr;
        uint32 vote;
    }
    
    Voter[] voters;

    constructor (bytes32 _name) public {
        name = _name;
        owner = msg.sender;
    }

    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }

    function createPoll(bytes32[] options) public ownerOnly {
        pollOptions = options;
        pollOptionsScores = new uint32[](pollOptions.length);
    }

    function getPollOptions() external view returns (bytes32[]) {
        return pollOptions;
    }

    function getPollResults() external view returns (uint32[]) {
        return pollOptionsScores;
    }
    
    // We can add this internal helper function to prevent code duplication as it's used twice!
    function getVoterIndex() internal returns (uint32) {
        for (uint32 i = 0; i < voters.length; i = i + 1) {
            // Cycle through existing voters; if any match with the current voter, we return the index of that voter!
            if (voters[i].addr == msg.sender) {
                return i;
            }
        }
        // If the voter isn't there, we return -1.
        return -1;
    }

    function vote(uint32 optionIndex) external {
        // We first need to make sure we aren't voting for an option which doesn't exist!
        require(optionIndex < pollOptions.length);

        // We want to first check if our user has already voted by using our helper function.
        uint32 voterIndex = getVoterIndex();
        
        // For safety, we will take any negative number to mean "remove my vote"
        if (optionIndex <= -1) {
            if (voterIndex != -1) {
                // If we want to delete our vote and the user has voted, we delete their record and
                // their vote from the scores!
                pollOptionsScores[voters[voterIndex].vote] -= 1;
                delete voters[voterIndex];
            }
        } else {
            if (voterIndex == -1) {
                // If we want to add a vote and our voter hasn't yet voted, we add their record
                voters.push(Voter({addr: msg.sender, vote: optionIndex}));
            } else {
                // If we want to add a vote and our voter has already voted, we first need to get rid of 
                // their original vote in the scores; double voting is bad!
                pollOptionsScores[voters[voterIndex].vote] -= 1;
                // We then register their new vote
                voters[voterIndex].vote = optionIndex;
            }
            // We then register the new vote in the list of scores and we're done!
            pollOptionsScores[optionIndex] += 1;
        }
    }

    function getMyVote() external returns (uint32) {
        uint32 voterIndex = getVoterIndex();
        if (voterIndex == -1) {
            // If our voter doesn't exist, we return -1
            return -1;
        } else {
            // If our voter exists, we return their vote!
            return voters[voterIndex];
        }
    }
}

{% validation %}

pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Poll.sol';

contract TestPoll {
    Poll poll = Poll(__ADDRESS__);

    function testVoteBeforeInit() public {
        poll.vote(1);
        Assert.equal(poll.getPollResults().length, 0, "Poll results should be empty");
        Assert.equal(poll.getMyVote(), -1, "My vote should be -1");
    }
    
    function testInit() public {
        bytes32[] options = ['option1', 'option2'];
        poll.createPoll(options);
        
        Assert.equal(poll.getOptions(), options, "Poll did not initialize");
    }
    
    function testResultsWithNoVotes() public {
        Assert.equal(poll.getPollResults(), [0, 0], "Poll results should be [0, 0]");
        Assert.equal(poll.getMyVote(), -1, "My vote should be -1");
    }
    
    function testVote() public {
        poll.vote(1);
        Assert.equal(poll.getPollResults(), [0, 1], "Poll results should be [0, 1]");
        Assert.equal(poll.getMyVote(), 1, "My vote should be 1");

    }
    
    function testReplaceVote() public {
        poll.vote(0);
        Assert.equal(poll.getPollResults(), [1, 0], "Poll votes are wrong");
        Assert.equal(poll.getMyVote(), 0, "My vote is wrong");
    }
    
    function testDeleteVote() public {
        poll.vote(-1);
        Assert.equal(poll.getPollResults(), [0, 0], "Poll results should be [0, 0]");
        Assert.equal(poll.getMyVote(), -1, "My vote should be -1");
    }
    
    event TestEvent(bool indexed result, string message);
}

{% endexercise %}

Congratulations on creating a poll system; now maybe think about how the system could be extended. What about different types of polls, or ones where you can vote for multiple options? What about rewarding users with some currency for voting? The world is your oyster!