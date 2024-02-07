// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;


contract VerifyingContract {
    bytes32 immutable public DOMAIN_SEPERATOR;
    uint256 immutable public CHAIN_ID;
    bytes32 constant public DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address signer,string message,address verifyingContract,uint256 nonce,uint256 deadline)");
    string public name;
    string public version;

    mapping(address => uint256) public nonces;

    struct Permit {
        address signer;
        string message;
        address verifyingContract;
        uint256 nonce;
        uint256 deadline;
    }

    error InvalidSigner(address recoveredAddress,address signer);


    constructor() {
        CHAIN_ID = block.chainid;
        DOMAIN_SEPERATOR = computeDomainSeperator();
        name = "EIP712Contract";
        version = "1";
    }

    function computeDomainSeperator() internal view returns(bytes32){
        return(
            keccak256(
                abi.encode(
                    DOMAIN_TYPEHASH,
                    keccak256(bytes(name)),
                    keccak256(bytes(version)),
                    CHAIN_ID,
                    address(this)
                    )
                )
        );
    }

    function eip712Domain() public view returns(
            string memory nameOfDapp,
            string memory currentVersion,
            uint256 chainId,
            address verifyingContract
    ) {
        return (
            name,
            version,
            CHAIN_ID,
            address(this)
        );

    }

    // function _structHash() internal pure returns(bytes32) {
    //     return keccak256(PERMIT_TYPEHASH,"Permit(address signer,string message,string version,address verifyingContract,uint256 deadline,uint256 nonce)");
    // }

    function permit(Permit memory _permit, uint8 v, bytes32 r, bytes32 s) public returns(bool){
        bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH,_permit.signer,_permit.message,_permit.verifyingContract,_permit.nonce,_permit.deadline));
        bytes32 hash = keccak256(abi.encodePacked("\x19\x01",DOMAIN_SEPERATOR,structHash));
        address recoveredAddress = ecrecover(hash, v, r, s);
        if (recoveredAddress != _permit.signer) {
            revert InvalidSigner(recoveredAddress, _permit.signer);
        }
        nonces[_permit.signer]+=1;
        return true;
    }
}