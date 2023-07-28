//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract BankSafe {
  mapping(address => uint256) public balances;

  function deposit() public payable {
    balances[msg.sender] += msg.value;}

  function withdraw() public {
    require(balances[msg.sender] != 0);
    bool result = payable(msg.sender).send(balances[msg.sender]);
    balances[msg.sender] = 0; }
    
}