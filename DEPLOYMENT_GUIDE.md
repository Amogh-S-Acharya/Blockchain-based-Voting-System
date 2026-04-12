# 📋 Contract Deployment Guide

## Where to Get the Contract Address

You need to **deploy the Voting contract** to Sepolia testnet first. Once deployed, you'll get a contract address.

## 🚀 Deployment Methods

### **Method 1: Using Remix IDE (Recommended - Easiest)**

1. **Go to Remix IDE**: https://remix.ethereum.org

2. **Create a new file**:
   - Click "File Explorer" (left sidebar)
   - Click the "+" icon
   - Name it `voting.sol`
   - Copy the contents from `contracts/voting.sol` and paste it

3. **Compile the contract**:
   - Click "Solidity Compiler" tab (icon looks like Solidity logo)
   - Select compiler version: `0.8.9` or higher
   - Click "Compile voting.sol"
   - You should see a green checkmark if compilation succeeds

4. **Deploy the contract**:
   - Click "Deploy & Run Transactions" tab (bottom icon)
   - Environment: Select "Injected Provider - MetaMask"
   - Make sure MetaMask is connected and switched to **Sepolia Testnet**
   - Click "Deploy" button
   - Confirm the transaction in MetaMask
   - Wait for transaction confirmation

5. **Get the Contract Address**:
   - After deployment, you'll see the contract in "Deployed Contracts" section
   - Click the contract name to expand it
   - **Copy the contract address** (starts with `0x...`)
   - This is your contract address!

6. **Update dashboard.html**:
   - Open `html/dashboard.html`
   - Find line 30: `const CONTRACT_ADDRESS = "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199";`
   - Replace with: `const CONTRACT_ADDRESS = "YOUR_NEW_CONTRACT_ADDRESS";`

### **Method 2: Using Command Line (Advanced)**

1. **Install dependencies** (if not already installed):
   ```bash
   npm install
   ```

2. **Compile the contract** (you'll need Hardhat or similar):
   ```bash
   npm install --save-dev hardhat
   npx hardhat compile
   ```

3. **Deploy using the script**:
   ```bash
   # Windows PowerShell
   $env:PRIVATE_KEY="your_private_key_here"; node deploy.js
   
   # Windows CMD
   set PRIVATE_KEY=your_private_key_here && node deploy.js
   
   # Linux/Mac
   PRIVATE_KEY=your_private_key_here node deploy.js
   ```

4. **Copy the contract address** from the output and update `dashboard.html`

## ⚠️ Important Notes

1. **Sepolia ETH Required**: You need Sepolia testnet ETH to pay for gas fees
   - Get free Sepolia ETH from: https://sepoliafaucet.com/
   - Or: https://faucet.quicknode.com/ethereum/sepolia

2. **Private Key Security**: 
   - Never share your private key
   - Use a separate test account, not your main wallet
   - Never commit private keys to git

3. **Network**: Make sure you're deploying to **Sepolia Testnet**, not Mainnet

4. **Contract Verification**: After deployment, verify your contract on Etherscan
   - Go to: https://sepolia.etherscan.io/address/YOUR_CONTRACT_ADDRESS
   - Click "Contract" tab
   - Click "Verify and Publish"

## 🔍 Verify Contract Deployment

After deployment, verify it's working:

1. **Check on Etherscan**:
   - Visit: `https://sepolia.etherscan.io/address/YOUR_CONTRACT_ADDRESS`
   - You should see contract code and transactions

2. **Test in Dashboard**:
   - Update `CONTRACT_ADDRESS` in `html/dashboard.html`
   - Connect your wallet
   - Try to vote - it should now work!

## 📍 Where Contract Address Appears

- **After Remix deployment**: In the "Deployed Contracts" section, click the contract name
- **After command line deployment**: Printed in the console output
- **On Etherscan**: In the URL after deployment transaction
- **In your code**: Update `CONTRACT_ADDRESS` in `html/dashboard.html` line 30

## 🆘 Troubleshooting

**"No contract found at address"**:
- Make sure you deployed to Sepolia testnet
- Double-check the contract address
- Verify the address on Etherscan

**"Contract does not match ABI"**:
- Make sure you're using the same contract code
- Re-deploy if you modified the contract
- Verify the ABI matches your deployed contract

**"Insufficient balance"**:
- Get Sepolia ETH from a faucet
- Make sure your wallet is on Sepolia network

## ✅ Next Steps

1. Deploy the contract using Remix (easiest method)
2. Copy the contract address
3. Update `CONTRACT_ADDRESS` in `html/dashboard.html`
4. Test voting in your dashboard

Good luck! 🚀

