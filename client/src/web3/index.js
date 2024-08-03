import { ethers } from "ethers";

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
