// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract SigUtils {
    bytes32 public immutable DOMAIN_SEPERATOR;
    uint256 public immutable CHAIN_ID;
    bytes32 private constant PERMIT_TYPEHASH =
        keccak256("Permit(address signer,string message,address verifyingContract,uint256 nonce,uint256 deadline)");

    constructor(bytes32 domainSeperator) {
        DOMAIN_SEPERATOR = domainSeperator;
        CHAIN_ID = block.chainid;
    }

    function getTypesDataHash(
        address _signer,
        string memory _message,
        address _verifyingContract,
        uint256 _nonce,
        uint256 _deadline
    ) public view returns (bytes32) {
        bytes32 structHash =
            keccak256(abi.encode(PERMIT_TYPEHASH, _signer, _message, _verifyingContract, _nonce, _deadline));
        bytes32 hash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPERATOR, structHash));
        return hash;
    }
}
