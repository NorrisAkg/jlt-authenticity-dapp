import { ethers } from "ethers";
import abi from "./abi/abiContract.json";

// const signer = provider.getSigner()
export const getContract = async () => {
  const signer = await provider.getSigner();
  const contract = new ethers.Contract(
    "0xdF54e5161Be95D30c98bDCA6F6D029D8337EBB42",
    abi,
    signer
  );
  return contract;
};

export const addProduct = async (form) => {
  try {
    const contract = await getContract();
    const signer = await provider.getSigner();
    console.log("signer ", signer);
    await contract.addProduct(
      form.serialNumber,
      form.name,
      form.description,
      form.picture,
      form.price,
      new Date().getTime(),
      signer,
      signer,
      1,
      [],
    );
  } catch (error) {
    console.log("Error calling contract", error);
    // throw new Error('contract call failure')
  }
};
