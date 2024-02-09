// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {VerifyingContract} from "../../src/signMessage/VerifyingContract.sol";
import {SigUtils} from "../../src/signMessage/SigUtils.sol";

contract SignMessageTest is Test {
    VerifyingContract verifyingContract;
    SigUtils sigUtils;

    address signer;
    uint256 signerPrivateKey;

    function setUp() external {
        signerPrivateKey = 0xA11CE;
        signer = vm.addr(signerPrivateKey);
        verifyingContract = new VerifyingContract();
        bytes32 domainSeperator = verifyingContract.DOMAIN_SEPERATOR();
        sigUtils = new SigUtils(domainSeperator);
    }

    function test_signAndCheck() external {
        string memory message = "You agree to the terms and conditions";
        // string memory name = verifyingContract.name();
        // string memory version = verifyingContract.version();
        uint256 nonce = verifyingContract.nonces(signer);
        uint256 deadline = 1807337270;

        VerifyingContract.Permit memory permit = VerifyingContract.Permit({
            signer: signer,
            message: message,
            // version: version,
            verifyingContract: address(verifyingContract),
            nonce: nonce,
            deadline: deadline
        });

        bytes32 digest = sigUtils.getTypesDataHash(signer, message, address(verifyingContract), nonce, deadline);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, digest);
        bool status = verifyingContract.permit(permit, v, r, s);
        assertEq(status, true);
    }
}
