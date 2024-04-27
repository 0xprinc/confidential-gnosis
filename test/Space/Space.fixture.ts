import { ethers } from "hardhat";

import type { Space, VanillaAuthenticator, VanillaExecutionStrategy, VanillaProposalValidationStrategy, VanillaVotingStrategy } from "../../types";
import { getSigners } from "../signers";

export async function deploySpace(): Promise<Space> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("Space");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();
  console.log("deploySpace -> " + await contract.getAddress());
  return contract;
}
export async function deployAuthenticator(): Promise<VanillaAuthenticator> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("VanillaAuthenticator");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();
  console.log("deployAuthenticator -> " + await contract.getAddress());
  return contract;
}
export async function deployValidationStrategy(): Promise<VanillaProposalValidationStrategy> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("VanillaProposalValidationStrategy");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();
  console.log("deployValidationStrategy -> " + await contract.getAddress());
  return contract;
}
export async function deployVotingStrategy(): Promise<VanillaVotingStrategy> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("VanillaVotingStrategy");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();
  console.log("deployVotingStrategy -> " + await contract.getAddress());
  return contract;
}
export async function deployExecutionStrategy(): Promise<VanillaExecutionStrategy> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("VanillaExecutionStrategy");
  const contract = await contractFactory.connect(signers.alice).deploy(signers.alice.getAddress(), 1);
  await contract.waitForDeployment();
  console.log("deployExecutionStrategy -> " + await contract.getAddress());
  return contract;
}
// export async function deployEncryptedERC20Fixture(): Promise<EncryptedERC20> {
//   const signers = await getSigners(ethers);

//   const contractFactory = await ethers.getContractFactory("EncryptedERC20");
//   const contract = await contractFactory.connect(signers.alice).deploy();
//   await contract.waitForDeployment();

//   return contract;
// }