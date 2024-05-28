We have made modifications to the SnapshotX core repo which you can find here: https://github.com/snapshot-labs/sx-evm  


## Description
This repo demonstrates how you can enable private voting on Inco using FHE.   

We have made modifications to the following contracts:

 **Space.sol** : 
- We have modified the 'vote', 'execute', and 'getProposalStatus' functions to work with encrypted types of TFHE library.
- choice enum is converted to uint8 choice which is then encrypted as ciphertext in the bytes format. 
- votePower is converted from uint256 to euint32 (votePower mapping is where all the votes of (For, Abstain, Against) are aggregated)

```solidity
ebool isAgainst = TFHE.eq(TFHE.asEuint8(choice), TFHE.asEuint8(0));
ebool isFor = TFHE.eq(TFHE.asEuint8(choice), TFHE.asEuint8(1));
ebool isAbstain = TFHE.eq(TFHE.asEuint8(choice), TFHE.asEuint8(2));

votePower[proposalId][0] = TFHE.add(votePower[proposalId][0], TFHE.cmux(isAgainst, TFHE.asEuint32(votingPower), TFHE.asEuint32(0)));
votePower[proposalId][1] = TFHE.add(votePower[proposalId][1], TFHE.cmux(isFor, TFHE.asEuint32(votingPower), TFHE.asEuint32(0)));
votePower[proposalId][2] = TFHE.add(votePower[proposalId][2], TFHE.cmux(isAbstain, TFHE.asEuint32(votingPower), TFHE.asEuint32(0)));
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
cp .env.example .env 
open .env (Add your private key to the .env file.)
npx hardhat compile --network inco 
```

To test the code: 

```sh
npx hardhat test --network inco 
```
