// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract TestMultiSigWallet {
    event Received(address sender, uint amount);
    uint public i;

    function callMe(uint j) public payable {
        i += j;
        emit Received(msg.sender, msg.value);
    }

    function getData() public pure returns (bytes memory) {
        return abi.encodeWithSignature("callMe(uint256)", 10);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
