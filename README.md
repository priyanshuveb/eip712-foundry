# EIP712

The repo contains two instances of how to use eip712 signature effectively:
1. The first instance is eip2612 which allows you to give approval for an ERC20 token to a spender by signing a message
2. The second instance is more of a general message signing flow to help understand how signed messages are created and verified. This can be leveraged to be used in your own way

<br>

## Getting Started
- git
  - Check if you have git installed by ```git --version```
- foundry
  - Check if you have foundry installed by ```forge --version```

### Quickstart
```bash
git clone https://github.com/priyanshuveb/eip712-foundry.git
cd eip712-foundry
forge build
```
## Usage

### Deploy
- Token
 ```bash
forge script script/DeployToken.s.sol:DeployToken --rpc-url sepolia --private-key ${PRIVATE_KEY_SEPOLIA} --verify --etherscan-api-key sepolia --broadcast -vvvv
 ```
 - SigUtils
  ```bash
forge script script/DeploySigUtils.s.sol:SigUtils <DOMAIN_SEPERATOR_VALUE> --rpc-url sepolia --private-key ${PRIVATE_KEY_SEPOLIA} --verify --sig 'run(bytes32)' --etherscan-api-key sepolia --broadcast -vvvv  
```
Note: The constructor argument of SigUtils.sol i.e. ```DOMAIN_SEPERATOR_VALUE``` will be fetched from the token contract after it has been deployed
## Scripts
Get approval by permit
```bash
forge script script/InteractPermit.s.sol:GetApprovalByPermit --rpc-url sepolia --private-key ${PRIVATE_KEY_SEPOLIA} --broadcast -vvvv
```
## Testing
```bash
forge test
```
## Test Coverage
```bash
forge coverage
```

## Estimate Gas
```bash
forge snapshot
```

## Formatting
```bash
forge fmt
```
