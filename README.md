We have made modifications to the SnapshotX core repo which you can find here: https://github.com/snapshot-labs/sx-evm  


## Description
This repo demonstrates private voting on Inco. The key change that we have made is changing the enum Choice in the original repo.  

We have made modifications to the following contracts:

1) **Space.sol** : 
- We have modified the vote, execute, and get proposal status function to work with encrypted types of TFHE library.
- choice enum is converted to encrypted bytes choice
- votePower is converted from uint256 to euint32 (votePower mapping is where all the votes of (For, Abstain, Against) are aggregated)

```solidity
votePower[proposalId][TFHE.decrypt(TFHE.asEuint8(choice))] = TFHE.add(votePower[proposalId][TFHE.decrypt(TFHE.asEuint8(choice))], votingPower);
```

2) **Execution Strategy Module :**
- changed the functions of `execute` and `getProposalStatus` to have the logic of working with encrypted votePower.

```solidity
function _quorumReached(uint256 _quorum, euint32 _votesFor, euint32 _votesAbstain) internal view returns (bool) {      
        euint32 forAndAbstainVotesTotal = _votesFor + _votesAbstain;
        return TFHE.decrypt(TFHE.ge(forAndAbstainVotesTotal,TFHE.asEuint8(_quorum)));
    }
 ```

```solidity
function _supported(euint32 _votesFor, euint32 _votesAgainst) internal view returns (bool) {            
        return TFHE.decrypt(TFHE.gt(_votesFor,_votesAgainst));
    }
 ```

## Testing 

To compile the code: 

```sh
pnpm install
npx hardhat compile --network inco 
```

To test the code: 

```sh
npx hardhat test --network inco 
```
