# Mission Control

We will try to create a simple contract which will be used as a control panel for managing the missions. The owner, who plays a role of admin, will naturally be able to create new missions. Soldier will be able to join the mission if they pay an a fee set for this mission by the admin.

## Initialisation

Recall a structure is a custom type which can hold properties. Let's start with creating new structures for `Mission`. It will include the `location` of the mission, `fee` required to join it and a boolean value `completed` indicated whether the mission has been accomplished. The contract will also have the mapping of the mission IDs and the arrays of soldiers' addresses who joined the mission. These are already initialised for you so you can focus on the implementation of functions.

## Task

{% exercise %}
Your task is to create a few (restricted) functions. The contract needs to give the admin (who is the initial deployer of the contract) the ability to add a new mission. Anyone can join the mission provided they send an amount of wei larger or equal to the fee of the mission. Finally, the admin can mark the mission as completed.

The interesting bit in this example is how to update the mission's property `completed`.
In solidity we can assign a special type when retrieving some variable. Namely, we can define as `memory` or `storage`. When the retrieved variable is assigned to memory type it creates a new copy of data. If any update is done on copied data, it will not reflect in the original copy. Conversely, changing storage location from memory to storage will not create a new copy of data, rather it will create a pointer to storage.

As in examples, assuming we have some mapping of users

```solidity
    User memory user = users[0];
    user.balance = balance;
```

will **copy** the user at index 0 and will update that new user. If we change `memory` to `storage` the variable `user` will be treated as a pointer to original user at the index 0 of the mapping `users`.

Now you can complete a whole MissionControl contract.

{% initial %}
pragma solidity ^0.4.24;

contract MissionControl {
  address public admin = msg.sender;
  
  // Create structure for Mission
  struct Mission {
    string location;
    uint fee;
    bool completed;
  }
  
  // Current missions
  Mission[] missions;
  
  // Mapping of missions IDs to arrays of soldiers' addresses
  mapping(uint => address[]) assignments;
  
  // Check if the sender is an admin
  modifier adminCheck() {

  }
  
  // Check if the mission exists
  modifier missionCheck(uint id) {

  }
  
  // Check if the sent value is higher than the set fee
  modifier feeCheck(uint id) {

  }
  
  // Add a new mission - restricted only for admin
  function addMission(string location, uint fee) public /* insert */ {

  }
  
  // Join the mission provided it exists and the paid value is sufficient
  function joinMission(uint id) public /* insert */ {

  }
  
  // Mark the mission as completed - restricted only for admin
  function completeMission(uint id) public adminCheck {
      Mission /* insert */ mission = missions[id];
      mission.completed = true;
  }
}

{% solution %}

pragma solidity ^0.4.24;

contract MissionControl {
  address public admin = msg.sender;
  
  // Create structure for Mission
  struct Mission {
    string location;
    uint fee;
    bool completed;
  }
  
  // Current missions
  Mission[] missions;
  
  // Mapping of missions IDs to arrays of soldiers' addresses
  mapping(uint => address[]) assignments;
  
  // Check if the sender is an admin
  modifier adminCheck() {
    require(msg.sender == admin);
    _;
  }
  
  // Check if the mission exists
  modifier missionCheck(uint id) {
    require(id < missions.length);
    _;
  }
  
  // Check if the sent value is higher than the set fee
  modifier feeCheck(uint id) {
    require(msg.value >= missions[id].fee);
    _;
  }
  
  // Add a new mission - restricted only for admin
  function addMission(string location, uint fee) public adminCheck {
      missions.push(Mission({location: location, fee: fee, completed: false}));
  }
  
  // Join the mission provided it exists and the paid value is sufficient
  function joinMission(uint id) public missionCheck(id) feeCheck(id) {
    assignments[id].push(msg.sender);
  }
  
  // Mark the mission as completed - restricted only for admin
  function completeMission(uint id) public adminCheck {
      Mission storage mission = missions[id];
      mission.completed = true;
  }
}

{% validation %}

{% endexercise %}

  
  > **Hint**: Remember about `_;` in a modifier
  
  > **Hint**: Recall a function `push()` to add a new element to an array
  
  > **Hint**: When updating the mission's property do we want to create a copy of that mission or find out the reference to it?
  
 
