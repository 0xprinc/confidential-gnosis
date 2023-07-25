import { FhevmInstance, createInstance } from "fhevmjs";
import { ethers } from "hardhat";

let instance: FhevmInstance;

export const getInstance = async (contractAddress: string) => {
  if (instance) return instance;

  // 1. Get chain id
  const provider = ethers.provider;
  const network = await provider.getNetwork();
  const chainId = +network.chainId.toString(); // Need to be a number

  // Get blockchain public key
  const publicKey = await provider.call({ to: "0x0000000000000000000000000000000000000044" });

  // Create instance
  instance = await createInstance({ chainId, publicKey });

  await generateToken(contractAddress);

  return instance;
};

const generateToken = async (contractAddress: string) => {
  // Generate token to decrypt
  const generatedToken = instance.generateToken({
    verifyingContract: contractAddress,
  });

  // Sign the public key
  const [signer] = await ethers.getSigners();
  const signature = await signer.signTypedData(
    generatedToken.token.domain,
    { Reencrypt: generatedToken.token.types.Reencrypt }, // Need to remove EIP712Domain from types
    generatedToken.token.message,
  );
  instance.setTokenSignature(contractAddress, signature);
};
