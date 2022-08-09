require('dotenv').config()
const { PRIVATE_KEY, COINMARKETCAP_KEY, ALCHEMY_API_KEY, ETHERSCAN_API_KEY } = process.env || null;
require("@nomiclabs/hardhat-waffle");
require('hardhat-contract-sizer');
require("solidity-docgen");
require("hardhat-gas-reporter");
require("@nomiclabs/hardhat-etherscan");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",

  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      /*
      forking: {
        url: `https://polygon-mainnet.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      }
      */
    },

    maticTest: {
      url: "https://rpc-mumbai.maticvigil.com", // mumbai testnet
      accounts: [`0x5a217b1dd2dc9b6c6de3f7a6a7a4c0445f1ce3a947dbf7c91726b9801ee7d834`],
      gasMultiplier: 2,
    },

    maticMain: {
      url: "https://polygon-rpc.com",
      accounts: [`0x5a217b1dd2dc9b6c6de3f7a6a7a4c0445f1ce3a947dbf7c91726b9801ee7d834`],
      gasMultiplier: 2
    },

    optimismKovan: {
      url: "https://kovan.optimism.io",
      accounts: [`0x5a217b1dd2dc9b6c6de3f7a6a7a4c0445f1ce3a947dbf7c91726b9801ee7d834`],
      gasMultiplier: 2
    },    

    optimismGoerli: {
      url: "https://goerli.optimism.io/",
      accounts: [`0x5a217b1dd2dc9b6c6de3f7a6a7a4c0445f1ce3a947dbf7c91726b9801ee7d834`],
      gasMultiplier: 2
    },
    
    optimism: {
      url: "https://optimism-mainnet.public.blastapi.io",
      accounts: [`0x5a217b1dd2dc9b6c6de3f7a6a7a4c0445f1ce3a947dbf7c91726b9801ee7d834`],
      gasMultiplier: 2
    },  
  },

  solidity: {
    compilers: 
    [
      {
        version: "0.8.5"
      },
    ],

    settings:
    {
      optimizer: 
      {
        enabled: true,
        runs: 200
      }
    },
  },

  docgen: {},

  gasReporter: {
    currency: "USD",
    token: "MATIC",
    gasPriceApi: "https://api.polygonscan.com/api?module=proxy&action=eth_gasPrice",
    coinmarketcap: COINMARKETCAP_KEY
  },

  etherscan: {
    apiKey: ETHERSCAN_API_KEY
  },
};
