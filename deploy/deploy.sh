#!/bin/bash

# UniswapV3 Cairo Suite Deployment Script
# This script automates the deployment of all necessary contracts for the UniswapV3 Cairo suite

set -e  # Exit immediately if a command exits with a non-zero status

# Print with colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ASCII Art Banner
echo -e "${BLUE}"
echo "=============================================="
echo "  UniswapV3 StarkNet Deployment Automation"
echo "=============================================="
echo -e "${NC}"

# Check required environment variables
required_vars=("TOKEN0_ADDRESS" "TOKEN1_ADDRESS" "INITIAL_SQRT_PRICE_X96" "INITIAL_TICK")
missing_vars=0

for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo -e "${RED}Error: Required environment variable $var is not set${NC}"
    missing_vars=1
  fi
done

if [ $missing_vars -eq 1 ]; then
  echo -e "${RED}Deployment aborted. Please set all required environment variables.${NC}"
  exit 1
fi

# Display configuration
echo -e "${YELLOW}Deployment Configuration:${NC}"
echo "TOKEN0_ADDRESS: $TOKEN0_ADDRESS"
echo "TOKEN1_ADDRESS: $TOKEN1_ADDRESS"
echo "INITIAL_SQRT_PRICE_X96: $INITIAL_SQRT_PRICE_X96"
echo "INITIAL_TICK: $INITIAL_TICK"
echo ""

# Create output file for addresses
ADDRESSES_FILE="deploy/deployed_addresses.txt"
echo "# Deployed Contract Addresses - $(date)" > $ADDRESSES_FILE

# Helper function to deploy a contract
deploy_contract() {
  local contract_name=$1
  local contract_path=$2
  shift 2
  local constructor_args=("$@")
  
  echo -e "${YELLOW}Deploying $contract_name...${NC}"
  
  # Build args string if any arguments provided
  args_str=""
  if [ ${#constructor_args[@]} -gt 0 ]; then
    for arg in "${constructor_args[@]}"; do
      args_str="$args_str --inputs $arg"
    done
  fi
  
  # Execute deployment command
  echo "starknet deploy --contract $contract_path $args_str"
  
  # Execute the actual deployment command
  RESPONSE=$(starknet deploy --contract $contract_path $args_str)
  CONTRACT_ADDRESS=$(echo $RESPONSE | grep -oP '(?<=Contract address: )[a-zA-Z0-9]+')
  
  # If we couldn't extract the address, use a fallback method or exit
  if [ -z "$CONTRACT_ADDRESS" ]; then
    echo -e "${RED}Failed to extract contract address from deployment output${NC}"
    echo "$RESPONSE"
    exit 1
  fi
  
  echo -e "${GREEN}$contract_name deployed at: $CONTRACT_ADDRESS${NC}"
  echo "$contract_name: $CONTRACT_ADDRESS" >> $ADDRESSES_FILE
  
  # Return the contract address
  echo $CONTRACT_ADDRESS
}

# Ensure we're in the project root directory
if [ ! -d "contracts" ] || [ ! -d "src" ]; then
  echo -e "${RED}Error: Please run this script from the project root directory${NC}"
  exit 1
fi

echo -e "${YELLOW}Starting deployment process...${NC}"

# Deploy TickBitmap
BITMAP_ADDRESS=$(deploy_contract "TickBitmap" "contracts/src/libraries/tick_bitmap.cairo")

# Deploy Tick
TICK_ADDRESS=$(deploy_contract "Tick" "contracts/src/libraries/tick.cairo")

# Deploy Position
POSITION_ADDRESS=$(deploy_contract "Position" "contracts/src/libraries/position.cairo")

# Deploy UniswapV3Pool
POOL_ADDRESS=$(deploy_contract "UniswapV3Pool" "contracts/src/contract/pool.cairo" \
  "$TOKEN0_ADDRESS" "$TOKEN1_ADDRESS" "$INITIAL_SQRT_PRICE_X96" "$INITIAL_TICK" \
  "$TICK_ADDRESS" "$BITMAP_ADDRESS" "$POSITION_ADDRESS")

# Deploy UniswapV3Manager
MANAGER_ADDRESS=$(deploy_contract "UniswapV3Manager" "contracts/src/contract/manager.cairo" \
  "$POOL_ADDRESS" "$TOKEN0_ADDRESS" "$TOKEN1_ADDRESS")

# Deploy UniswapV3Quoter
QUOTER_ADDRESS=$(deploy_contract "UniswapV3Quoter" "contracts/src/contract/quoter.cairo")

# Print summary table
echo -e "\n${GREEN}Deployment Summary:${NC}"
echo "===========================================" 
echo "| Contract             | Address          |"
echo "-------------------------------------------"
echo "| TickBitmap           | $BITMAP_ADDRESS |"
echo "| Tick                 | $TICK_ADDRESS |"
echo "| Position             | $POSITION_ADDRESS |"
echo "| UniswapV3Pool        | $POOL_ADDRESS |"
echo "| UniswapV3Manager     | $MANAGER_ADDRESS |"
echo "| UniswapV3Quoter      | $QUOTER_ADDRESS |"
echo "===========================================" 

# Update README with addresses (Bonus)
README_FILE="deploy/README.md"
if [ -f "$README_FILE" ]; then
  # Create a temporary file for the new README content
  TMP_README=$(mktemp)
  
  # Read the README line by line
  while IFS= read -r line; do
    # Check if this is a line with a contract address placeholder
    if [[ $line == *"BITMAP_ADDRESS"* ]]; then
      echo "${line/BITMAP_ADDRESS/$BITMAP_ADDRESS}" >> "$TMP_README"
    elif [[ $line == *"TICK_ADDRESS"* ]]; then
      echo "${line/TICK_ADDRESS/$TICK_ADDRESS}" >> "$TMP_README"
    elif [[ $line == *"POSITION_ADDRESS"* ]]; then
      echo "${line/POSITION_ADDRESS/$POSITION_ADDRESS}" >> "$TMP_README"
    elif [[ $line == *"POOL_ADDRESS"* ]]; then
      echo "${line/POOL_ADDRESS/$POOL_ADDRESS}" >> "$TMP_README"
    elif [[ $line == *"MANAGER_ADDRESS"* ]]; then
      echo "${line/MANAGER_ADDRESS/$MANAGER_ADDRESS}" >> "$TMP_README"
    elif [[ $line == *"QUOTER_ADDRESS"* ]]; then
      echo "${line/QUOTER_ADDRESS/$QUOTER_ADDRESS}" >> "$TMP_README"
    else
      echo "$line" >> "$TMP_README"
    fi
  done < "$README_FILE"
  
  # Replace the original README with the updated one
  mv "$TMP_README" "$README_FILE"
  echo -e "${GREEN}Updated deployed addresses in $README_FILE${NC}"
fi

echo -e "\n${GREEN}Deployment completed successfully!${NC}"
echo -e "Deployment details saved to: $ADDRESSES_FILE"
echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Use these addresses in your frontend configuration"
echo "2. Import these addresses for integration tests"
echo "3. Interact with the deployed contracts through the StarkNet CLI or SDK"