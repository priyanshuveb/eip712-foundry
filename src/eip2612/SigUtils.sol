// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

///@title SigUtils
///@author Priyanshu Bindal
///@notice The contract helps us to calculate the digest which then can be signed by the user to
/// generate the signature
contract SigUtils {
    bytes32 public immutable DOMAIN_SEPARATOR;
    bytes32 public constant PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    ///@dev Initializes the DOMAIN_SEPERATOR
    constructor(bytes32 _DOMAIN_SEPARATOR) {
        DOMAIN_SEPARATOR = _DOMAIN_SEPARATOR;
    }

    struct Permit {
        address owner;
        address spender;
        uint256 value;
        uint256 nonce;
        uint256 deadline;
    }

    ///@notice Computes the hash of a permit struct
    ///@param _permit The Permit struct having values about the signature
    ///@return bytes32 Returns the struct hash that will be used to calculate digest
    function getStructHash(Permit memory _permit) public pure returns (bytes32) {
        return keccak256(
            abi.encode(PERMIT_TYPEHASH, _permit.owner, _permit.spender, _permit.value, _permit.nonce, _permit.deadline)
        );
    }

    ///@notice Computes the hash of the fully encoded EIP-712 message with the domain, which can be used to recover the signer
    ///@param _permit The Permit struct having values about the signature
    ///@return bytes32 Returns the digest to be signed
    function getTypedDataHash(Permit memory _permit) public view returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, getStructHash(_permit)));
    }
}
