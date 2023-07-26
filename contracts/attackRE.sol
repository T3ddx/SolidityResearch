//SPDX-License-Identifier: MIT
contract AttackRE{
    address bank;

    constructor(address bankRE) {
        bank = bankRE;
    }

    function sendEther() public {
        bank.call{value: 1 ether, gas: 100000}(
          abi.encode()
        );
    }
    
    function attack() public payable{

    }
}
