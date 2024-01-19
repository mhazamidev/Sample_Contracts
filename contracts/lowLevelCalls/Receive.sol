// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Receiver {
    //.send() and .transfer() forwards 2300 gas to the receiver contract.
    //This is only a very small amount that is sufficient to trigger a simple event
    //more fields inside the event need more than forwarded gas (2300 gas)
    //and cause to fail the send and transfer function

    event Received(address, uint);

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}

contract Sender {
    address payable immutable receiverAddress;

    constructor(address payable receiver) {
        receiverAddress = receiver;
    }

    function pay_ViaTransfer() public payable {
        receiverAddress.transfer(msg.value);
    }

    function pay_ViaSend() public payable {
        bool send = receiverAddress.send(msg.value);
        require(send, "send failed");
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