// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TimeLock is Ownable(msg.sender) {
    uint public immutable lockDuration = 1 weeks;

    mapping(address => uint) public balances;
    mapping(address => uint) public lockTimes;

    function deposit() external payable {
        balances[_msgSender()] += msg.value;
        lockTimes[_msgSender()] = block.timestamp + lockDuration;
    }

    function withdraw() public returns (bool) {
        require(balances[_msgSender()] > 0, "insufficient funds");
        require(block.timestamp > lockTimes[_msgSender()], "");
        (bool result, ) = _msgSender().call{value: balances[_msgSender()]}("");
        if (result) {
            balances[_msgSender()] = 0;
            return true;
        }
        return false;
    }

    function increaseLockTime(
        address _account,
        uint _seconds
    ) public onlyOwner {
        lockTimes[_account] += _seconds;
    }

    function dencreaseLockTime(
        address _account,
        uint _seconds
    ) public onlyOwner {
        lockTimes[_account] -= _seconds;
    }
}
