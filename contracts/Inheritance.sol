// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Parent {
    function sum(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    function dif(uint a, uint b) public pure virtual returns (uint) {
        return a - b;
    }
}

contract Child is Parent {
    function Add(uint x, uint y) public pure returns (uint) {
        return sum(x, y);
    }

    function dif(uint x, uint y) public pure override returns (uint) {
        uint z = x - y;
        return z;
    }

    function dif2(uint x, uint y) public pure returns (uint) {
        uint z = dif(x, y);
        uint w = super.dif(x, y);
        return z;
    }
}
