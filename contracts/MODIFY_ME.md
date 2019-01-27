{% exercise %}
Now that you have learned more about how to implement a smart contract, let's try to
apply your knowledge to an actual use case and introduce a concept widely used
in the crypto world: Mining Pools. A mining pool is basically a group of miners coming
together to search for rewards. When one of them finds something it shares it fairly with
the rest of the group. You can read more about mining pools here "https://en.wikipedia.org/wiki/Mining_pool".
Now imagine you are the leader of the pool and you have a certain amount of money that
you want to distribute to the workers. You have to distribute the money according
to the amount of work that the workers have contributed.
For simplicity, let's assume each woroker gets an equal share. Also, in a real mining pool
we would check that the worker hasn't registered before.

As you can see, when a worker finds a reward, it calls a function from your API
to send you the reward (foundReward()).

Your job is to implement the givePay() function to pay back the workers.
You should only pay them back if the totalAmount is bigger than minAmount;

Also fill in the blanks appropriately (they're one liners);


{% initial %}
pragma solidity ^0.4.24;

contract Pool {

  struct Worker { 
    address addrWorker;
    uint id;
  }


  string private name;
  address public owner = "Big Lebowski";

  uint private totalAmount = 0;
  uint private minAmount = 0.4 ether;

  Worker[] public workers;
  uint private uniqueIdentifier = 0;

  constructor (string _name) public {
    name = _name;
    owner = msg.sender;
  }

  modifier securityCheck {
    require(msg.sender == owner);
    _;
  }

  function register() public {
    workers.push(new Worker({addrWorker: msg.sender, id: uniqueIdentifier}));
    \\ Make sure uniqueIdentifier is always uniqueIdentifier
  }

  function foundReward() public payable {
    require(msg.value > 0);
    totalAmount += msg.value;
    \\ Try to give out the pay every time you receive a new reward
  }

  \\ Implement the function givePay()

}

{% solution %}
pragma solidity ^0.4.24;

contract Pool {

  struct Worker {
    address addrWorker;
    uint id;
  }


  string private name;
  address public owner = "Big Lebowski";

  uint private totalAmount = 0;
  uint private minAmount = 0.4 ether;

  Worker[] public workers;
  uint private uniqueIdentifier = 0;

  constructor (string _name) public {
    name = _name;
    owner = msg.sender;
  }

  modifier securityCheck {
    require(msg.sender == owner);
    _;
  }

  function register() public {
    workers.push(new Worker({addrWorker: msg.sender, id: uniqueIdentifier}));
    uniqueIdentifier += 1;
  }

  function foundReward() public payable {
    require(msg.value > 0);
    totalAmount += msg.value;
    givePay();
  }

  function givePay() public securityCheck {
    if (totalAmount > minAmount) {
      uint share = totalAmount / noOfWorkers;
      for (uint i = 0; i < workers.length; i++){
         workers[i].addrWorker.transfer(share);
      }

      totalAmount = 0;
    }

  }
}

{% validation %}
// Tests need proper pragma
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'Pool.sol';

contract TestPool {
    Pool pool = new Pool("FairPool");


    function testBelowMin() public {
      uint thisBalance = address(this).balance;
      pool.register(address(this));
      pool.foundReward.value(0.2 ether)();

      Assert.isBelow(address(this).balance, thisBalance, "We should have
      contributed with 0.2 ether and not have received anything back");
    }

    function test1AboveMin() public {
      uint thisBalance = address(this).balance;
      pool.register(address(this));
      pool.foundReward.value(0.4 ether)();

      Assert.equal(address(this).balance, thisBalance, "We should have
      received our 0.4 ether back");
    }

}

{% endexercise %}

{% hints %}

* What happens to 'totalAmount' after you've distributed it to the workers?
* Dont' forget the security!
* How do you transfer money to each worker (there might be many)?
