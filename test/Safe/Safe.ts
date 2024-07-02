import { expect } from "chai";
import { assert } from "console";
import { AbiCoder, AddressLike, Signature } from "ethers";
import fhevmjs, { FhevmInstance } from "fhevmjs";
import { ethers } from "hardhat";
import {
  safeApproveHash,
  buildSignatureBytes,
  executeContractCallWithSigners,
  buildSafeTransaction,
  executeTx,
  calculateSafeTransactionHash,
  buildContractCall,
} from "../execution";

// import { InitializeCalldataStruct, StrategyStruct } from "../../types";
import { createInstances } from "../instance";
import { getSigners } from "../signers";
import { createTransaction } from "../utils";
import { deployEncryptedERC20, deploySafe, deployERC20 } from "./Safe.fixture";
import { Address } from "hardhat-deploy/dist/types";
// import {buildSafeTransaction, buildSignatureBytes, safeApproveHash} from "../execution";

// Remove the duplicate import statement for 'ethers'

describe("Safe", function () {
  before(async function () {
    this.signers = await getSigners(ethers);
  });

  it("initialize space", async function () {
    console.log("\n 1) Deploying contracts... \n");
    const contractOwnerSafe = await deploySafe([this.signers.alice.getAddress(), this.signers.eve.getAddress()], 1);  
    const contractBobSafe = await deploySafe([this.signers.bob.getAddress(), this.signers.eve.getAddress()], 1);  
    const contractCarolSafe = await deploySafe([this.signers.carol.getAddress(), this.signers.eve.getAddress()], 1);  
    const contractDaveSafe = await deploySafe([this.signers.dave.getAddress(), this.signers.eve.getAddress()], 1);  
    const contractERC20 = await deployERC20();
    const contractEncryptedERC20 = await deployEncryptedERC20(await contractERC20.getAddress());

    const addressOwnerSafe = await contractOwnerSafe.getAddress();
    const addressBobSafe = await contractBobSafe.getAddress();
    const addressCarolSafe = await contractCarolSafe.getAddress();
    const addressDaveSafe = await contractDaveSafe.getAddress();
    const addressERC20 = await contractERC20.getAddress();
    const addressEncryptedERC20 = await contractEncryptedERC20.getAddress();

    console.log("owner safe address: " + addressOwnerSafe);
    console.log("bob safe address: " + addressBobSafe);
    console.log("carol safe address: " + addressCarolSafe);
    console.log("dave safe address: " + addressDaveSafe);
    console.log("erc20 address: " + addressERC20);
    console.log("encrypted erc20 address: " + addressEncryptedERC20);

    let fhevmInstance = await createInstances(addressEncryptedERC20, ethers, this.signers);
    const token = fhevmInstance.alice.getPublicKey(addressEncryptedERC20) || {
      signature: "",
      publicKey: "",
    };

    {

      console.log("\n 3) Providing tokens to safe contract\n");

      try {
        const txn = await contractERC20.mint(addressOwnerSafe, 1000000);
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Minting 1_000_000 tokens to Owner Safe successful!");
      } catch (error) {
        console.error("Minting 1_000_000 tokens to Owner Safe failed:", error);
      }

      try {
        let fnSelector = "0x095ea7b3";

        let txnhash = await contractOwnerSafe.getTransactionHash(
          addressERC20,
          0,
          fnSelector +
            AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [addressEncryptedERC20, 1000000]).slice(2),
          0,
          1000000,
          0,
          1000000,
          addressOwnerSafe,
          this.signers.alice.getAddress(),
        await contractOwnerSafe.nonce()
      );

      const txn1 = {
        to: addressERC20,
        value : 0,
        data : fnSelector + AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [addressEncryptedERC20, 1000000]).slice(2),
        operation : 0,
        safeTxGas : 1000000,
        baseGas : 0,
        gasPrice : 1000000,
        gasToken : addressOwnerSafe,
        refundReceiver : this.signers.alice.getAddress(),
        nonce : await contractOwnerSafe.nonce()
      };

      const tx = buildSafeTransaction(txn1);
      const signatureBytes = buildSignatureBytes([await safeApproveHash(this.signers.alice, contractOwnerSafe, tx, true)]);

        const txn = await contractOwnerSafe.execTransaction(
          addressERC20,
          0,
          fnSelector +
            AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [addressEncryptedERC20, 1000000]).slice(2),
          0,
          1000000,
          0,
          1000000,
          addressOwnerSafe,
          this.signers.alice.getAddress(),
          signatureBytes,
          { gasLimit: 10000000 },
        );
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Approval to EncryptedERC20 successful!");
      } catch (error) {
        console.error("Approval to EncryptedERC20 failed:", error);
      }

      console.log("Allowed no. of tokens: " + await contractERC20.getallowance(addressOwnerSafe, addressEncryptedERC20));
    }
    
      console.log("\n 4) Deposit and distribute\n");
      console.log("Distributing 10_000, 30_000, 960_000 tokens to Bob, Carol, Dave safes respectively\n");
      let fnSelector = "0xf98aa085";

      const amount = 1000000;
      const data1 = [addressBobSafe, fhevmInstance.alice.encrypt32(10000)];
      const data2 = [addressCarolSafe, fhevmInstance.alice.encrypt32(30000)];
      const data3 = [addressDaveSafe, fhevmInstance.alice.encrypt32(960000)];

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

      // console.log(await contractOwnerSafe.checkSignatures(txnhash,signatureBytes));

      let txnhash2 = await contractOwnerSafe.getTransactionHash(
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
          addressOwnerSafe,
      await contractOwnerSafe.nonce()
    );

    const txn2 = {
      to: addressEncryptedERC20,
      value : 0,
      data : fnSelector + encodedData2.slice(2),
      operation : 0,
      safeTxGas : 1000000,
      baseGas : 0,
      gasPrice : 0,
      gasToken : this.signers.alice.getAddress(),
      refundReceiver : addressOwnerSafe,
      nonce : await contractOwnerSafe.nonce()
    };

    const tx2 = buildSafeTransaction(txn2);
    const signatureBytes2 = buildSignatureBytes([await safeApproveHash(this.signers.alice, contractOwnerSafe, tx2, true)]);

      try {
        // const txn = await contractOwnerSafe.setup([this.signers.alice.getAddress()], 0, this.signers.alice.getAddress(), "0x", this.signers.alice.getAddress(), this.signers.alice.getAddress(), 0, this.signers.alice.getAddress());
        // const txn = await contractOwnerSafe.addOwnerWithThreshold(this.signers.alice.getAddress(), 1);
        const txn = await contractOwnerSafe.execTransaction(
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
          addressOwnerSafe,
          signatureBytes2,
          { gasLimit: 10000000 },
        );
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Wrap and distribute to receiver safes successful!");
      } catch (error) {
        console.error("Wrap and distribute to receiver safes failed:", error);
      }

      console.log("ERC20 tokens held by Encrypted20 contract: " + await contractERC20.balanceOf(addressEncryptedERC20) + "\n");

      let claimFnSelector = "0x4e71d92d";

      let txnhash3 = await contractOwnerSafe.getTransactionHash(
        addressEncryptedERC20,
          0,
          claimFnSelector,
          // "0xc6dad082",
          0,
          1000000,
          0,
          // 1000000,
          0,
          this.signers.alice.getAddress(),
          addressOwnerSafe,
      await contractOwnerSafe.nonce()
    );

    const txn3 = {
      to: addressEncryptedERC20,
      value : 0,
      data : claimFnSelector,
      operation : 0,
      safeTxGas : 1000000,
      baseGas : 0,
      gasPrice : 0,
      gasToken : this.signers.alice.getAddress(),
      refundReceiver : addressOwnerSafe,
      nonce : await contractOwnerSafe.nonce()
    };

    const tx3 = buildSafeTransaction(txn3);
    const signatureBytes3 = buildSignatureBytes([await safeApproveHash(this.signers.bob, contractBobSafe, tx3, true)]);

    // console.log(await contractBobSafe.connect(this.signers.bob).checkSignatures(txnhash3,signatureBytes3));

      try {
        const txn = await contractBobSafe.connect(this.signers.bob).execTransaction(
          addressEncryptedERC20,
          0,
          claimFnSelector,
          // "0xc6dad082",
          0,
          1000000,
          0,
          // 1000000,
          0,
          this.signers.alice.getAddress(),
          addressOwnerSafe,
          signatureBytes3,
          { gasLimit: 10000000 },
        );
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Claim by Bob safe successful!");
      } catch (error) {
        console.error("Claim by Bob safe failed:", error);
      }

      let txnhash4 = await contractOwnerSafe.getTransactionHash(
        addressERC20,
        0,
        fnSelector +
          AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [addressEncryptedERC20, 1000000]).slice(2),
        0,
        1000000,
        0,
        1000000,
        addressOwnerSafe,
        this.signers.alice.getAddress(),
      await contractOwnerSafe.nonce()
    );

    const txn1 = {
      to: addressERC20,
      value : 0,
      data : fnSelector + AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [addressEncryptedERC20, 1000000]).slice(2),
      operation : 0,
      safeTxGas : 1000000,
      baseGas : 0,
      gasPrice : 1000000,
      gasToken : addressOwnerSafe,
      refundReceiver : this.signers.alice.getAddress(),
      nonce : await contractOwnerSafe.nonce()
    };

    const tx = buildSafeTransaction(txn1);
    const signatureBytes4 = buildSignatureBytes([await safeApproveHash(this.signers.carol, contractCarolSafe, tx, true)]);

      try {
        const txn = await contractCarolSafe.connect(this.signers.carol).execTransaction(
          addressEncryptedERC20,
          0,
          claimFnSelector,
          // "0xc6dad082",
          0,
          1000000,
          0,
          // 1000000,
          0,
          this.signers.alice.getAddress(),
          addressOwnerSafe,
          signatureBytes4,
          { gasLimit: 10000000 },
        );
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Claim by Carol safe successful!");
      } catch (error) {
        console.error("Claim by Carol safe failed:", error);
      }

      let txnhash5 = await contractOwnerSafe.getTransactionHash(
        addressERC20,
        0,
        fnSelector +
          AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [addressEncryptedERC20, 1000000]).slice(2),
        0,
        1000000,
        0,
        1000000,
        addressOwnerSafe,
        this.signers.alice.getAddress(),
      await contractOwnerSafe.nonce()
    );

    const txn5 = {
      to: addressERC20,
      value : 0,
      data : fnSelector + AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [addressEncryptedERC20, 1000000]).slice(2),
      operation : 0,
      safeTxGas : 1000000,
      baseGas : 0,
      gasPrice : 1000000,
      gasToken : addressOwnerSafe,
      refundReceiver : this.signers.alice.getAddress(),
      nonce : await contractOwnerSafe.nonce()
    };

    const tx5 = buildSafeTransaction(txn5);
    const signatureBytes5 = buildSignatureBytes([await safeApproveHash(this.signers.dave, contractDaveSafe, tx5, true)]);

      try {
        const txn = await contractDaveSafe.connect(this.signers.dave).execTransaction(
          addressEncryptedERC20,
          0,
          claimFnSelector,
          // "0xc6dad082",
          0,
          1000000,
          0,
          // 1000000,
          0,
          this.signers.alice.getAddress(),
          addressOwnerSafe,
          signatureBytes5,
          { gasLimit: 10000000 },
        );
        console.log("Transaction hash:", txn.hash);
        await txn.wait(1);
        console.log("Claim by Dave safe successful!");
      } catch (error) {
        console.error("Claim by Dave safe failed:", error);
      }
      
      console.log("Final ERC20 balance of Bob Safe: " + await contractERC20.balanceOf(addressBobSafe));
      console.log("Final ERC20 balance of Carol Safe: " + await contractERC20.balanceOf(addressCarolSafe));
      console.log("Final ERC20 balance of Dave Safe: " + await contractERC20.balanceOf(addressDaveSafe));
    
    });
});





{ 
  // console.log("\n 2) Initializing Safe contract (setting up an owner of the safe)\n");

  // let txnhash = await contractOwnerSafe.getTransactionHash(
  //   addressOwnerSafe,
  //   0,
  //   "0x0d582f130000000000000000000000005f4e77a22e394b51dc7efb8e3c78121e489e78cd0000000000000000000000000000000000000000000000000000000000000001",
  //   0,
  //   1000000,
  //   0,
  //   1000000,
  //   addressOwnerSafe,
  //   this.signers.alice.getAddress(),
  //   await contractOwnerSafe.nonce()
  // );

  // const txn = {
  //   to: addressOwnerSafe,
  //   value : 0,
  //   data : "0x0d582f130000000000000000000000005f4e77a22e394b51dc7efb8e3c78121e489e78cd0000000000000000000000000000000000000000000000000000000000000001",
  //   operation : 0,
  //   safeTxGas : 1000000,
  //   baseGas : 0,
  //   gasPrice : 1000000,
  //   gasToken : addressOwnerSafe,
  //   refundReceiver : this.signers.alice.getAddress(),
  //   nonce : await contractOwnerSafe.nonce()
  // };

  // const tx = buildSafeTransaction(txn);
  // const signatureBytes = buildSignatureBytes([await safeApproveHash(this.signers.alice, contractOwnerSafe, tx, true)]);

  // console.log(await contractOwnerSafe.checkSignatures(txnhash,signatureBytes));

  // let fnSelector = "0x0d582f13"; // addOwnerWithThreshold(address,uint256)

  // try {
  //   // const txn = await contractOwnerSafe.setup([this.signers.alice.getAddress()], 0, this.signers.alice.getAddress(), "0x", this.signers.alice.getAddress(), this.signers.alice.getAddress(), 0, this.signers.alice.getAddress());
  //   // const txn = await contractOwnerSafe.addOwnerWithThreshold(this.signers.alice.getAddress(), 1);
  //   const txn = await contractOwnerSafe.execTransaction(
  //     addressOwnerSafe,
  //     0,
  //     fnSelector + AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [await this.signers.alice.getAddress(), 1]).slice(2),
  //     // "0x0d582f130000000000000000000000005f4e77a22e394b51dc7efb8e3c78121e489e78cd0000000000000000000000000000000000000000000000000000000000000001",
  //     0,
  //     1000000,
  //     0,
  //     1000000,
  //     addressOwnerSafe,
  //     this.signers.alice.getAddress(),
  //     "0x",
  //     { gasLimit: 10000000 },
  //   );
  //   console.log("Transaction hash:", txn.hash);
  //   await txn.wait(1);
  //   console.log("Owner safe initialization successful!");
  // } catch (error) {
  //   console.error("Owner safe initialization failed:", error);
  // }
  // try {
  //   // const txn = await contractOwnerSafe.setup([this.signers.alice.getAddress()], 0, this.signers.alice.getAddress(), "0x", this.signers.alice.getAddress(), this.signers.alice.getAddress(), 0, this.signers.alice.getAddress());
  //   // const txn = await contractOwnerSafe.addOwnerWithThreshold(this.signers.alice.getAddress(), 1);
  //   const txn = await contractBobSafe.execTransaction(
  //     addressBobSafe,
  //     0,
  //     fnSelector + AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [await this.signers.bob.getAddress(), 1]).slice(2),
  //     // "0x0d582f130000000000000000000000005f4e77a22e394b51dc7efb8e3c78121e489e78cd0000000000000000000000000000000000000000000000000000000000000001",
  //     0,
  //     1000000,
  //     0,
  //     1000000,
  //     addressBobSafe,
  //     this.signers.alice.getAddress(),
  //     "0x",
  //     { gasLimit: 10000000 },
  //   );
  //   console.log("Transaction hash:", txn.hash);
  //   await txn.wait(1);
  //   console.log("Bob safe initialization successful!");
  // } catch (error) {
  //   console.error("Bob safe initialization failed:", error);
  // }
  // try {
  //   // const txn = await contractOwnerSafe.setup([this.signers.alice.getAddress()], 0, this.signers.alice.getAddress(), "0x", this.signers.alice.getAddress(), this.signers.alice.getAddress(), 0, this.signers.alice.getAddress());
  //   // const txn = await contractOwnerSafe.addOwnerWithThreshold(this.signers.alice.getAddress(), 1);
  //   const txn = await contractCarolSafe.execTransaction(
  //     addressCarolSafe,
  //     0,
  //     fnSelector + AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [await this.signers.carol.getAddress(), 1]).slice(2),
  //     // "0x0d582f130000000000000000000000005f4e77a22e394b51dc7efb8e3c78121e489e78cd0000000000000000000000000000000000000000000000000000000000000001",
  //     0,
  //     1000000,
  //     0,
  //     1000000,
  //     addressCarolSafe,
  //     this.signers.alice.getAddress(),
  //     "0x",
  //     { gasLimit: 10000000 },
  //   );
  //   console.log("Transaction hash:", txn.hash);
  //   await txn.wait(1);
  //   console.log("Carol safe initialization successful!");
  // } catch (error) {
  //   console.error("Carol safe initialization failed:", error);
  // }
  // try {
  //   // const txn = await contractOwnerSafe.setup([this.signers.alice.getAddress()], 0, this.signers.alice.getAddress(), "0x", this.signers.alice.getAddress(), this.signers.alice.getAddress(), 0, this.signers.alice.getAddress());
  //   // const txn = await contractOwnerSafe.addOwnerWithThreshold(this.signers.alice.getAddress(), 1);
  //   const txn = await contractDaveSafe.execTransaction(
  //     addressDaveSafe,
  //     0,
  //     fnSelector + AbiCoder.defaultAbiCoder().encode(["address", "uint256"], [await this.signers.dave.getAddress(), 1]).slice(2),
  //     // "0x0d582f130000000000000000000000005f4e77a22e394b51dc7efb8e3c78121e489e78cd0000000000000000000000000000000000000000000000000000000000000001",
  //     0,
  //     1000000,
  //     0,
  //     1000000,
  //     addressDaveSafe,
  //     this.signers.alice.getAddress(),
  //     "0x",
  //     { gasLimit: 10000000 },
  //   );
  //   console.log("Transaction hash:", txn.hash);
  //   await txn.wait(1);
  //   console.log("Dave safe initialization successful!");
  // } catch (error) {
  //   console.error("Dave safe initialization failed:", error);
  // }
  }