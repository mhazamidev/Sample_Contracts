// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ErC20 {
    constructor() Erc20("MyToken", "MTK") {
        _mint(msg.sender, 10_000 * 10 ** decimals());
    }
}