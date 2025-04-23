# Educational Uniswap V3 on StarkNet

A hands-on learning project to master DeFi protocols and Cairo smart contracts on StarkNet.

## Project Status
- **Contracts Status**: Alpha - ~80% Complete
- **Frontend Status**: 0% (Only initiated)
- **Documentation/Book Status**: Planned, inspired by [Jeiwan's awesome book](https://uniswapv3book.com/) (To begin after contracts completion)

## Educational Purpose

This project serves as a comprehensive educational resource for developers interested in:
- Understanding how concentrated liquidity AMMs work at a deep technical level
- Learning advanced Cairo smart contract development through a real-world DeFi protocol
- Exploring the mathematical foundations that power modern DEXs
- Building complex financial protocols on StarkNet's ZK-rollup architecture

Rather than just a port, this implementation walks through the development process step-by-step, with documentation explaining the "why" behind each component.

## Current Implementation Status

### Completed & Documented Components
- **Core Math Libraries** - Learn fixed-point math and square root price calculations
- **TickBitmap Contract** - Understand efficient data structures for tick tracking
- **Tick Contract** - Explore tick crossings and liquidity tracking
- **Position Contract** - Master concentrated liquidity position management
- **Core Pool Contract** - Swap and Mint functions implemented
- **Manager Contract** - Swap and Mint callback functions implemented

### Learning Opportunities for Contributors

We are actively looking to onboard contributors who are eager to learn Cairo smart contract development while helping grow the Starknet developer ecosystem. By contributing to this project, you'll not only enhance your own understanding of DeFi and Cairo, but also help create educational resources that will benefit the broader community.

## Getting Started



### Setup

When contributing, make sure to use your own fork and create a new branch on your fork before opening a pull request.

We are using `starknet-foundry 0.38.3`, and `scarb 2.11.1` 
setup using asdf(inside of the contracts folder):
```bash
asdf local scarb 2.11.1
asdf local starnet-foundry 0.38.3
```

In the `contracts` folder, run:
```bash
snforge test
```

If you are setup properly, everything should compile and tests should be passing.


### Additional
Join our our [Telegram group](https://t.me/+bPtBG-CEsLlhYzM1)! Don't hesitate to leave a message if you need anything. Also, if you are willing to contribute but don't find any issue that resonates with your skills, send us a message we will make sure to help you contribute!


*This educational implementation is not affiliated with or endorsed by Uniswap Labs.*


## Continuous Integration

This project uses GitHub Actions for continuous integration to ensure code quality and consistency. The CI pipeline performs the following checks on every pull request and push to the main branch:

### Installed Tools

- **Scarb 2.11.1**: The Cairo package manager used for building and managing dependencies
- **snforge 0.38.3**: Starknet Foundry's testing framework for Cairo

### Automated Checks

- **Code Formatting**: Ensures all code follows the project's formatting standards
- **Tests**: Runs the full test suite to verify functionality

### Local Development

To ensure your code will pass CI checks, set up your local environment with:

```bash
# Install Scarb 2.11.1
asdf install scarb 2.11.1
asdf global scarb 2.11.1

# Install snforge 0.38.3
asdf install starknet-foundry 0.38.3
asdf global starknet-foundry 0.38.3

# Run checks locally
cd contracts
scarb fmt --check  # Check formatting
scarb snforge test # Run tests
```
👉 See our [Contribution Guidelines](https://github.com/Haroldwonder/uniswap-v3-starknet/blob/main/.github/CONTRIBUTING.md) to get started.
