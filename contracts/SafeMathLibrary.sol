// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

library SafeMathLibrary {
    function add(uint x, uint y) internal pure returns (uint) {
        uint z = x + y;
        require(z >= x, "overflow");
        return z;
    }
}


contract SafeMathTest{
    using SafeMathLibrary for uint;

    function testAdd(uint a,uint b)public pure returns(uint){
        a.add(b);
    }
}