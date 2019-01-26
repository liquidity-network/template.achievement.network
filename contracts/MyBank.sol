pragma solidity ^0.4.24;

contract MyBank {
    address public owner = msg.sender; //The person initiating the contract is the default owner
    address public bank = address(this);
    struct Client {
        bool isClient;
        int balance;
    }
    mapping(address => Client) private accounts;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this.");
        _;
    }

    modifier isClient() {
        require(accounts[msg.sender].isClient, "You have no account here.");
        _;
    }

    function getBalance() public view isClient returns (int) {
        return accounts[msg.sender].balance;
    }

    function withdraw(uint128 amount) public isClient {
        require(bank.balance >= amount);
        accounts[msg.sender].balance -= amount;
        msg.sender.transfer(amount);
    }

    function deposit() public payable isClient {
        accounts[msg.sender].balance += int(msg.value);
    }

    function addClient(address client, int balance) public onlyOwner {
        accounts[client] = Client({isClient: true, balance: balance});
    }
}