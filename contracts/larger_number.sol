pragma solidity ^ 0.4.2;

contract NumberTest{
    int x;
    int y;
    
    function setNums(int inputOne, int inputTwo) public{
        x = inputOne;
        y = inputTwo;
    }

    function getLarger() public constant returns (int){
        return (x >= y) ? x : y;
    }
}