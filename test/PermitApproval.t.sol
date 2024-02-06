// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/eip2612/Token.sol";
import {SigUtils} from "../src/eip2612/SigUtils.sol";

contract PermitTokenTest is Test {
    Token internal token;
    SigUtils internal sigUtils;

    address owner;
    address spender;
    uint256 ownerPrivateKey;
    uint256 spenderPrivateKey;

    function setUp() public {
        ownerPrivateKey = 0xA11CE;
        spenderPrivateKey = 0xB0B;
        owner = vm.addr(ownerPrivateKey);
        spender = vm.addr(spenderPrivateKey);

        token = new Token();
        token.mint(owner, 1000000e18);
        sigUtils = new SigUtils(token.DOMAIN_SEPARATOR());
    }

    function test_ApproveByPermit() external {
        uint256 value = 10000;
        uint256 deadline = 1807170245;
        uint256 nonce = token.nonces(owner);
        SigUtils.Permit memory permit =
            SigUtils.Permit({owner: owner, spender: spender, value: value, nonce: nonce, deadline: deadline});

        bytes32 digest = sigUtils.getTypedDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        token.permit(owner, spender, value, deadline, v, r, s);
        assertEq(token.allowance(owner, spender), value);
    }
}
