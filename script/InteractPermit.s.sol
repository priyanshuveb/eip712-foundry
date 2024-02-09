// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {SigUtils} from "../src/eip2612/SigUtils.sol";
import {Token} from "../src/eip2612/Token.sol";

contract TokenInstance {
    Token token = Token(0x98F73f8Bc978D365B32C9d0c2ef6d169f653b2F4);
}

contract SigUtilsInstance {
    SigUtils sigUtils = SigUtils(0xdb5182B327E1BAd8EA47f66bdD0B9a5CC5C20FaC);
}

contract GetApprovalByPermit is Script, SigUtilsInstance, TokenInstance {
    uint256 ownerPrivateKey = vm.envUint("PRIVATE_KEY_SEPOLIA");
    address owner = 0x90416E8285169F15346FcF9E336B6E1443b8c30A;
    address spender = 0xb62803C3f1c7112CAd3F35a503504C3B0920eDBF;
    uint256 value = 10000;
    uint256 nonce;
    uint256 deadline = 1807170245;

    function run() external {
        getPermit();
    }

    function getPermit() internal {
        vm.startBroadcast();

        nonce = token.nonces(owner);

        SigUtils.Permit memory myPermitValues =
            SigUtils.Permit({owner: owner, spender: spender, value: value, nonce: nonce, deadline: deadline});
        bytes32 digest = sigUtils.getTypedDataHash(myPermitValues);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);
        token.permit(owner, spender, value, deadline, v, r, s);
        vm.stopBroadcast();
    }
}
