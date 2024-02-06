// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {SigUtils} from "../src/eip2612/SigUtils.sol";

contract SigUtilsInstance {
    SigUtils sigUtils = SigUtils(0x7746c853A7cB70083107c2b97bf09d49D17dDe3e);
}

contract InteractPermit is Script, SigUtilsInstance {

    SigUtils.Permit myPermit = SigUtils.Permit({
        owner: 0xCCE71ef4bc4617bf3f7b28722e6F69C760797d43,
        spender: 0x90416E8285169F15346FcF9E336B6E1443b8c30A,
        value: 10000,
        nonce: 0,
        deadline: 1807170245
    });

    function run() external returns (bytes32, bytes32) {
        return getPermitHash();
    }

    function getPermitHash() internal returns (bytes32, bytes32) {
        vm.startBroadcast();
        bytes32 structHash = sigUtils.getStructHash(myPermit);
        bytes32 hashTypedData = sigUtils.getTypedDataHash(myPermit);
        vm.stopBroadcast();
        return (structHash, hashTypedData);
    }
}

// digest: 0x40371086edec43e54880f3dbb6cb561f08144a7003ffad32e26fb870188351bd

contract Sign is Script {
    uint256 ownerPrivateKey = 0xf5c01153b613fb1841815f7fd5636a2cbaad1053ace0068d9889d88999c4815c;
    bytes32 digest = 0x40371086edec43e54880f3dbb6cb561f08144a7003ffad32e26fb870188351bd;

    function run() external view returns (uint8, bytes32, bytes32) {
        return getSign();
    }

    function getSign() internal view returns (uint8, bytes32, bytes32) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);
        return (v, r, s);
    }
}

// 0: uint8 28
// 1: bytes32 0x1454da78ee42692e6465ea20e852ed9da7e287051b7cf727b4f6534ff8a8b0a7
// 2: bytes32 0x61071fc52c5a4fa8a36f2563217c1ec6e91b209c8f52b24d91c491c6f6ceaa05
