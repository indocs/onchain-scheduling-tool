# onchain-scheduling-tool

Practical on-chain scheduling with gas-aware, auditable execution for robust governance and deployments.

Outline
- What it is
- Architecture overview
- Local development workflow
- Testing strategies (including revert scenarios)
- Deployment flow
- Security considerations

## Usage

This project is designed to be developed and tested with Hardhat. The commands below assume you have a local Hardhat node or Hardhat Network available.

- Prerequisites
  - Install dependencies: npm install
  - Copy environment defaults (if provided): cp .env.example .env
  - Create or configure a local Hardhat network in hardhat.config.js if you haven’t already.

- Compile
  - npx hardhat compile

- Test
  - npx hardhat test
  - To run a specific test file: npx hardhat test test/MyScenario.test.js
  - To run tests with a specific network (e.g., localhost): npx hardhat test --network localhost

- Deploy
  - Start a local node (optional if you use in-process Hardhat network): npx hardhat node
  - Deploy locally via script:
    - npx hardhat run scripts/deploy.js --network localhost
  - If you have a named network (e.g., dev, mumbai, etc.), replace --network localhost with the appropriate name:
    - npx hardhat run scripts/deploy.js --network dev

- Verify (optional)
  - Verify on Etherscan via Hardhat plugin hooks (if you publish to a public testnet/mainnet):
    - npx hardhat verify --network <network> <CONTRACT_ADDRESS> "<constructor-args>"
  - Ensure API keys are configured in the environment (.env) for the plugin to work (e.g., ETHERSCAN_API_KEY)

- Script usage
  - Deployment script location: scripts/deploy.js
  - Typical flow:
    - Compile
    - Deploy contracts
    - Optional post-deploy steps (granting roles, setting initial parameters)
  - If your project includes hardhat-deploy or other deployment helpers, follow their conventions in the scripts directory.

## Deployment

- Deploy locally via Hardhat script
  - npx hardhat run scripts/deploy.js --network localhost
- Verify on Etherscan (optional) using Hardhat plugin hooks
  - Ensure API keys and network configuration are set
  - npx hardhat verify --network <network> <CONTRACT_ADDRESS> "<constructor-args>"

Note: The project targets gas-aware, auditable execution with deterministic timing signals. Local development can mimic mainnet-like conditions using Hardhat Network or a forked mainnet if needed.

## Hardhat-Specific Notes

- Uses env-driven RPC URLs (via dotenv)
- Gas-aware execution is surfaced through events and deterministic timestamps
- Minimal access control with owner-based permissions for critical operations

## Design Notes

- Security posture
  - Access control: Critical operations are restricted to an owner or