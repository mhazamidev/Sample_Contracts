// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./TimeLockWallet.sol";

contract WalletFactory {
    address public owner;
    mapping(address => address[]) wallets;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can wallet");
        _;
    }
    event Created(
        address wallet,
        address creator,
        address forWho,
        uint createAt,
        uint unluckDuraion,
        uint amount
    );

    //Prevents accidnetal sending ether to the factory
    receive() external payable {
        revert();
    }

    function getWallets(address _owner) public view returns (address[] memory) {
        return wallets[_owner];
    }

    function newTimeLockWallet(
        address _owner,
        uint unlockDuration,
        address tokenAddress
    ) public payable onlyOwner returns (address wallet) {
        // Create new wallet
        TimeLockWallet tw = new TimeLockWallet(
            address(this),
            _owner,
            unlockDuration
        );

        wallet = address(tw);
        wallets[owner].push(wallet);

        // send Ether from this transaction to the created wallet
        payable(wallet).transfer(msg.value);

        // send 1000 token from this transaction to the created wallet
        IERC20 token = IERC20(tokenAddress);
        token.transfer(wallet, 1000 * 1e18);

        emit Created(
            wallet,
            msg.sender,
            owner,
            block.timestamp,
            unlockDuration,
            msg.value
        );
    }
}
