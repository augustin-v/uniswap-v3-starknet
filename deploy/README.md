# UniswapV3 StarkNet Deployment Guide

This guide outlines the process for deploying the UniswapV3 Cairo suite on StarkNet. The provided script automates the deployment of all necessary contracts, capturing their addresses for integration with frontend applications and testing frameworks.

## Prerequisites

Before deploying the contracts, ensure you have the following:

1. **StarkNet CLI** - Properly installed and configured
   ```bash
   # Check if StarkNet CLI is installed
   starknet --version
   ```

2. **StarkNet Account** - A configured account with sufficient funds for deployment
   ```bash
   # Check if you have a configured account
   starknet account list
   ```

3. **Network Configuration** - Choose between:
   - StarkNet Devnet (for local development)
   - StarkNet Testnet (for integration testing)
   - StarkNet Mainnet (for production deployment)

4. **Token Contracts** - Existing ERC-20 token contracts on your chosen network

## Environment Variables

The deployment script requires the following environment variables:

| Variable | Description | Format | Example |
|----------|-------------|--------|---------|
| `TOKEN0_ADDRESS` | Contract address of the first token | Hex string | 0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7 |
| `TOKEN1_ADDRESS` | Contract address of the second token | Hex string | 0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8 |
| `INITIAL_SQRT_PRICE_X96` | Initial square root price (X96) | Integer | 1771845812700903892492222464 |
| `INITIAL_TICK` | Initial tick | Integer | 0 |

## Running the Deployment Script

1. **Set the environment variables:**

   ```bash
   export TOKEN0_ADDRESS="0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7"
   export TOKEN1_ADDRESS="0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8"
   export INITIAL_SQRT_PRICE_X96="1771845812700903892492222464"
   export INITIAL_TICK="0"
   ```

2. **Make the script executable:**

   ```bash
   chmod +x deploy/deploy.sh
   ```

3. **Run the deployment script:**

   ```bash
   ./deploy/deploy.sh
   ```

## Deployment Process

The script deploys the following contracts in order:

1. **TickBitmap**: Manages the bitmap for efficient tick tracking
   - Address: BITMAP_ADDRESS

2. **Tick**: Handles tick crossings and liquidity tracking
   - Address: TICK_ADDRESS

3. **Position**: Manages concentrated liquidity positions
   - Address: POSITION_ADDRESS

4. **UniswapV3Pool**: Core pool contract implementing swap and mint functionality
   - Address: POOL_ADDRESS

5. **UniswapV3Manager**: Manages swap and mint callback functions
   - Address: MANAGER_ADDRESS

6. **UniswapV3Quoter**: Provides quote functionality for swaps
   - Address: QUOTER_ADDRESS

## Output and Integration

After successful deployment:

1. A summary table of all deployed contract addresses is displayed in the terminal.
2. Addresses are saved to `deploy/deployed_addresses.txt`.
3. This README is updated with the actual deployed addresses.

### Integration with Frontend

Update your frontend configuration with the deployed addresses:

```javascript
// Example frontend integration
const POOL_ADDRESS = "POOL_ADDRESS";
const MANAGER_ADDRESS = "MANAGER_ADDRESS";
const QUOTER_ADDRESS = "QUOTER_ADDRESS";
```

### Integration with Tests

Import the deployed addresses in your integration tests:

```typescript
// Example test integration
const poolAddress = "POOL_ADDRESS";
const managerAddress = "MANAGER_ADDRESS";
```

## Troubleshooting

- **Transaction Failure**: Ensure your account has sufficient funds for all deployments.
- **Contract Compilation Errors**: Make sure you're running from the project root directory.
- **Missing Environment Variables**: Check that all required variables are set correctly.

## Support

If you encounter any issues during deployment, please open an issue in our GitHub repository or contact the development team through our Telegram group.