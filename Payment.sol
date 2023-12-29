// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Payment {
    constructor() payable {}

    //pay to contract address(doesn't need to implement)
    function payToContract() public payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    modifier checkBalanceOfContract(uint amount) {
        require(address(this).balance >= amount, "Not enough balance");
        _;
    }

    function payTransfer(
        address payable to,
        uint amount
    ) public checkBalanceOfContract(amount) {
        to.transfer(amount);
    }

    function paySend(
        address payable to,
        uint amount
    ) public checkBalanceOfContract(amount) returns (bool) {
        bool result = to.send(amount);

        require(result, "Failure in payment via send");

        return result;
    }

    function payCall(
        address payable to,
        uint amount
    ) public checkBalanceOfContract(amount) returns (bool) {
        (bool result, ) = to.call{value: amount}("");

        require(result, "Failure in payment via send");

        return result;
    }
}
