// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PermitToken is ERC20 {
    bytes32 private immutable DOMAIN_SEPERATOR;
    uint256 private immutable CHAIN_ID;

    mapping(address => uint256) public nonces;

    constructor(string memory name, string memory symbol, uint256 amount, address minter) ERC20(name, symbol) {
        CHAIN_ID = block.chainid;
        DOMAIN_SEPERATOR = computeDomainSeperator();
        _mint(minter, amount);
    }

    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        public
    {
        require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");

        // Unchecked because the only math done is incrementing
        // the owner's nonce which cannot realistically overflow.
        unchecked {
            address recoveredAddress = ecrecover(
                keccak256(
                    abi.encodePacked(
                        "\x19\x01",
                        domainSeperator(),
                        keccak256(
                            abi.encode(
                                keccak256(
                                    "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
                                ),
                                owner,
                                spender,
                                value,
                                nonces[owner]++,
                                deadline
                            )
                        )
                    )
                ),
                v,
                r,
                s
            );

            require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");

            _approve(recoveredAddress, spender, value);
        }
    }

    function computeDomainSeperator() internal view returns (bytes32) {
        return (
            keccak256(
                abi.encode(
                    keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                    keccak256(bytes(name())),
                    keccak256("1"),
                    block.chainid,
                    address(this)
                )
            )
        );
    }

    // view functions
    function domainSeperator() public view returns (bytes32) {
        return block.chainid == CHAIN_ID ? DOMAIN_SEPERATOR : computeDomainSeperator();
    }
}
