// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Target {
    uint public num;
    address public sender;
    uint public value;

    function setVariables(uint _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract Caller {
    uint public num;
    address public sender;
    uint public value;

    address immutable targetAddress;

    constructor(address _targetAddress) {
        targetAddress = _targetAddress;
    }

    receive() external payable {}

    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool result, bytes memory result_data) = targetAddress.delegatecall(data);

        require(result, "call failed");
        return result_data;
    }
}

contract Source {
    uint public num;
    address public sender;
    uint public value;

    address immutable callerAddress;

    constructor(address _callerAddress) {
        callerAddress = _callerAddress;
    }

    function setVariables(uint _num) external payable returns (bytes memory) {
        (bool result, bytes memory result_data) = callerAddress.delegatecall(
            abi.encodeWithSignature("setVariables()", _num)
        );
        require(result, "call failed");
        return result_data;
    }
}
/*
delegatecall is a low level function similar to call.


when contract "A" executes delegatecall to contract "B", A's code is executed with B's context

context : storage, nsg.sender, msg.value


NOTE: - storage layout of B must be same as A
      - The name of the variable doesn't matter, but where it is located in storage.


A ----------- call() --------------> B -------------- call() ------------> C
msg.sender                         msg.sender                            msg.sender
(userA's address)              (ContractA's address)                (ContractB's address)



A ----------- delegatecall() --------------> B -------------- delegatecall() ------------> C
msg.sender                              msg.sender                                      msg.sender
(userA's address)                     (userA's address)                             (userA's address)


A ----------- call() --------------> B -------------- delegatecall() ------------> C
msg.sender                        msg.sender                        <------------- *              
(userA's address)               (userA's address)                              msg.sender
                                                                              (userA's address)
                                                                            
A ----------- delegatecall() --------------> B -------------- call() ------------> C
msg.sender           <---------------------- *                                 msg.sender
(userA's address)                       msg.sender                         (ContractB's address)
                                     (userA's address)                                         

*/
