# Contributing to Starknet Uniswap V3

Welcome, and thanks for your interest in contributing! 🚀  
This project is a hands-on resource for learning DeFi and Cairo smart contract development. Clear guidelines help us maintain a smooth and beginner-friendly contribution process.

---

## 📦 Environment Setup

Before contributing, make sure your development environment is ready:

### Required Tools

- **Starknet Foundry**: `v0.38.3`
- **Scarb**: `v2.11.1`
- **asdf** (for version management)

### Setup Instructions

If you're using `asdf`, simply run:

```bash
asdf install
```
This installs the correct versions defined in .tool-versions.

For manual installation, refer to:

Starknet Foundry

Scarb


### 🛠️ Making a Pull Request (PR)
1. Fork the repo

2. Clone your fork:
```bash
git clone https://github.com/YOUR_USERNAME/starknet-uniswap-v3.git
```
3. Create a new branch for your change:
```bash
git checkout -b feature/your-feature-name
```
4. Make your changes and commit them:
```bash
git add .
git commit -m "feat: short description of your change"
```
5. Push your branch:
```bash
git push origin feature/your-feature-name
```
6. Open a pull request to the ```main``` branch on GitHub.


## ✅ Pre-PR Checklist

Before submitting a PR, please make sure to:

✅ Run formatting:
```bash
scarb fmt
```

✅ Run tests:
```bash
snforge test
```

✅ Ensure your code is clean and understandable

✅ Confirm no unnecessary files or debug code are included'''


## 📝 Draft PRs

If you're stuck or unsure, open a draft PR with a comment describing what you're trying to do. This lets maintainers help you early on without needing a finished product.
-
Thanks again for contributing!
Your effort helps make this an awesome learning resource for everyone