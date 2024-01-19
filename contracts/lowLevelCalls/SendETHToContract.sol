// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Receiver {}

contract Sender {
    function endow() public payable {}

    function transfer(address _receiver) public {
        address payable paybleReceiver = payable(_receiver);

        paybleReceiver.transfer(1 ether);
    }

    function send(address _receiver) public returns (bool) {
        //address(_receiver) won't allow to call '_receiver' directly
        //since '_receiver' has no payble fallback function
        //It has to be converted to the 'address payble' to even allow calling 'send' on it
        address payable paybleReceiver = payable(_receiver);
        //There is no receive function in test contract
        //if someone sends Ether to that contact, the send will fail
        //i.e. this returns false here

        return paybleReceiver.send(1 ether);
    }

    function call(address _receiver) public returns (bool) {
        (bool result, ) = _receiver.call{value: 1 ether}("");
        return result;
    }
}
