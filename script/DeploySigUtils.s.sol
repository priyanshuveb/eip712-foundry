// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {SigUtils} from "../src/eip2612/SigUtils.sol";

contract DeploySigUtils is Script {
    SigUtils sigUtils;
    // bytes32 domainSeperator = 0x24e7c66ed39001992c0df02b36350cadfcf3384a55a6aa83a382075e377468b6;

    function run(bytes32 domainSeperator) public returns (address) {
        vm.broadcast();
        sigUtils = new SigUtils(domainSeperator);

        return address(sigUtils);
    }
}
