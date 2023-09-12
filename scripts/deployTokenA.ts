import { ethers } from 'hardhat';

async function main() {
  try {
    const [deployer] = await ethers.getSigners();

    // Deploy TokenA
    const TokenA = await ethers.getContractFactory('TokenA');
    const tokenA = await TokenA.deploy();
    await tokenA.waitForDeployment();
    console.log(`TokenA deployed at: ${tokenA.target}`);
  } catch (error) {
    console.error(error);
    process.exitCode = 1;
  }
}

main();