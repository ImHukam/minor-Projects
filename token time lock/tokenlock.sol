// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

import "./token.sol";

contract TokenTimelock{
    Token public token;
    address payable public beneficiary;
    uint256 public releasetime;

    constructor(Token _token, address payable _beneficiary, uint256 _releasetime){
        token= _token;
        beneficiary = _beneficiary;
        releasetime= _releasetime;
        releasetime= block.timestamp+ _releasetime;
    }

    function release() public payable{
        require(releasetime > block.timestamp);
        uint256 amount= token.balanceOf(address(this));
        require(amount>0);
        token.transfer(beneficiary,amount);
    }
}
