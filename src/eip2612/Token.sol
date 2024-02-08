// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

// error NotOwner(address user);

contract Token is ERC20Permit {
    address immutable OWNER;

    // modifier onlyOwner() {
    //     if (msg.sender != OWNER) revert NotOwner(msg.sender);
    //     _;
    // }

    constructor() ERC20("GigiToken", "GIGI") ERC20Permit("GigiToken") {
        OWNER = msg.sender;
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
