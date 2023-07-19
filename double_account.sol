pragma solidity ^ 0.5.13;
contract bank_m {
    struct User{
        address account;
        uint balance;
    }
    
    modifier hasAccount {
        require(
            msg.sender == alice.account || msg.sender == bob.account,
            "You do not have a bank account"
        );
        _;
    }

    mapping(address => User) accounts;
    User alice;
    User bob;

    constructor(address Alice, address Bob) public {
        alice.account = Alice;
        alice.balance = 0;
        bob.account = Bob;
        bob.balance = 0;

        accounts[Alice] = alice;
        accounts[Bob] = bob;
    }
    function deposit() public payable hasAccount {
        accounts[msg.sender].balance += msg.value;
    }
    function withdraw(uint amount) public payable hasAccount {
        msg.sender.transfer(msg.value);
        accounts[msg.sender].balance -= amount;
    }
}