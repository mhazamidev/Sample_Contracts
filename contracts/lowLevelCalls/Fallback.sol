// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Receiver {
    mapping(address => uint) public payments;

    event Received(string handler, address sender, uint amount);

    function payment() external payable {
        payments[msg.sender] += msg.value;
        emit Received("payment()", msg.sender, msg.value);
    }

    function payAndGetBalance(
        string memory _message
    ) public payable returns (uint) {
        payments[msg.sender] += msg.value;
        emit Received(_message, msg.sender, msg.value);
        return payments[msg.sender];
    }

    //receive function is executed for plain "Ether transfer" that made via .send(), .transfer() and .call() with "empty calldata" (no function is specified => msg.data is empty)

    receive() external payable {
        payments[msg.sender] += msg.value;
        emit Received("receive()", msg.sender, msg.value);
    }

    fallback() external payable {
        payments[msg.sender] += msg.value;
        emit Received("fallback()", msg.sender, msg.value);
    }
}

contract Sender {
    address payable immutable receiverAddress;
    event Response(bool status, bytes data);

    constructor(address payable receiver) {
        receiverAddress = receiver;
    }

    //forward all gas - ajustable
    //returns bool
    // call is the currect recommended method to sening Ether
    function pay_ViaCall() public payable {
        (bool send, bytes memory data) = receiverAddress.call{value: msg.value}(
            ""
        );
        require(send, "call failed");
        emit Response(send, data);
    }

    //to call paymenyّ
    function pay_payment() public payable {
        (bool send, bytes memory data) = receiverAddress.call{value: msg.value}(
            abi.encodeWithSignature("payment()")
        );
        require(send, "call failed");
        emit Response(send, data);
    }

    //to call payAndGetBalance
    function pay_payAndGetBalance() public payable {
        (bool send, bytes memory data) = receiverAddress.call{value: msg.value}(
            abi.encodeWithSignature("payAndGetBalance(string)", "test")
        );
        require(send, "call failed");
        emit Response(send, data);
    }

     //to call fallback
    function call_fallback() public payable {
        //Receiver.fallback() will be executed
        (bool send, bytes memory data) = receiverAddress.call{value: msg.value}(
            abi.encodeWithSignature("nonExistingFunction()")
        );
        require(send, "call failed");
        emit Response(send, data);
    }
}

/*
                    which function is called, fallback() or reveive()


                                    send Ether
                                        |
                                msg.data is empty?
                                        / \
                                       /   \
                                     yes    no
                                     /       \
                        receive() exists?    fallback()
                               /   \
                              /     \  
                            yes      no
                            /          \
                        receive()   fallback()

 */

