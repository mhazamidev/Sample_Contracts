// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Receiver {
    string result = "job done!";

    function getResult() external view returns (string memory) {
        return result;
    }

    receive() external payable {}

    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool result, bytes memory result_data) = address(this).staticcall(
            data
        );
        require(result, "call failed");
        return result_data;
    }
}

/*

The staticcall is a "source" version of "call"
    it allows a contract call another contract(or itself) without modifying the state.
    staticcall can not send value and is just to call without any change on state.

One of main reason to use staticcall is to avoid "reentrancy" vulnerabilities.

staticcall throw exception if the opcodes:
    - tries to deploy a new contract (create and create2)
    - emits logs (LOG0, LOG1, LOG2, LOG3, LOG4)
    - makes state changes (SSTORE)
    - anything that uses call() with a value (sending eth)


 */

contract Sender {
    address immutable receiverAddress;
    event Response(bool status, bytes data);

    constructor(address _receiverAddress) {
        receiverAddress = _receiverAddress;
    }

    //call getRequest()
    function call_getRequest()
        public
        view
        returns (bool success, bytes memory result)
    {
        (success, result) = receiverAddress.staticcall(
            abi.encodeWithSignature("getResult()")
        );
        require(success, "failed to staticcall");
    }

    //call the receive
    function call_receive()
        public
        view
        returns (bool success, bytes memory result)
    {
        (success, result) = receiverAddress.staticcall("");

        require(success, "failed to staticcall");
    }
}
