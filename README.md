# EthKipu Hacker Challenge

## Overview

This project is designed to solve a smart contract challenge involving the `Grader5` contract, originally deployed by EthKipu on the Sepolia testnet. The goal is to exploit the logic of the `Grader5` contract to maximize your grade by interacting with it in a specific way.

This repository contains:

- `Grader5.challenge.sol`: A mock copy of the real `Grader5` contract for local testing and development. The actual contract to hack is deployed on Sepolia by EthKipu.
- `EthKipuHacker.sol`: The contract you will deploy and use to exploit the `Grader5` contract.

## Contracts

### Grader5.challenge.sol

A mock version of the challenge contract. It exposes two main functions:

- `retrieve()`: Accepts a small payment and, under certain conditions, sends Ether back to the caller. It tracks how many times each address has called it.
- `gradeMe(string calldata name)`: Awards a grade if the caller has met the required conditions (tracked by `counter`).

**Note:** This contract is provided for local testing only. The real contract is on Sepolia.

### EthKipuHacker.sol

A contract designed to exploit the logic of `Grader5` by:

- Repeatedly calling `retrieve()` using a reentrancy pattern to increment the counter efficiently.
- Allowing the owner to call `gradeMe()` once the requirements are met.

## Setup

1. **Clone the repository**

2. **Install dependencies**

   - If you want to test `Grader5.challenge.sol` locally, you need OpenZeppelin contracts. Install with:
     ```bash
     npm install @openzeppelin/contracts
     ```
   - Or use your preferred Solidity development environment (e.g., Hardhat, Foundry, Remix).

3. **Compile the contracts**
   - Using Hardhat:
     ```bash
     npx hardhat compile
     ```
   - Or with your chosen tool.

## Usage

### 1. Deploy the Contracts

- Deploy `Grader5.challenge.sol` (for local testing only).
- Deploy `EthKipuHacker.sol`, passing the address of the deployed (or Sepolia) `Grader5` contract to the constructor.

### 2. Fund the Hacker Contract

- Send at least 4 wei to the `EthKipuHacker` contract using the `deposit()` function or a direct transfer.

### 3. Execute the Hack

- As the contract owner, call the `hack()` function. This will:
  - Call `retrieve()` on `Grader5` with 4 wei.
  - Trigger the receive function and reentrancy logic to increment the counter efficiently.

### 4. Claim Your Grade

- Once the counter is high enough, call `doGradeMe(string calldata name)` with your name to receive your grade from `Grader5`.

## Notes

- Only the contract owner can execute the hack and claim the grade.
- The reentrancy lock prevents infinite recursion.
- The real challenge contract is on Sepolia; this repo's `Grader5.challenge.sol` is for local testing only.
- Make sure to use the correct contract addresses when interacting with Sepolia.

## License

MIT
