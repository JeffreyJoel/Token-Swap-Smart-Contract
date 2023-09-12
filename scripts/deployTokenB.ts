import { ethers } from 'hardhat';

async function main() {
  try {
    const [deployer] = await ethers.getSigners();

    // Deploy TokenB
    const TokenB = await ethers.getContractFactory('TokenB');
    const tokenB = await TokenB.deploy();
    await tokenB.waitForDeployment();
    console.log(`TokenB deployed at: ${tokenB.target}`);
  } catch (error) {
    console.error(error);
    process.exitCode = 1;
  }
}

main();