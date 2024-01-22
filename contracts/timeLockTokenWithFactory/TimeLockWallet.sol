// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TimeLockWallet {
    address public architect;
    address public owner;
    uint public createAt;
    uint public unlockDate; // 1 week ~ 7*24*60*60

    event Received(address from, uint amount);
    event Withdraw(address to, uint amount);
    event WithdrawToken(address tokenAddress, address to, uint amount);

    constructor(address _architect, address _owner, uint _unlockDate) {
        architect = _architect;
        owner = _owner;
        createAt = block.timestamp;
        unlockDate = createAt + _unlockDate;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can wallet");
        _;
    }

    modifier unlocked() {
        require(block.timestamp >= unlockDate, "Your wallet doesn't unlock");
        _;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    function withdrawEther() external onlyOwner unlocked returns (bool) {
        (bool result, ) = payable(owner).call{value: address(this).balance}("");

        require(result, "Withdraw failed!");

        emit Withdraw(owner, address(this).balance);
        return result;
    }

    function withdrawToken(address _tokenAddress) public onlyOwner unlocked {
        IERC20 token = IERC20(_tokenAddress);
        uint tokenBalance = token.balanceOf(address(this));
        token.transfer(owner, tokenBalance);
        emit WithdrawToken(_tokenAddress, owner, tokenBalance);
    }

    function info() public view returns (address, address, uint, uint, uint) {
        return (architect, owner, createAt, unlockDate, address(this).balance);
    }
}
