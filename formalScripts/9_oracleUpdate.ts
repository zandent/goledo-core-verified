/* eslint-disable node/no-missing-import */
import * as dotenv from "dotenv";
dotenv.config();
const fetch = require('node-fetch');
declare type RequestInit = any
import { exec } from "child_process";
import { BigNumber, constants } from "ethers";
import { ethers, network } from "hardhat";
import {
  AaveOracle,
  AaveProtocolDataProvider,
  ChefIncentivesController,
  ChefIncentivesControllerV2,
  GoledoToken,
  LendingPool,
  LendingPoolAddressesProvider,
  LendingPoolAddressesProviderRegistry,
  LendingPoolCollateralManager,
  LendingPoolConfigurator,
  LendingRateOracle,
  MasterChef,
  MasterChefV2,
  MultiFeeDistribution,
  MultiFeeDistributionV2,
  WETHGateway,
} from "../typechain";
import * as fs from 'fs';
import assert from 'assert-ts';
const SwappiRouterJSON = require(`./SwappiRouter.sol/SwappiRouter.json`);
const SwappiFactoryJSON = require(`./SwappiFactory.sol/SwappiFactory.json`);
type User = {
  status: string;
  message: string;
  result: [
      {
        "blockNumber": string,
        "timeStamp": string,
        "hash": string,
        "nonce": string,
        "blockHash": string,
        "transactionIndex": string,
        "from": string,
        "to": string,
        "value": string,
        "gas": string,
        "gasPrice": string,
        "isError": string,
        "txreceipt_status": string,
        "input": string,
        "contractAddress": string,
        "cumulativeGasUsed": string,
        "gasUsed": string,
        "confirmations": string
      }
    ]
}
const ADDRESSES: {
  [network: string]: {
    Admin: string;
    EmergencyAdmin: string;
    Treasury: string;
    WitnetRouter: string;
    WCFX: string;
    SwappiRouter: string;
    SwappiFactory: string;
    GenericLogic: string;
    ValidationLogic: string;
    ReserveLogic: string;
    WalletBalanceProvider: string;
    WETHGateway: string;
    GoledoToken: string;
    LendingPoolAddressesProviderRegistry: string;
    LendingPoolAddressesProvider: string;
    LendingPoolCollateralManager: string;
    LendingPoolConfiguratorImpl: string;
    LendingPoolConfigurator: string;
    LendingPoolImpl: string;
    LendingPool: string;
    AaveOracle: string;
    LendingRateOracle: string;
    AaveProtocolDataProvider: string;
    MultiFeeDistribution: string;
    ChefIncentivesController: string;
    MasterChef: string;
    UiPoolDataProvider: string;
    IncentiveDataProvider: string;
    ATokenImpl: string;
    StableDebtTokenImpl: string;
    VariableDebtTokenImpl: string;
    SwappiLP: string;
    Markets: {
      [name: string]: {
        token: string;
        decimals: number;
        atoken: string;
        vtoken: string;
        stoken: string;
        oracle: string;
        DefaultReserveInterestRateStrategy: string;
        witnetConfig: {
          assetId: string;
          decimals: number;
          timeout: number;
        };
      };
    };
  };
} = {
  testnet: {
    Admin: "0xad085e56f5673fd994453bbcdfe6828aa659cb0d",
    EmergencyAdmin: "0xad085e56f5673fd994453bbcdfe6828aa659cb0d",
    Treasury: "",
    WitnetRouter: "0x49c0bcce51a8b28f92d008394f06d5b259657f33",
    WCFX: "0x2ed3dddae5b2f321af0806181fbfa6d049be47d8",
    SwappiRouter: "0x873789aaf553fd0b4252d0d2b72c6331c47aff2e",
    SwappiFactory: "0x36b83e0d41d1dd9c73a006f0c1cbc1f096e69e34",
    GenericLogic: "",
    ValidationLogic: "",
    ReserveLogic: "",
    WalletBalanceProvider: "",
    WETHGateway: "",
    GoledoToken: "",
    LendingPoolAddressesProviderRegistry: "",
    LendingPoolAddressesProvider: "",
    LendingPoolCollateralManager: "",
    LendingPoolImpl: "",
    LendingPool: "",
    LendingPoolConfiguratorImpl: "",
    LendingPoolConfigurator: "",
    AaveOracle: "",
    LendingRateOracle: "",
    AaveProtocolDataProvider: "",
    MultiFeeDistribution: "",
    ChefIncentivesController: "",
    MasterChef: "",
    UiPoolDataProvider: "",
    IncentiveDataProvider: "",
    ATokenImpl: "",
    StableDebtTokenImpl: "",
    VariableDebtTokenImpl: "",
    SwappiLP: "",
    Markets: {
      CFX: {
        token: "0x2ed3dddae5b2f321af0806181fbfa6d049be47d8",
        decimals: 18,
        atoken: "",
        stoken: "",
        vtoken: "",
        oracle: "",
        DefaultReserveInterestRateStrategy: "",
        witnetConfig: {
          assetId: "0x65784185a07d3add5e7a99a6ddd4477e3c8caad717bac3ba3c3361d99a978c29",
          decimals: 6,
          timeout: 60 * 60 * 2,
        },
      },
      WETH: {
        token: "0xcd71270f82f319e0498ff98af8269c3f0d547c65",
        decimals: 18,
        atoken: "",
        stoken: "",
        vtoken: "",
        oracle: "",
        DefaultReserveInterestRateStrategy: "",
        witnetConfig: {
          assetId: "0x3d15f7018db5cc80838b684361aaa100bfadf8a11e02d5c1c92e9c6af47626c8",
          decimals: 6,
          timeout: 60 * 60 * 2,
        },
      },
      WBTC: {
        token: "0x54593e02c39aeff52b166bd036797d2b1478de8d",
        decimals: 18,
        atoken: "",
        stoken: "",
        vtoken: "",
        oracle: "",
        DefaultReserveInterestRateStrategy: "",
        witnetConfig: {
          assetId: "0x24beead43216e490aa240ef0d32e18c57beea168f06eabb94f5193868d500946",
          decimals: 6,
          timeout: 60 * 60 * 2,
        },
      },
      USDT: {
        token: "0x7d682e65efc5c13bf4e394b8f376c48e6bae0355",
        decimals: 18,
        atoken: "",
        stoken: "",
        vtoken: "",
        oracle: "",
        DefaultReserveInterestRateStrategy: "",
        witnetConfig: {
          assetId: "0x538f5a25b39995a23c24037d2d38f979c8fa7b00d001e897212d936e6f6556ef",
          decimals: 6,
          timeout: 60 * 60 * 48,
        },
      },
    },
  },
  espace: {
    Admin: "0x507f8a2a5572179ea52aa749471611bcffccf9de",
    EmergencyAdmin: "0x440db4b6e54f7626fBeA81145495b2224Fd38131",
    Treasury: "0x507f8a2a5572179ea52aa749471611bcffccf9de",
    WitnetRouter: "0xd39d4d972c7e166856c4eb29e54d3548b4597f53",
    WCFX: "",
    SwappiRouter: "",
    SwappiFactory: "",
    GenericLogic: "",
    ValidationLogic: "",
    ReserveLogic: "",
    WalletBalanceProvider: "",
    WETHGateway: "",
    GoledoToken: "",
    LendingPoolAddressesProviderRegistry: "",
    LendingPoolAddressesProvider: "",
    LendingPoolCollateralManager: "",
    LendingPoolConfiguratorImpl: "",
    LendingPoolConfigurator: "",
    LendingPoolImpl: "",
    LendingPool: "",
    AaveOracle: "",
    LendingRateOracle: "",
    AaveProtocolDataProvider: "",
    MultiFeeDistribution: "",
    ChefIncentivesController: "",
    MasterChef: "",
    UiPoolDataProvider: "",
    IncentiveDataProvider: "",
    ATokenImpl: "",
    StableDebtTokenImpl: "",
    VariableDebtTokenImpl: "",
    SwappiLP: "",
    Markets: {},
  },
};
const RATE_STRATEGY: {
  [name: string]: {
    optimalUtilizationRate: string;
    baseVariableBorrowRate: string;
    variableRateSlope1: string;
    variableRateSlope2: string;
    stableRateSlope1: string;
    stableRateSlope2: string;
  };
} = {
  CFX: {
    optimalUtilizationRate: "450000000000000050000000000", // optimalUtilizationRate
    baseVariableBorrowRate: "0", // baseVariableBorrowRate
    variableRateSlope1: "70000000000000010000000000", // variableRateSlope1
    variableRateSlope2: "3000000000000000000000000000", // variableRateSlope2
    stableRateSlope1: "0", // stableRateSlope1
    stableRateSlope2: "0", // stableRateSlope2
  },
  WETH: {
    optimalUtilizationRate: "650000000000000000000000000", // optimalUtilizationRate
    baseVariableBorrowRate: "0", // baseVariableBorrowRate
    variableRateSlope1: "80000000000000000000000000", // variableRateSlope1
    variableRateSlope2: "1000000000000000000000000000", // variableRateSlope2
    stableRateSlope1: "0", // stableRateSlope1
    stableRateSlope2: "0", // stableRateSlope2
  },
  WBTC: {
    optimalUtilizationRate: "650000000000000000000000000", // optimalUtilizationRate
    baseVariableBorrowRate: "0", // baseVariableBorrowRate
    variableRateSlope1: "80000000000000000000000000", // variableRateSlope1
    variableRateSlope2: "3000000000000000000000000000", // variableRateSlope2
    stableRateSlope1: "0", // stableRateSlope1
    stableRateSlope2: "0", // stableRateSlope2
  },
  USDT: {
    optimalUtilizationRate: "900000000000000100000000000", // optimalUtilizationRate
    baseVariableBorrowRate: "0", // baseVariableBorrowRate
    variableRateSlope1: "40000000000000000000000000", // variableRateSlope1
    variableRateSlope2: "600000000000000000000000000", // variableRateSlope2
    stableRateSlope1: "0", // stableRateSlope1
    stableRateSlope2: "0", // stableRateSlope2
  },
};
const MAX_SUPPLY = ethers.utils.parseEther("100000000");
const GOLEDOVESTINGLOCKTIMESTAMP = 1672023600;

let goledoToken: GoledoToken;
let lendingPoolAddressesProviderRegistry: LendingPoolAddressesProviderRegistry;
let lendingPoolAddressesProvider: LendingPoolAddressesProvider;
let lendingPoolCollateralManager: LendingPoolCollateralManager;
let lendingPoolConfigurator: LendingPoolConfigurator;
let lendingPool: LendingPool;
let aaveOracle: AaveOracle;
let lendingRateOracle: LendingRateOracle;
let aaveProtocolDataProvider: AaveProtocolDataProvider;
let multiFeeDistribution: MultiFeeDistribution;
let chefIncentivesController: ChefIncentivesController;
let multiFeeDistributionV2: MultiFeeDistributionV2;
let chefIncentivesControllerV2: ChefIncentivesControllerV2;
let masterChef: MasterChef;
let masterChefV2: MasterChefV2;
let wethGateway: WETHGateway;

async function main() {
  const [deployer] = await ethers.getSigners();
  const rawdata = fs.readFileSync("formalScripts/" + network.name + "Address.json");
  const addresses = JSON.parse(rawdata.toString());
  const pythAbi = require(`@pythnetwork/pyth-sdk-solidity/abis/IPyth.json`);
  const pyth = new ethers.Contract("0xe9d69CdD6Fe41e7B621B4A688C5D1a68cB5c8ADc", pythAbi, deployer);
  // let price = await pyth.getValidTimePeriod();
  // console.log(price);
  let price = await pyth.getPriceUnsafe("0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace");
  console.log(price);
  const PythPriceFeed = await ethers.getContractFactory("PythPriceFeed", deployer);
  const oracle = await PythPriceFeed.deploy(
    "0xe9d69CdD6Fe41e7B621B4A688C5D1a68cB5c8ADc",
    "0x8879170230c9603342f3837cf9a8e76c61791198fb1271bb2552c9af7b33c933",
    8,
    43200
  );
  await oracle.deployed();
  console.log(`Deploy Oracle for at:`, oracle.address);
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
