const { ethers, run, network } = require("hardhat");

async function main() {
  const [deployer, validator] = await ethers.getSigners();
  // UserManagement
  console.log(
    "Deploying UserManagement contract with address ",
    deployer.address
  );
  const UserManagement = await ethers.getContractFactory("UserManagement");
  const userManagement = await UserManagement.deploy();
  // creating user
  await userManagement.createUser(1);
  // creating a validator
  await userManagement.addValidator(validator.address);
  console.log("UserManagment address deployed ", userManagement.target);

  // UserManagement
  console.log("Deploying ProductRegistrationContract contract");
  const ProductRegistrationContract = await ethers.getContractFactory(
    "ProductRegistrationContract"
  );
  const productRegistrationContract = await ProductRegistrationContract.deploy(
    userManagement.target
  );

  console.log(
    "ProductRegistrationContract address deployed ",
    productRegistrationContract.target
  );

  // UserManagement
  console.log("Deploying ProductValidationContract contract");
  const ProductValidationContract = await ethers.getContractFactory(
    "ProductValidationContract"
  );
  const productValidationContract = await ProductValidationContract.deploy(
    productRegistrationContract.target
  );

  console.log(
    "ProductRegistrationContract address deployed ",
    productValidationContract.target
  );

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
