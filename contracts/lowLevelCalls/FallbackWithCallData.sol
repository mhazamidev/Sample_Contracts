// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Target {
    uint public count;

    function get() external view returns (uint) {
        return count;
    }

    function increament() external returns (uint) {
        return ++count;
    }
}

contract Caller {
    address immutable targerAddress;

    event NewCallRequest(address indexed source, bytes data);

    constructor(address _targetAddress) {
        targerAddress = _targetAddress;
    }

    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool result, bytes memory result_data) = targerAddress.call(data);
        require(result, "call failed");
        emit NewCallRequest(msg.sender, data);
        return result_data;
    }
}

contract Source {
    address immutable callerAddress;
    event Log(bytes newCounterCaller);

    constructor(address _callerAddress) {
        callerAddress = _callerAddress;
    }

    function callFallback(bytes calldata data) external {
        (bool result, bytes memory result_data) = callerAddress.call(data);
        require(result, "call failed");
        emit Log(result_data);
    }

    function getTestData() external pure returns (bytes memory){
        return abi.encodeWithSignature("increament()");
    }
}
