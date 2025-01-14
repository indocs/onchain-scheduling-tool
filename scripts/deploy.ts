import { ethers } from 'hardhat';

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying as', deployer.address);

  const Scheduler = await ethers.getContractFactory('OnchainScheduler');
  const scheduler = await Scheduler.connect(deployer).deploy();
  await scheduler.deployed();
  console.log('OnchainScheduler deployed at', scheduler.address);
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
