require("@nomiclabs/hardhat-waffle");
require("hardhat-abi-exporter");
require("dotenv").config();

module.exports = {
  solidity: "0.8.10",
  networks: {
    popcateum: {
      url: "https://dataseed.popcateum.org",
      accounts: [process.env.TestPK || ""],
    },
    klaytn: {
      url: "https://klaytn01.fandom.finance",
      accounts: [process.env.PK || ""],
    },
    baobab: {
      url: "https://public-node-api.klaytnapi.com/v1/baobab",
      accounts: [process.env.TestPK || ""],
    },
  },
  abiExporter: {
    path: "./abi",
    runOnCompile: true,
    clear: true,
    flat: true,
    spacing: 2,
  },
};
