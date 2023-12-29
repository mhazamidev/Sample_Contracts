// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract ErrorHandling {
    uint8 num = 100;

    //Overflow Error using if
    function Overflow1(uint8 val) public {
        uint8 oldNum = num;

        num = num + val;

        if (num < oldNum) revert("OverFlow Error");
    }

    //Overflow Error using Assert
    function Overflow2(uint8 val) public {
        uint8 oldNum = num;

        num = num + val;

        assert(num >= oldNum);
    }

    //Overflow Error using require
    function Overflow3(uint8 val) public {
        require(num + val >= num, "OverFlow Error");

        num = num + val;
    }

    //Overflow Error using modifier
    function Overflow4(uint8 val) public checkOverflow(val) {
        require(num + val >= num, "OverFlow Error");

        num = num + val;
    }

    modifier checkOverflow(uint8 val) {
        //before function-body
        require(num + val >= num, "OverFlow Error");
        
        _; //placeholder ~ function-body

        //after function-body
    }
}
