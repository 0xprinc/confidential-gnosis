import hre, { deployments, ethers } from "hardhat";

import type { Safe, Token1, EncryptedERC20} from "../../types";
import { getSigners } from "../signers";

export async function deploySafe(): Promise<Safe> {
  const signers = await getSigners(ethers);
  const contractFactory = await ethers.getContractFactory("Safe");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();
  console.log("deploySafe -> " + await contract.getAddress());
  return contract;
}
export async function deployToken1(): Promise<Token1> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("Token1");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();
  console.log("deployToken1 -> " + await contract.getAddress());
  return contract;
}
export async function deployEncryptedERC20(token1Address : string): Promise<EncryptedERC20> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("EncryptedERC20");
  const contract = await contractFactory.connect(signers.alice).deploy(token1Address);
  await contract.waitForDeployment();
  console.log("deployEncryptedERC20 -> " + await contract.getAddress());
  return contract;
}