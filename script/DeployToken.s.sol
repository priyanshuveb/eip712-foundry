// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Token} from "../src/eip2612/Token.sol";

contract DeployToken is Script {
    Token token;

    function run() public returns (address) {
        vm.broadcast();
        token = new Token();

        return address(token);
    }
}
