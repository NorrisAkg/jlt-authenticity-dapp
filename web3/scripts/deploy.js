const { ethers, run, network } = require("hardhat");

async function main() {
  const [deployer, validator, otherAccount, manufacturer] =
    await ethers.getSigners();

  console.log("Deploying ProductRegistrationContract contract");
  const ProductRegistrationContract = await ethers.getContractFactory(
    "ProductRegistrationContract"
  );
  const productRegistrationContract = await ProductRegistrationContract.connect(
    deployer
  ).deploy();

  console.log("Deploying OwnershipTransferContract contract");
  const OwnershipTransferContract = await ethers.getContractFactory(
    "OwnershipTransferContract"
  );
  const ownershipTransferContractContract =
    await OwnershipTransferContract.deploy(productRegistrationContract.target);

  console.log("Deploying ProductValidationContract contract");
  const ProductValidationContract = await ethers.getContractFactory(
    "ProductValidationContract"
  );
  const productValidationContractContract =
    await ProductValidationContract.deploy(productRegistrationContract.target);

  console.log("Deploying CounterfeitReportContract contract");
  const CounterfeitReportContract = await ethers.getContractFactory(
    "CounterfeitReportContract"
  );
  const counterfeitReportContract = await CounterfeitReportContract.deploy(
    productRegistrationContract.target
  );

  await productRegistrationContract
    .connect(deployer)
    .addManufacturer(manufacturer.address);
  await productRegistrationContract
    .connect(deployer)
    .addValidator(validator.address);
    // 
  await productRegistrationContract
    .connect(manufacturer)
    .addProduct("SN5", "dfjd", "des", "jpg", 78545888);

  //   const product = await productRegistrationContract.showProductInfos("SN05")

  // console.log("Product info ",product)
  // if (network.chainId == 11155111) {
  //     console.log("Wating for verifiv=cation")

  //     await crowdFunding.deploymentTransaction().wait(8)
  //     await verify(crowdFunding.address, [])
  // }
}

const verify = async (contractAddress, args) => {
  console.log("Verifying contract...");
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    });
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already Verified!");
    } else {
      console.log(e);
    }
  }
};
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
