// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Counter {
    uint public count;

    function increament() public {
        count++;
    }
}

interface ICounter {
    function count() external view returns (uint);

    function increament() external;
}

contract MyContract {
    function increamentCounter(address _counter) public {
        ICounter(_counter).increament();
    }

    function getCount(address _counter) public view returns (uint) {
        return ICounter(_counter).count();
    }
}
