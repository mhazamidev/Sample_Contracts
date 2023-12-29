// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

import "./ContractA.sol";

contract ContractB {
    uint public InitialBalanceOfA;

    function callBalanceOfA(address addressA) public {
        ContractA a = ContractA(addressA);

        InitialBalanceOfA = a.getBalanceOfA();

        InitialBalanceOfA = a.initialNalance();
    }
}
