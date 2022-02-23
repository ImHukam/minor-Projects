/* 
this contract is live on ethereum ropsten testnet network: https://ropsten.etherscan.io/address/0x16d52172e080e1fa9a12652361289ba91faba3f3#code

smart contract program for lottery application on solidity.

1. manager to select winner,balance check,lottery control.
2. participants: all participants have to send 0.1 ether into contract address, contract will 
select random participants as a winner... and whole amount will be sent to that winner.
3. condition: 
 amount should be equal to 0.1 ether.
 total participants should be greater then or equal to 3.
 only manager have authority to check balance and draw lottery.
 conract should be reset once a round is completed.

*/
 
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

contract Lottery{

    address public manager;
    address payable[] public participants;

    constructor(){
        manager=msg.sender; //deployer addresss to managers
    }

    // for receive eth from participats.
    receive() external payable{
        require(msg.value== 100000000000000000 wei); //0.1 eth
        participants.push(payable(msg.sender));
    }

    // for balance check,only for manager.
    function getBalance() public view returns(uint){
        require(msg.sender== manager);
        return address(this).balance;
    }

    //for random lottery draw.

    function random() public view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    //for select winner.
    function selectWinner() public{
        require(msg.sender == manager,"only manager have right to call this function");
        require(participants.length >= 3, "less then 3 participants");

        uint r= random();
        uint index= r % participants.length;
        address payable winner= participants[index];

        //transfer amount to winner;
        winner.transfer(getBalance());

        //for reset lottery draw.
        participants= new address payable[](0);
    }
}
