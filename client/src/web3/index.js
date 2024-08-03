import { ethers } from "ethers";
import abi from "./abi/abiContract.json";

// Créez un fournisseur avec `window.ethereum`
const provider = new ethers.providers.Web3Provider(window.ethereum);

// const signer = provider.getSigner()
export const getContract = async () => {
  const signer = await provider.getSigner();
  const contract = new ethers.Contract(
    "0xcABA4B9660824F1D4afC888D7995A023391C9e2f",
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
      []
    );
  } catch (error) {
    console.log("Error calling contract", error);
  }
};

export const validateProduct = async (serialNumber) => {
  const contract = await getContract();
  const signer = await provider;
};
