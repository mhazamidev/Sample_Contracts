// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract ContractA {
    uint public initialNalance;

    constructor() payable {
        initialNalance = msg.value / 1e18;
    }

    function getBalanceOfA() public view returns (uint) {
        return address(this).balance / 1e18;
    }
}
