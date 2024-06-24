import { expect } from "chai";
import { assert } from "console";
import { AbiCoder, AddressLike } from "ethers";
import fhevmjs, { FhevmInstance } from "fhevmjs";
import { ethers } from "hardhat";

import { InitializeCalldataStruct, StrategyStruct } from "../../types";
import { createInstances } from "../instance";
import { getSigners } from "../signers";
import { createTransaction } from "../utils";
import { deployEncryptedERC20, deploySafe, deployToken1 } from "./Safe.fixture";
import { Address } from "hardhat-deploy/dist/types";

// Remove the duplicate import statement for 'ethers'

describe("Safe", function () {
  before(async function () {
    this.signers = await getSigners(ethers);
  });

  it("initialize space", async function () {
    console.log("\n 1) Deploying contracts... \n");
    const contractSafe = await deploySafe();  
    const contractToken1 = await deployToken1();
    const contractEncryptedERC20 = await deployEncryptedERC20(await contractToken1.getAddress());

    const addressSafe = await contractSafe.getAddress();
    const addressToken1 = await contractToken1.getAddress();
    const addressEncryptedERC20 = await contractEncryptedERC20.getAddress();

    let fhevmInstance = await createInstances(addressEncryptedERC20, ethers, this.signers);
    const token = fhevmInstance.alice.getPublicKey(addressEncryptedERC20) || {
      signature: "",
      publicKey: "",
    };

    {
      console.log("\n 2) Initializing Safe contract\n");

      let txnhash = await contractSafe.getTransactionHash(
        addressSafe,
        0,
        "0x0d582f130000000000000000000000005f4e77a22e394b51dc7efb8e3c78121e489e78cd0000000000000000000000000000000000000000000000000000000000000001",
        0,
        1000000,
        0,
        1000000,
        addressSafe,
        this.signers.alice.getAddress(),
        0,
      );
      try {
        // const txn = await contractSafe.setup([this.signers.alice.getAddress()], 0, this.signers.alice.getAddress(), "0x", this.signers.alice.getAddress(), this.signers.alice.getAddress(), 0, this.signers.alice.getAddress());
        // const txn = await contractSafe.addOwnerWithThreshold(this.signers.alice.getAddress(), 1);
        const txn = await contractSafe.execTransaction(
          addressSafe,
          0,
          // "0x0d582f1300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001",
          "0x0d582f130000000000000000000000005f4e77a22e394b51dc7efb8e3c78121e489e78cd0000000000000000000000000000000000000000000000000000000000000001",
          0,
          1000000,
          0,
          1000000,
          addressSafe,
          this.signers.alice.getAddress(),
          { gasLimit: 10000000 },
        );
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Transaction successful!");
      } catch (error) {
        console.error("Transaction failed:", error);
      }

      console.log("\n 3) Providing tokens to safe contract\n");

      try {
        const txn = await contractToken1.mint(addressSafe, 1000000);
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Transaction successful!");
      } catch (error) {
        console.error("Transaction failed:", error);
      }

      try {
        let fnSelector = "0x095ea7b3";

        const txn = await contractSafe.execTransaction(
          addressToken1,
          0,
          fnSelector +
            AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [addressEncryptedERC20, 1000000]).slice(2),
          0,
          1000000,
          0,
          1000000,
          addressSafe,
          this.signers.alice.getAddress(),
          { gasLimit: 10000000 },
        );
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Transaction successful!");
      } catch (error) {
        console.error("Transaction failed:", error);
      }

      console.log(await contractToken1.getallowance(addressSafe, addressEncryptedERC20));
    }
    
      console.log("\n 4) Deposit and distribute\n");
      let fnSelector = "0xf98aa085";

      const amount = 1000000;
      const data1 = [await this.signers.bob.getAddress(), fhevmInstance.alice.encrypt32(10000)];
      const data2 = [await this.signers.carol.getAddress(), fhevmInstance.alice.encrypt32(30000)];
      const data3 = [await this.signers.dave.getAddress(), fhevmInstance.alice.encrypt32(960000)];

      // Create an array of depositstruct
      const depositData = [data1, data2, data3];

      // // Encode the data
      const abiCoder = AbiCoder.defaultAbiCoder();
      const encodedData1 = abiCoder.encode(
        ["tuple(address,bytes)[]"],
        [depositData]
      );


      const encodedData2 = abiCoder.encode(
        ["uint256", "bytes"],
        [amount, encodedData1]
      );


      try {
        // const txn = await contractSafe.setup([this.signers.alice.getAddress()], 0, this.signers.alice.getAddress(), "0x", this.signers.alice.getAddress(), this.signers.alice.getAddress(), 0, this.signers.alice.getAddress());
        // const txn = await contractSafe.addOwnerWithThreshold(this.signers.alice.getAddress(), 1);
        const txn = await contractSafe.execTransaction(
          addressEncryptedERC20,
          0,
          fnSelector + encodedData2.slice(2),
          // "0xc6dad082",
          0,
          1000000,
          0,
          // 1000000,
          0,
          this.signers.alice.getAddress(),
          addressSafe,
          { gasLimit: 10000000 },
        );
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Transaction successful!");
      } catch (error) {
        console.error("Transaction failed:", error);
      }

      let newbalanceofcarol = (await contractEncryptedERC20.balanceOf(token.publicKey, this.signers.carol.getAddress())).toString();
      console.log("new balance of carol: ", + fhevmInstance.alice.decrypt(addressEncryptedERC20, newbalanceofcarol));

      console.log(await contractToken1.balanceOf(addressEncryptedERC20));

      // console.log(await contractEncryptedERC20.connect(this.signers.bob).claim());
      // console.log(await contractEncryptedERC20.connect(this.signers.carol).claim());
      // console.log(await contractEncryptedERC20.connect(this.signers.dave).claim());


      try {
        const txn = await contractEncryptedERC20.connect(this.signers.bob).claim();
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Transaction successful!");
      } catch (error) {
        console.error("Transaction failed:", error);
      }
      try {
        const txn = await contractEncryptedERC20.connect(this.signers.carol).claim();
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Transaction successful!");
      } catch (error) {
        console.error("Transaction failed:", error);
      }
      try {
        const txn = await contractEncryptedERC20.connect(this.signers.dave).claim();
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Transaction successful!");
      } catch (error) {
        console.error("Transaction failed:", error);
      }

      console.log(await contractToken1.balanceOf(await this.signers.bob.getAddress()));
      console.log(await contractToken1.balanceOf(await this.signers.carol.getAddress()));
      console.log(await contractToken1.balanceOf(await this.signers.dave.getAddress()));
    
    });
});
