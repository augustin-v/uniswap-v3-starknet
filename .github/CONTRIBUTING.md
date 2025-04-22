# Contributing to Starknet Uniswap V3
Welcome to the Starknet Uniswap V3 project, and thank you for your interest in contributing!
This project serves as an educational and hands-on implementation of Uniswap V3 on Starknet using Cairo. Whether you're new to DeFi, Cairo, or both, your contributions are valued.

This guide outlines how to get started with development, run tests, and open a proper pull request (PR).

## 📂 Repository Structure
The main smart contracts and project files are located at the root level.
All contribution-related documentation (including this file) lives in the .github directory.

## 🛠 Environment Setup
To ensure consistency across development environments, please use the following tool versions:

starknet-foundry: v0.38.3
scarb: v2.11.1
asdf: (recommended for managing versions)
Step-by-step setup:

Install dependencies:

asdf install
Build the project:

scarb build
Confirm versions:

snforge --version
scarb --version
❗️If you're not using asdf, make sure your manually installed versions match the ones listed above.

## 🔃 Making a Pull Request (PR)
Fork the repository to your GitHub account

Clone your fork:

git clone https://github.com/your-username/starknet-uniswap-v3.git
Create a new branch:

git checkout -b feature/your-branch-name
Make your changes

Commit with a clear message:

git commit -m "Add: concise summary of the change"
Push your branch:

git push origin feature/your-branch-name
Open a PR against the main branch on the original repo

## ✅ Pre-PR Checklist
Before submitting a pull request:

 Format your code:
scarb fmt
 Run tests:
snforge test
 Ensure all tests pass and your changes do not introduce regressions
## 🚧 Opening a Draft PR
If you're still working on a solution or need help:

Open a draft PR
Include a description of the issue you're facing or feedback you’re seeking
Someone from the team or community will assist you
## 🤝 Code of Conduct
Please be respectful, constructive, and helpful in discussions and reviews. This is a learning environment as much as a development one.

Thank you for contributing to Starknet Uniswap V3.
Let’s make DeFi development on Starknet more accessible — one PR at a time.

---

### 👋 About This Repo

This project is a hands-on resource for learning DeFi and Cairo smart contracts on Starknet.