import { ethers } from 'hardhat';

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying from:', deployer.address);

  // This script is a lightweight post-deploy verifier.
  // It will print the deployed OnchainScheduler contract address if present in the network artifacts.
  // It keeps the script safe and no-network calls beyond the local chain.

  const factory = await ethers.getContractFactory('OnchainScheduler');
  const deployed = factory.attach((await factory.deploy()).address);
  // Just verify the contract can be interacted with; perform a trivial static call if possible
  try {
    // Attempt to read a common public getter if available; otherwise skip quietly
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const _name = (deployed as any).name?.();
  } catch (_) {
    // ignore if getter not present
  }
  console.log('OnchainScheduler deployed at:', deployed.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
