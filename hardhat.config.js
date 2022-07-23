require('dotenv').config()
const { PRIVATE_KEY, COINMARKETCAP_KEY, ALCHEMY_API_KEY } = process.env || null;
require("@nomiclabs/hardhat-waffle");
require('hardhat-contract-sizer');
require("solidity-docgen");
require("hardhat-gas-reporter");

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
      accounts: [PRIVATE_KEY],
      gasMultiplier: 2,
    },

    maticMain: {
      url: "https://polygon-rpc.com",
      accounts: [PRIVATE_KEY],
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
  }
};
