// SPDX-License-Identifier: GPL-3.0

// depositer can choose own time lock limit during deposit fund;
// all depositer have separate time lock limit..

pragma solidity ^0.8.7;

contract TImeLock{

    mapping(address=>uint256) balances;
    mapping(address=>uint256) time;

    function deposit(uint256 _time) public payable{
        time[msg.sender]= block.timestamp+ _time;
        balances[msg.sender]+= msg.value;
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    function withdraw(address payable receiver) public {
        require(msg.sender== receiver, "fund can be withdraw on same address");
        require(block.timestamp>=time[msg.sender], "deadline has not passed");

        receiver.transfer(balances[msg.sender]);
        balances[msg.sender]=0;
    }
}
