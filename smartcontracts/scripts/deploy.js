const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

async function main() {
  const whitelistContarct = WHITELIST_CONTRACT_ADDRESS;
  const metadataUrl = METADATA_URL;
  const CryptoDreamersContract = await ethers.getContractFactory(
    "CryptoDreamers"
  );
  const deployedCryptoDreamersContract = await CryptoDreamersContract.deploy(
    whitelistContarct,
    metadataUrl
  );
  console.log(
    "CryptoDreamers contract deployed to:",
    deployedCryptoDreamersContract.address
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
