pragma solidity ^ 0.4.13;
contract bank {
  uint256 EtherBalance_Alice = 0;
  function deposit() public payable {
    EtherBalance_Alice = EtherBalance_Alice + msg.value;
  }
  function withdraw(uint256 ethers) public payable {
    msg.sender.transfer(ethers * 1000000000000000000);
    EtherBalance_Alice = EtherBalance_Alice - ethers;
  }
  function relay(address Bob) public payable {
     Bob.transfer(msg.value);
  }
  function getBalanceCA() public constant returns(uint256){
    return EtherBalance_Alice;
  }
  function getBalanceEOA() public view returns(uint256) {
    return 0x0000000000000000000000000000000000000000.balance;
  }}