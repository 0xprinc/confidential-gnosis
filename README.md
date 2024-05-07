We have made modifications to the SnapshotX core repo which you can find here: https://github.com/snapshot-labs/sx-evm  

There are three branches in this repo: 

## Main Branch 
This repo demonstrates private voting on Inco. The key change that we have made is changing the enum Choice in the original repo.  

We have made modifications to the following contracts:

1) **Space.sol** : 
- We have modified the vote, execute, and get proposal status function to work with encrypted types of TFHE library.
- choice enum is converted to encrypted bytes choice
- votePower is converted from uint256 to euint32 (votePower mapping is where all the votes of (For, Abstain, Against) are aggregated)

2) **Execution Strategy Module :**
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


## Cross-Chain voting Branch

This repo demonstrates cross-chain private voting between Inco and Redstone. The only logic on Inco is the tallying of the encrypted votes. The rest of the logic (authenticating users, proposal validation strategies, voting strategies remains on the primary chain). We use Hyperlane 's mailbox address to pass messages. We have defined incoendpoint.sol and targetendpoint.sol to pass messages. 

The modifications we made earlier remain the same but we spilt the codebase in the following manner:

Logic on Inco:
- __votePower mapping__ : encrypted values of aggregated votes of (For, against, abstain)
- __inco endpoint contract__ : used for receiving crosschain calls from target chain(redstone)
- __Execution Strategy Module__ : which accesses the votePower mapping and executes

Logic on Redstone: 
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


## Cross-chain voting with modified execution logic branch
 
 
This repo demonstrates cross-chain private voting between Inco and Redstone. The key difference between the multi-chain and cylic transaction branch is that the execution also happens on Redstone. 

Contracts on Inco: 
Modified Execution Strategy Module. Now the execution remains on Redstone, Inco sends the tallied result to Inco.

Contracts on Redstone: 
Rest of the code. 
