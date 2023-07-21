pragma solidity ^ 0.5.13;
contract bank_m {
    struct User{
        address account;
        uint256 balance;
        bool valid;
    }
    
    modifier hasAccount {
        /*require(
            accounts[msg.sender].valid,
            "You do not have a bank account"
        );
        _;*/
        if(accounts[msg.sender].valid){
            _;
        } else {
            if(msg.value > 0){
                msg.sender.transfer(msg.value/2);
            }
        }
    }

    modifier hasMoney(uint money) {
        require(
            accounts[msg.sender].balance >= money,
            "You do not have enough money"
        );
        _;
    }

    mapping(address => User) accounts;
    User alice;
    User bob;

    constructor(address Alice, address Bob) public {
        alice = User({account : Alice, balance : 0, valid : true});
        bob = User({account : Bob, balance : 0, valid : true});

        accounts[Alice] = alice;
        accounts[Bob] = bob;
    }
    function deposit() public payable hasAccount {
        accounts[msg.sender].balance += msg.value;
    }
    function withdraw(uint amount) public payable hasAccount hasMoney(amount) {
        msg.sender.transfer(amount * 1000000000000000000);
        accounts[msg.sender].balance -= amount;
    }

    function fallback() public payable hasAccount {
        deposit();
    }
}