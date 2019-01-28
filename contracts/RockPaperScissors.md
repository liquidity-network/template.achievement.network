Complete the rock, paper, scissors game.

{% initial %}
pragma solidity ^0.4.24;

contract RPSGame {
  enum Move { Rock, Paper, Scissors }

  Move private myMove;

  // add constructor here

  // add an isPlayable modifier here to determine whether the game can still be played

  // create a challenge function that allows another player to challenge this contract
  
  // calculates whether move1 wins over move2
  function hasWon(Move move1, Move move2) pure private returns (bool) {
    if (move1 == Move.Rock) {
      return (move2 == Move.Scissors);
    } else if (move1 == Move.Paper) {
      return (move2 == Move.Rock);
    } else {
      return (move2 == Move.Paper);
    }
  }
}

{% solution %}
pragma solidity ^0.4.24;

contract RPSGame {
  enum Move { Rock, Paper, Scissors }

  Move private myMove;
  bool private isPlayed;

  // add constructor here
  constructor (Move move) public {
    myMove = move;
  }

  // add an isPlayable modifier here to determine whether the game can still be played
  modifier isPlayable () {
    require(!isPlayed);
    _;
  }

  // create a challenge function that allows another player to challenge this contract
  function challenge (Move move) public isPlayable returns (bool){
    isPlayed = true;
    return hasWon(move, myMove);
  }
  
  // calculates whether move1 wins over move2
  function hasWon(Move move1, Move move2) pure private returns (bool) {
    if (move1 == Move.Rock) {
      return (move2 == Move.Scissors);
    } else if (move1 == Move.Paper) {
      return (move2 == Move.Rock);
    } else {
      return (move2 == Move.Paper);
    }
  }
}

{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'RPSGame.sol';

contract TestRPSGame {
  enum Move { Rock, Paper, Scissors }

  RPSGame game = new RPSGame(Move.Rock);
  
  function testPlayerWinsChallenge() public {
    bool result = game.challenge(uint8(Move.Paper));
    bool expected = true;
    Assert.equal(result, expected, "Player didn't win the challenge when they should have");
  }

  function testPlayerLosesChallengeOnDraw() public {
    bool result = game.challenge(uint8(Move.Rock));
    bool expected = false;
    Assert.equal(result, expected, "Player didn't lose the challenge when they should have");
  }

  function testPlayerLosesChallenge() public {
    bool result = game.challenge(uint8(Move.Scissors));
    bool expected = false;
    Assert.equal(result, expected, "Player didn't lose the challenge when they should have");
  }

  event TestEvent(bool indexed result, string message);
}

{% endexercise %}

Hint:
- The `isPlayable` modifier could use an `isPlayed` variable, you should also consider when this is set.

## Extension

We have created a simple game, but currently there is no reward for winning. We could extend the example below so that the winner of the game is paid by the loser.