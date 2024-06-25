import hre, { deployments, ethers } from "hardhat";

import type { Safe, ERC20, EncryptedERC20} from "../../types";
import { getSigners } from "../signers";

export async function deploySafe(): Promise<Safe> {
  const signers = await getSigners(ethers);
  const contractFactory = await ethers.getContractFactory("Safe");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();
  console.log("deploySafe -> " + await contract.getAddress());
  return contract;
}
export async function deployERC20(): Promise<ERC20> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("ERC20");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();
  console.log("deployERC20 -> " + await contract.getAddress());
  return contract;
}
export async function deployEncryptedERC20(ERC20Address : string): Promise<EncryptedERC20> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("EncryptedERC20");
  const contract = await contractFactory.connect(signers.alice).deploy(ERC20Address);
  await contract.waitForDeployment();
  console.log("deployEncryptedERC20 -> " + await contract.getAddress());
  return contract;
}