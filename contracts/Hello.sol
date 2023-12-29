// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Hello {
    string private helloStr;
    address public ownerAddress;
    address public contractAddress;

    constructor() {
        helloStr = "Hello world!";
        ownerAddress = msg.sender;
        contractAddress = address(this);
    }

    function setHello(string memory newValue) public {
        helloStr = newValue;
    }

    function getHello() public view returns (string memory) {
        return helloStr;
    }

    function payment() public payable {
        if (msg.value < 1 ether) revert("you need to pay one ETH");
    }

    function getOwnerBalance() public view returns (uint) {
        return ownerAddress.balance / 10 ** 18;
    }

    function getContractBalance() public view returns (uint) {
        return contractAddress.balance / 10 ** 18;
    }

    function destrunctor() public {
        if (msg.sender == ownerAddress) selfdestruct(payable(ownerAddress));
        else revert();

    }
}
