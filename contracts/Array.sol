// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Array {
    uint8[] ary;
    uint8[3] ary2;
    uint8[] ary3;
    uint8[][] ary4;
    uint8[2][3] ary5;




    function getList() public view returns (uint8[] memory) {
        return ary;
    }
}
