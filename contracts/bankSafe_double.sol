//SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.15;

contract Bank {
    mapping(address => uint256) balance;
    mapping(address => bool) disableWithdraw;
    mapping(address => mapping(address => uint256)) allow;

    modifier withdrawAllowed { // reentrancy locking
    require(disableWithdraw[msg.sender] == false); _; }
    
    //added another modifier to check both disableWithdraw
    //for transferFrom
    //should stop reenterance - works
    modifier withdrawAllowed2(address other){
        require(disableWithdraw[other] == false);
        _;
    }

    function addAllowance(address other, uint256 amnt) public { 
        allow[msg.sender][other] += amnt;
        //updating balances here for msg.sender
        //should stop reenterance - works
        //balance[msg.sender] -= amnt;
    }

    function transferFrom(address from,uint256 amnt) withdrawAllowed public {
        require(balance[from] >= amnt);
        require(allow[from][msg.sender] >= amnt);
        balance[from] -= amnt;
        allow[from][msg.sender] -= amnt;
        balance[msg.sender] += amnt; 
    }

    function withdrawBalance() withdrawAllowed public {
        //sets balance first w/ temp variable
        //uint256 temp = balance[msg.sender];
        //balance[msg.sender] = 0;

        // set lock
        disableWithdraw[msg.sender] = true;
        // reentrant calls possible here
        msg.sender.call{value: balance[msg.sender]/*temp*/}("");
        // release lock
        disableWithdraw[msg.sender] = false;
        balance[msg.sender] = 0; 
    }

    //had to add my own deposit function

    function deposit() public payable{
        balance[msg.sender] += msg.value;
    }
    
    //also added a fallback function
    receive() external payable{
        balance[msg.sender] += msg.value;
    }
}