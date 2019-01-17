pragma solidity ^0.4.24;

contract TwoSig {

    address private partyA;
    address private partyB;
    address private recipient;
    mapping(address => bool) private registered;

    constructor(address addrA, address addrB, address addrRecipient) public {
        partyA    = addrA;
        partyB    = addrB;
        recipient = addrRecipient;

        registered[partyA] = false;
        registered[partyB] = false;
    }

    modifier isParticipant() {
        require (msg.sender == partyA || msg.sender == partyB);
        _;
    }

    modifier isNotRegistered() {
        require (registered[msg.sender] == false);
        _;
    }

    function register() public isParticipant() isNotRegistered() {
        registered[msg.sender] = true;
    }

    modifier allRegistered() {
        require (registered[partyA] == true && registered[partyB] == true);
        _;
    }

    function action() public allRegistered() {
        recipient.transfer(address(this).balance);
        registered[partyA] = false;
        registered[partyB] = false;
    }
}
