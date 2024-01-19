// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

/*
    in some cases, it is important to know who sent a transaction or message to a smart contract.
    For that reason, solidity gives us two functions - msg.sender and tx.origin.


    tx.origin refers to the EOA that created the initial transaction.
    This global value is passed along different calls to other contracts.


    ,sg.sender tells us the last instance from where a function is called.
    This can be an EOA or contract.
    If an EOA sends a transaction to contract Am contract A sees the address of the EOA as msg.sender.
    If contract A sends a message(e. g. call) to contract B, B sees contract A's address when lokking at msg.sender.


    C --------------------------- call() ------------> B ------------ call() -------------> A
    msg.sender = EOA of C                        msg.sender = C                         msg.sender = B
    tx.origin = EOA of C                         tx.origin = EOA of C                   tx.origin = EOA of C


    NOTE : DO NOT user tx.origin for Authotixation!

*/

contract A {
    address public msgSender;
    address public txOrigin;

    function setVariablesC() external returns () {
        msgSender = msg.sender;
        txOrigin = tx.origin;
    }
}

contract B {
    address public msgSender;
    address public txOrigin;

    function setVariablesB(address addressA) external returns (bool status) {
        msgSender = msg.sender;
        txOrigin = tx.origin;

        (status, ) = addressA.call(abi.encodeWithSignature("setVariablesC()"));
    }
}

contract C {
    address public msgSender;
    address public txOrigin;

    function setVariablesA(
        address addressA,
        address addressB
    ) external returns (bool status) {
        msgSender = msg.sender;
        txOrigin = tx.origin;

        (status, ) = addressB.call(
            abi.encodeWithSignature("setVariablesB(address)", addressA)
        );
    }
}
