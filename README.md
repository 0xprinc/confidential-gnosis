We have made modifications to the SnapshotX core repo which you can find here: https://github.com/snapshot-labs/sx-evm  

There are three branches in this repo: 

## Main Branch 
This repo demonstrates private voting on Inco. 

We have made modifications to the following contracts:

`votePower mapping is where all the votes of (For, Abstain, Against) are aggregated`

`Space.sol` : 
- We have modified the vote, execute, and get proposal status function to work with encrypted types of TFHE library.
- choice enum is converted to encrypted bytes choice
- votePower is converted from uint256 to euint32

`Execution Strategies` :
- changed the functions of `execute` and `getProposalStatus` to have the logic of working with encrypted votePower.

To compile the code: 

```sh
pnpm install
npx hardhat compile --network inco 
```

To test the code: 

```sh
npx hardhat test --network inco 
```


## Multi-chain Branch

This repo demonstrates cross-chain private voting between Inco and Redstone. 

What's on Inco:
- __votePower mapping__ : encrypted values of aggregated votes of (For, against, abstain)
- __inco endpoint contract__ : used for receiving crosschain calls from target chain(redstone)
- __Execution Strategy Module__ : which accesses the votePower mapping and executes

What's on Redstone: 
- __target Endpoint contract__ : used for sending data to inco endpoint contract
- all other modules and Space.sol(main contract)

To compile the code: 

```sh
pnpm install
npx hardhat compile --network inco 
```

To test the code: 

```sh
npx hardhat crossdeploy --network redstone
```

Changes made :
- `vote` and `execute` function are changed to call `targetEndpoint` as `votePower` mapping is present in inco


## Cyclic Transaction Branch
 
 
This repo demonstrates cross-chain private voting between Inco and Redstone. The key difference between the multi-chain and cylic transaction branch is that the execution also happens on Redstone. 

Contracts on Inco: 
Modified Execution Strategy Module. Now the execution remains on Redstone, Inco sends the tallied result to Inco.

Contracts on Redstone: 
Rest of the code. 


 
 src
├─ authenticators
│  ├─ Authenticator.sol - "Base Authenticator contract"
│  ├─ EthSigAuthenticator.sol - "Strategy that authenticates users via an EIP712 signature"
│  ├─ EthTxAuthenticator.sol - "Strategy that authenticates users via checking the tx sender address"
│  └─ VanillaAuthenticator.sol — "Vanilla Strategy"
├─ voting-strategies
│  ├─ CompVotingStrategy.sol - "Strategy that uses delegated balances of Comp tokens as voting power"
│  ├─ OZVotesVotingStrategy.sol - "Strategy that uses delegated balances of OZ Votes tokens as voting power"
│  ├─ WhitelistVotingStrategy.sol — "Strategy that gives predetermined voting power for members in a whitelist. Whitelist is stored in a bytes array On-Chain."
│  ├─ MerkleWhitelistVotingStrategy.sol — "Strategy that gives predetermined voting power for members in a whitelist. Whitelist is stored in a Merkle tree Off-Chain, with only the root being stored On-Chain."
│  └─ VanillaVotingStrategy.sol — "Vanilla Strategy"
├─ execution-strategies
│  ├─ timelocks
│  |  ├─ CompTimelockCompatibleExecutionStrategy.sol - "Strategy that provides compatibility with existing Comp Timelock contracts"
│  |  ├─ OptimisticCompTimelockCompatibleExecutionStrategy.sol - "Optimistic strategy that provides compatibility with existing Comp Timelock contracts"
│  |  ├─ OptimisticTimelockExecutionStrategy.sol - "Optimistic strategy that can be used to execute proposal transactions according to a timelock delay"
│  |  └─ TimelockExecutionStrategy.sol - "Strategy that can be used to execute proposal transactions according to a timelock delay"
│  ├─ AvatarExecutionStrategy.sol - "Strategy that allows proposal transactions to be executed from an Avatar contract"
│  ├─ TimelockExecutionStrategy.sol - "Strategy that can be used to execute proposal transactions according to a timelock delay"
│  ├─ CompTimelockCompatibleExecutionStrategy.sol - "Strategy that provides compatibility with existing Comp Timelock contracts"
│  ├─ EmergencyQuorumExecutionStrategy.sol - "Base Strategy that uses an additional Emergency Quorum to determine the status of a proposal"
│  ├─ OptimisticQuorumExecutionStrategy.sol - "Base Strategy that uses an Optimistic Quorum to determine the status of a proposal"
│  ├─ SimpleQuorumExecutionStrategy.sol - "Base Strategy that uses a Simple Quorum to determine the status of a proposal"
│  └─ VanillaExecutionStrategy.sol - "Vanilla Strategy"
├─ interfaces
│  ├─ ...
├─ proposal-validation-strategies
│  ├─ ActiveProposalsLimiterProposalValidationStrategy.sol - "Strategy to that validates with the ActiveProposalsLimiter module"
│  ├─ PropositionPowerAndActiveProposalsLimiterProposalValidationStrategy.sol - "Strategy that validates with the ActiveProposalsLimiter and PropositionPower modules"
│  └─ PropositionPowerProposalValidationStrategy.sol - "Strategy that validates with the PropositionPower module"
├─ utils
│  ├─ ActiveProposalsLimiter.sol - "Module to limit the number of active proposals per author"
│  ├─ BitPacker.sol - "Uint256 Bit Setting and Checking Library"
│  ├─ PropositionPower.sol - "Module that checks proposal authors exceed a threshold proposition power over a set of strategies"
│  ├─ SXHash.sol - "Snapshot X Types Hashing Library"
│  ├─ SXUtils.sol - "Snapshot X Types Utilities Library"
│  ├─ SignatureVerifier.sol - "Verifies EIP712 Signatures for Snapshot X actions"
│  └─ SpaceManager.sol - "Manages a whitelist of Spaces that have permissions to execute transactions"
├─ ProxyFactory.sol - "Handles the deployment and tracking of Space contracts"
└─ Space.sol - "The base contract for each Snapshot X space"
└─ types.sol - "Definitions for Snapshot X custom types"
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 Hardhat Template [![Open in Gitpod][gitpod-badge]][gitpod] [![Github Actions][gha-badge]][gha] [![Hardhat][hardhat-badge]][hardhat] [![License: MIT][license-badge]][license]

## Getting Started

Click the [`Use this template`](https://github.com/inco-fhevm/fhevm-hardhat-template/generate) button at the top of the
page to create a new repository with this repo as the initial state.

## Usage

### Pre Requisites

Install [pnpm](https://pnpm.io/installation)

Before being able to run any command, you need to create a `.env` file and set a BIP-39 compatible mnemonic as an
environment variable. If you don't already have a mnemonic, you can use this [website](https://iancoleman.io/bip39/) to
generate one. You can run the following command to use the example .env:

```sh
cp .env.example .env
```

Then, proceed with installing dependencies:

```sh
pnpm install
```

### Compile

Compile the smart contracts with Hardhat:

```sh
npx hardhat compile --network inco
```

### Deploy

Deploy the ERC20 to Inco Gentry Testnet Network:

```sh
npx hardhat deploy --network inco
```


### Test

Run the tests with Hardhat:

```sh
npx hardhat test --network inco
```

## License

This project is licensed under MIT.
