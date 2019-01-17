pragma solidity ^0.4.24;

contract TwoSig {

    // 'recipent' will receive the payment
    address private recipient;
    // Declare the addresses of the two participants 'partyA' and 'partyB'
    address private partyA;
    address private partyB;
    // Declare the mapping 'registered'
    mapping(address => bool) private registered;

    constructor(address addrA, address addrB, address addrRecipient) public {
        recipient = addrRecipient;
        // Initialize the addresses of participants
        partyA    = addrA;
        partyB    = addrB;

        // Initialize the mapping for participants 'partyA' and 'partyB'
        registered[partyA] = false;
        registered[partyB] = false;
    }

    modifier isParticipant() {
        // This modifier tests if a message is from one of the two participants
        require (msg.sender == partyA || msg.sender == partyB);
        _;
    }

    modifier isNotRegistered() {
        // This modifier tests if the participant has already registered
        require (registered[msg.sender] == false);
        _;
    }

    // Use the two modifiers above to create public function 'register'
    function register() public isParticipant() isNotRegistered() {
        registered[msg.sender] = true;
    }

    modifier allRegistered() {
        // This modifier tests if both participants have registered
        require (registered[partyA] == true && registered[partyB] == true);
        _;
    }

    // Use the modifier above to create public function 'action'
    // This function should transfer the contract's balance to 'recipeint'
    // Don't forget to reset the mapping !
    function action() public allRegistered() {
        recipient.transfer(address(this).balance);
        registered[partyA] = false;
        registered[partyB] = false;
    }
}
