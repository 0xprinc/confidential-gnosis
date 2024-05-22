We have made modifications to the SnapshotX core repo which you can find here: https://github.com/snapshot-labs/sx-evm  


## Description
This repo demonstrates how you can enable private voting on Inco using FHE.   

We have made modifications to the following contracts:

 **Space.sol** : 
- We have modified the 'vote', 'execute', and 'getProposalStatus' functions to work with encrypted types of TFHE library.
- choice enum is converted to uint8 choice which is then encrypted as ciphertext in the bytes format. 
- votePower is converted from uint256 to euint32 (votePower mapping is where all the votes of (For, Abstain, Against) are aggregated)

```solidity
votePower[proposalId][TFHE.decrypt(TFHE.asEuint8(choice))] = TFHE.add(votePower[proposalId][TFHE.decrypt(TFHE.asEuint8(choice))], votingPower);
```

 **Execution Strategy Module :**
- Modified `execute` and `getProposalStatus` and it's helper functions '_quorumReached' and '_supported':

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
