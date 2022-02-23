// SPDX-License-Identifier: GPL-3.0

this contract is live on ethereum ropsten testnet network: https://ropsten.etherscan.io/address/0xa4a857d673d5b19afb7c0f9336782f1af74cb858#code

pragma solidity ^0.8.7;

contract TImeLock{

    uint256 time;
    address payable public receiver;

    constructor(address payable _receiver, uint256 _time){
        receiver=_receiver;
        time= block.timestamp+ _time;
    }

    event ethDeposited(uint256 _value, address _sender);
    event ethWithdrawal(uint256 _value, address _receiver);

    function deposit() public payable{
        require(block.timestamp<time, "deadline passed");
        emit ethDeposited(msg.value,msg.sender);
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    function withdraw() public {
        require(msg.sender== receiver, "only receipient can withdraw fund");
        require(block.timestamp>=time, "deadline has not passed");
        emit ethWithdrawal(address(this).balance, msg.sender);
        receiver.transfer(address(this).balance);
    }
}
