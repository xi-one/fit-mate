import "dotenv/config";
import "@typechain/hardhat";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-waffle";

import "hardhat-deploy";

import { HardhatUserConfig } from "hardhat/types";

const config: HardhatUserConfig = {
  solidity: "0.8.4",
  namedAccounts: {
    admin: 0,
    depositor: 1,
  },
  networks: {
    hardhat: {},
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY || ""],
      chainId: 1,
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY || ""],
      chainId: 3,
    },
    sepolia: {
      url: process.env.SEPOLIA_URL || "",
      accounts: [process.env.PRIVATE_KEY || ""],
    },
    cronos_mainnet: {
      chainId: 25,
      url: "https://evm.cronos.org/",
      accounts: [process.env.PRIVATE_KEY || ""],
      //gasPrice: 5000000000000,
    },
    cronos_testnet: {
      chainId: 338,
      url: "https://evm-t3.cronos.org/",
      accounts: [process.env.PRIVATE_KEY || ""],
      //gasPrice: 5000000000000,
    },
    bnb_testnet: {
      url: process.env.BNB_TESTNET_URL || "",
      accounts: [process.env.PRIVATE_KEY || ""],
    },
    baobab_testnet: {
      url: process.env.BAOBAB_TESTNET_URL || "",
      accounts: [process.env.PRIVATE_KEY || ""],
    },
    service_chain: {
      url: process.env.SERVICE_CHAIN_URL || "",
      accounts: [process.env.PRIVATE_KEY || ""],
    },
    mumbai_testnet: {
      url: process.env.MUMBAI_TESTNET_URL || "",
      accounts: [process.env.PRIVATE_KEY || ""],
    },

    
  },
};

export default config;