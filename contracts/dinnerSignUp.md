# A  dinner requirements Sign Up

Since you have had some experience working with a few data structures. Lets try and apply your knowledge to a scenario. We are going to create a dietary requirements sign up for a meal. Attendees will be able to submit their requirements through a function named `dietaries` which takes their `name` and`requirements` as strings and stores each persons needs associated with their name.

{% exercise %}
Implement the `dietaries` function. Along with the constructor and some getters for number of attendees and individuals dietary requirements.

{% hints %}
Remember mappings are accessed and modified by using the mapping[key] syntax.
Remember to check if the sign up is full.
{% initial %}
pragma solidity ^0.4.24;

contract DinnerSignUp {
  mapping(String → String) public dietaryReqs;
  uint8 maxNumAttendees = 0;
  uint8 numAttending = 0;

  constructor(uint8 _maxSeats) public {
    // write your code here
  }

  // Write your dietaries function here

  function getNumAttendees() public view returns (uint8) {
    // write your code here
  }

  function getReqsFor() public view returns (string) {
    // write your code here
  }

}


{% solution %}
pragma solidity ^0.4.24;

contract DinnerSignUp {
  mapping(String → String) public dietaryReqs;
  uint8 maxNumAttendees = 0;
  uint8 numAttending = 0;

  constructor(uint8 _maxSeats) public {
    maxNumAttendees = _maxSeats;
  }

  // dietaries function
  function dietaries(string name, string reqs) external {
    require(name != “”);
    require(numAttending < maxNumAttendees);
    mapping[name] = reqs;
    numAttending++;
  }

  function getNumAttendees() public view returns (uint8) {
    return numAttending;
  }

  function getReqsFor(string attendee) public view returns (string) {
    return dietaryReqs[attendee];
  }
}


{% validation %}
pragma solidity ^0.4.24;

import 'Assert.sol';
import 'DinnerSignUp.sol';

contract TestDinnerSignUp {

  DinnerSignUp dinnerSignUpTest = new DinnerSignUp(__ADDRESS__, 10);

  function testOneSignUp () public {
    dinnerSignUpTest.dietaries(“Jon Doe”, “None”);
    uint expecting = 1;
    uint actual = dinnerSignUpTest.getNumAttendees();
    Assert.equal(actual, expected, “Number of attendees is not incremented correctly);
    string expectedReqs = “None”;
    string actualReqs = dinnerSignUpTest.getReqsFor(“Jon Doe”);
    Assert.equal(expectedReqs, actualReqs, “Storage and retrieval of reqs not implemented correctly”);
  }
}


{% endexercise %}
Congratulations!
