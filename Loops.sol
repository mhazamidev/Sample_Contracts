// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Loops {
    uint8[] ary = [1, 2, 3, 4, 5];

    function doSumWithFor() public view returns (uint8) {
        uint8 sum = 0;
        for (uint8 i = 0; i < ary.length; i++) {
            sum += ary[i];
        }

        return sum;
    }

    function doSumWithWhile() public view returns (uint8) {
        uint8 sum = 0;
        uint i = 0;

        while (i < ary.length) {
            sum += ary[i];
            // break;
            // continue;
            i++;
        }

        return sum;
    }
}
