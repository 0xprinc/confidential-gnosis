import { expect } from "chai";
import { ethers } from "hardhat";

import { createInstances } from "../instance";
import { getSigners } from "../signers";
import { createTransaction } from "../utils";
import { deploySpace, deployVotingStrategy, deployExecutionStrategy, deployValidationStrategy, deployAuthenticator } from "./Space.fixture";
import { InitializeCalldataStruct, StrategyStruct } from "../../types";
import { assert } from "console";
import fhevmjs, { FhevmInstance } from "fhevmjs";

import { AbiCoder } from "ethers";

// Remove the duplicate import statement for 'ethers'

describe("Space", function () {
  before(async function () {
    this.signers = await getSigners(ethers);
  });

  // beforeEach(async function () {

  // });

  

  it("initialize space", async function () {

    const contractSpace = await deploySpace();
    const contractVotingStrategy = await deployVotingStrategy();
    const contractExecutionStrategy = await deployExecutionStrategy();
    const contractValidationStrategy = await deployValidationStrategy();
    const contractAuthenticator = await deployAuthenticator();

    const addressSpace = await contractSpace.getAddress();
    const addressVotingStrategy = await contractVotingStrategy.getAddress();
    const addressExecutionStrategy = await contractExecutionStrategy.getAddress();
    const addressValidationStrategy = await contractValidationStrategy.getAddress();
    const addressAuthenticator = await contractAuthenticator.getAddress();
    const addressSigner = await this.signers.alice.getAddress();

    let fhevmInstance = await createInstances(addressSpace, ethers, this.signers);

{
    console.log("\n\n\n\ninitializing Space contract \n");
    
    let data0 : StrategyStruct = {
      addr: addressValidationStrategy,
      params: "0x"
    }

    let data1 : StrategyStruct = {
      addr: addressVotingStrategy,
      params: "0x"
    }


    let data : InitializeCalldataStruct = {
      owner: addressSigner, // Example address
      votingDelay: 0,
      minVotingDuration: 0,
      maxVotingDuration: 1000,
      proposalValidationStrategy: data0,
      proposalValidationStrategyMetadataURI: "proposalValidationStrategyMetadataURI",
      daoURI: "SOC Test DAO",
      metadataURI: "SOC Test Space",
      votingStrategies: [data1],
      votingStrategyMetadataURIs: ["votingStrategyMetadataURIs"],
      authenticators: [addressAuthenticator]
    };
    // console.log("owner before initialize: " + await contractSpace.owner());
    try {
      const txn = await contractSpace.initialize(data);
      console.log("Transaction hash:", txn.hash);
    
      // Wait for 1 confirmation (adjust confirmations as needed)
      await txn.wait(1);
      console.log("Transaction successful!");
    } catch (error) {
      console.error("Transaction failed:", error);
      // Handle the error appropriately (e.g., retry, notify user)
    }
    // console.log("alice address -> " + addressSigner);
    // console.log("owner after initialize: " + await contractSpace.owner());
    // assert(addressSigner == contractSpace.owner());

}

{
    console.log("\n\n\n\n\n making a proposal \n");

    let data2propose =
      [
        addressSigner,
        "",
        [
          addressExecutionStrategy, "0x"
        ],
        "0x",
      ];
    
    // console.log(AbiCoder.defaultAbiCoder().encode(["address", "string", "tuple(address, bytes)", "bytes"], data2propose));

    // console.log("old proposal -> " + await contractSpace.proposals(1));
    try {
      const txn = await contractAuthenticator.authenticate(addressSpace, '0xaad83f3b', AbiCoder.defaultAbiCoder().encode(["address", "string", "tuple(address, bytes)", "bytes"], data2propose));
      console.log("Transaction hash:", txn.hash);

      // Wait for 1 confirmation (adjust confirmations as needed)
      await txn.wait(1);
      console.log("Transaction2 successful!");
    } catch (error) {
      console.error("Transaction failed:", error);
      // Handle the error appropriately (e.g., retry, notify user)
    }
    
    console.log("new proposal -> " + await contractSpace.proposals(1));

}

{
    console.log("\n\n\n\n\n voting \n");

    let data2voteAbstain = [
      addressSigner,
      1,
      fhevmInstance.alice.encrypt8(2),
      [[0,"0x"]],
      ""
    ];
    let data2voteFor1 = [
      await this.signers.bob.getAddress(),
      1,
      fhevmInstance.alice.encrypt8(1),
      [[0,"0x"]],
      ""
    ];
    let data2voteFor2 = [
      await this.signers.dave.getAddress(),
      1,
      fhevmInstance.alice.encrypt8(1),
      [[0,"0x"]],
      ""
    ];
    let data2voteAgainst = [
      await this.signers.carol.getAddress(),
      1,
      fhevmInstance.alice.encrypt8(0),
      [[0,"0x"]],
      ""
    ];
    // console.log("votePower before vote -> " + (await contractSpace.votePower(1, 2)).toString());
    console.log("current block number -> " + await ethers.provider.getBlockNumber());
    try {
      const txn = await contractAuthenticator.authenticate(addressSpace, '0x954ee6da', AbiCoder.defaultAbiCoder().encode(["address", "uint256", "bytes", "tuple(uint8, bytes)[]", "string"], data2voteAgainst));
      console.log("Transaction hash:", txn.hash);

      // Wait for 1 confirmation (adjust confirmations as needed)
      await txn.wait(1);
      console.log("Against successful!");
    } catch (error) {
      console.error("Transaction failed:", error);
      // Handle the error appropriately (e.g., retry, notify user)
    }
    try {
      const txn = await contractAuthenticator.authenticate(addressSpace, '0x954ee6da', AbiCoder.defaultAbiCoder().encode(["address", "uint256", "bytes", "tuple(uint8, bytes)[]", "string"], data2voteFor1));
      console.log("Transaction hash:", txn.hash);

      // Wait for 1 confirmation (adjust confirmations as needed)
      await txn.wait(1);
      console.log("For1 successful!");
    } catch (error) {
      console.error("Transaction failed:", error);
      // Handle the error appropriately (e.g., retry, notify user)
    }
    try {
      const txn = await contractAuthenticator.authenticate(addressSpace, '0x954ee6da', AbiCoder.defaultAbiCoder().encode(["address", "uint256", "bytes", "tuple(uint8, bytes)[]", "string"], data2voteFor2));
      console.log("Transaction hash:", txn.hash);

      // Wait for 1 confirmation (adjust confirmations as needed)
      await txn.wait(1);
      console.log("For2 successful!");
    } catch (error) {
      console.error("Transaction failed:", error);
      // Handle the error appropriately (e.g., retry, notify user)
    }
    try {
      const txn = await contractAuthenticator.authenticate(addressSpace, '0x954ee6da', AbiCoder.defaultAbiCoder().encode(["address", "uint256", "bytes", "tuple(uint8, bytes)[]", "string"], data2voteAbstain));
      console.log("Transaction hash:", txn.hash);

      // Wait for 1 confirmation (adjust confirmations as needed)
      await txn.wait(1);
      console.log("Abstain successful!");
    } catch (error) {
      console.error("Transaction failed:", error);
      // Handle the error appropriately (e.g., retry, notify user)
    }
    console.log("current block number -> " + await ethers.provider.getBlockNumber());


    const token = fhevmInstance.alice.getTokenSignature(addressSpace) || {
      signature: "",
      publicKey: "",
    };

    let For_votes = (await contractSpace.getVotePower(1, 1, token.publicKey)).toString();
    let Abstain_votes = (await contractSpace.getVotePower(1, 2, token.publicKey)).toString();
    let Against_votes = (await contractSpace.getVotePower(1, 0, token.publicKey)).toString();
    console.log(For_votes);
    console.log(Abstain_votes);
    console.log(Against_votes);
    
    console.log("For votes -> " +     fhevmInstance.alice.decrypt(addressSpace, For_votes));
    console.log("Abstain votes -> " + fhevmInstance.alice.decrypt(addressSpace, Abstain_votes));
    console.log("Against votes -> " + fhevmInstance.alice.decrypt(addressSpace, Against_votes));
}


    console.log("current block number -> " + await ethers.provider.getBlockNumber());
    console.log("\n\n\n\n execution \n");
    let executionPayload = "0x";
    try {
      const txn = await contractSpace.execute(1, executionPayload);
      console.log("Transaction hash:", txn.hash);

      // Wait for 1 confirmation (adjust confirmations as needed)
      await txn.wait(1);
      console.log("execution successful!");
    } catch (error) {
      console.error("Transaction failed:", error);
      // Handle the error appropriately (e.g., retry, notify user)
    }
    
    console.log("1 if executed -> " + (await contractSpace.proposals(1)).finalizationStatus);
  });

});

// });