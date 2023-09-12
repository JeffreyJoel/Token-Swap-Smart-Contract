import { ethers } from "hardhat";

async function deployTokenSwap() {
  try {
    const tokenA = "0x58C82ce42e51a598C8eEE7a788aF363793F9DbFA";
    const tokenB = "0x85a31eC6BD94eF4c34Aaa50ef58C49Ad01dA4709";

    const [deployer] = await ethers.getSigners();

    const TokenSwapFactory = await ethers.getContractFactory("TokenSwap");
    const swap = await TokenSwapFactory.deploy(tokenA, tokenB);
    await swap.waitForDeployment();

    console.log(`TokenSwap contract is deployed at: ${swap.target}`);
  } catch (error) {
    console.error(error);
    process.exitCode = 1;
  }
}

deployTokenSwap();