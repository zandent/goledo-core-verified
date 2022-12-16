/* eslint-disable node/no-missing-import */
import { BigNumber, constants } from "ethers";
import { ethers, network } from "hardhat";
import {
  AaveOracle,
  AaveProtocolDataProvider,
  ChefIncentivesController,
  GoledoToken,
  LendingPool,
  LendingPoolAddressesProvider,
  LendingPoolAddressesProviderRegistry,
  LendingPoolCollateralManager,
  LendingPoolConfigurator,
  LendingRateOracle,
  MasterChef,
  MultiFeeDistribution,
  WETHGateway,
} from "../typechain";
import * as fs from 'fs';
import assert from 'assert-ts';
const SwappiRouterJSON = require(`./SwappiRouter.sol/SwappiRouter.json`);
const SwappiFactoryJSON = require(`./SwappiFactory.sol/SwappiFactory.json`);
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
const MAX_SUPPLY = ethers.utils.parseEther("1000000000");
const GOLEDOVESTINGLOCKTIMESTAMP = 1671336000;

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
let masterChef: MasterChef;
let wethGateway: WETHGateway;

async function main() {
  const [deployer] = await ethers.getSigners();
  const rawdata = fs.readFileSync("formalScripts/" + network.name + "Address.json");
  const addresses = JSON.parse(rawdata.toString());
  // const addresses = ADDRESSES[network.name];
  if (addresses.GenericLogic !== "") {
    const genericLogic = await ethers.getContractAt("contracts/protocol/lendingpool/LendingPool.sol:GenericLogic", addresses.GenericLogic, deployer);
    console.log("Found GenericLogic at:", genericLogic.address);
  } else {
    const GenericLogic = await ethers.getContractFactory("contracts/protocol/lendingpool/LendingPool.sol:GenericLogic", deployer);
    const genericLogic = await GenericLogic.deploy();
    await genericLogic.deployed();
    addresses.GenericLogic = genericLogic.address;
    console.log("Deploy GenericLogic at:", genericLogic.address);
  }

  if (addresses.ValidationLogic !== "") {
    const validationLogic = await ethers.getContractAt("contracts/protocol/lendingpool/LendingPool.sol:ValidationLogic", addresses.ValidationLogic, deployer);
    console.log("Found ValidationLogic at:", validationLogic.address);
  } else {
    const ValidationLogic = await ethers.getContractFactory("contracts/protocol/lendingpool/LendingPool.sol:ValidationLogic", {
      signer: deployer,
      libraries: {
        GenericLogic: addresses.GenericLogic,
      },
    });
    const validationLogic = await ValidationLogic.deploy();
    await validationLogic.deployed();
    addresses.ValidationLogic = validationLogic.address;
    console.log("Deploy ValidationLogic at:", validationLogic.address);
  }

  if (addresses.ReserveLogic !== "") {
    const reserveLogic = await ethers.getContractAt("contracts/protocol/lendingpool/LendingPool.sol:ReserveLogic", addresses.ReserveLogic, deployer);
    console.log("Found ReserveLogic at:", reserveLogic.address);
  } else {
    const ReserveLogic = await ethers.getContractFactory("contracts/protocol/lendingpool/LendingPool.sol:ReserveLogic", deployer);
    const reserveLogic = await ReserveLogic.deploy();
    await reserveLogic.deployed();
    addresses.ReserveLogic = reserveLogic.address;
    console.log("Deploy ReserveLogic at:", reserveLogic.address);
  }

  if (addresses.WalletBalanceProvider !== "") {
    const walletBalanceProvider = await ethers.getContractAt(
      "WalletBalanceProvider",
      addresses.WalletBalanceProvider,
      deployer
    );
    console.log("Found WalletBalanceProvider at:", walletBalanceProvider.address);
  } else {
    const WalletBalanceProvider = await ethers.getContractFactory("WalletBalanceProvider", deployer);
    const walletBalanceProvider = await WalletBalanceProvider.deploy();
    await walletBalanceProvider.deployed();
    addresses.WalletBalanceProvider = walletBalanceProvider.address;
    console.log("Deploy WalletBalanceProvider at:", walletBalanceProvider.address);
  }

  if (addresses.WETHGateway !== "") {
    wethGateway = await ethers.getContractAt("WETHGateway", addresses.WETHGateway, deployer);
    console.log("Found WETHGateway at:", wethGateway.address);
  } else {
    const WETHGateway = await ethers.getContractFactory("WETHGateway", deployer);
    wethGateway = await WETHGateway.deploy(addresses.WCFX);
    await wethGateway.deployed();
    addresses.WETHGateway = wethGateway.address;
    console.log("Deploy WETHGateway at:", wethGateway.address);
  }

  if (addresses.GoledoToken !== "") {
    goledoToken = await ethers.getContractAt("GoledoToken", addresses.GoledoToken, deployer);
    console.log("Found GoledoToken at:", goledoToken.address);
  } else {
    const GoledoToken = await ethers.getContractFactory("GoledoToken", deployer);
    goledoToken = await GoledoToken.deploy(MAX_SUPPLY);
    await goledoToken.deployed();
    addresses.GoledoToken = goledoToken.address;
    console.log("Deploy GoledoToken at:", goledoToken.address);
  }

  // @note create pair in swappi factory
  if (addresses.SwappiFactory !== "") {
    const SwappiFactory = new ethers.Contract(addresses.SwappiFactory, SwappiFactoryJSON.abi, deployer);
    console.log("Found SwappiFactory at:", SwappiFactory.address);
    if (addresses.SwappiLP === "") {
      const tx = await SwappiFactory.createPair(goledoToken.address, addresses.WCFX);
      console.log(">> createPair in SwappiFactory, hash:", tx.hash);
      await tx.wait();
      console.log(">> ✅ Done");
      addresses.SwappiLP = await SwappiFactory.getPair(goledoToken.address, addresses.WCFX);
      console.log("Deploy SwappiLP at:", addresses.SwappiLP);
    } else {
      console.log("Found SwappiLP at:", addresses.SwappiLP);
    }
  } else {
    assert(false);
  }
  assert(addresses.SwappiLP !== "");

  if (addresses.LendingPoolAddressesProviderRegistry !== "") {
    lendingPoolAddressesProviderRegistry = await ethers.getContractAt(
      "LendingPoolAddressesProviderRegistry",
      addresses.LendingPoolAddressesProviderRegistry,
      deployer
    );
    console.log("Found LendingPoolAddressesProviderRegistry at:", lendingPoolAddressesProviderRegistry.address);
  } else {
    const LendingPoolAddressesProviderRegistry = await ethers.getContractFactory(
      "LendingPoolAddressesProviderRegistry",
      deployer
    );
    lendingPoolAddressesProviderRegistry = await LendingPoolAddressesProviderRegistry.deploy();
    await lendingPoolAddressesProviderRegistry.deployed();
    addresses.LendingPoolAddressesProviderRegistry = lendingPoolAddressesProviderRegistry.address;
    console.log("Deploy LendingPoolAddressesProviderRegistry at:", lendingPoolAddressesProviderRegistry.address);
  }

  if (addresses.LendingPoolAddressesProvider !== "") {
    lendingPoolAddressesProvider = await ethers.getContractAt(
      "LendingPoolAddressesProvider",
      addresses.LendingPoolAddressesProvider,
      deployer
    );
    console.log("Found LendingPoolAddressesProvider at:", lendingPoolAddressesProvider.address);
  } else {
    const LendingPoolAddressesProvider = await ethers.getContractFactory("LendingPoolAddressesProvider", deployer);
    lendingPoolAddressesProvider = await LendingPoolAddressesProvider.deploy("Goledo");
    await lendingPoolAddressesProvider.deployed();
    addresses.LendingPoolAddressesProvider = lendingPoolAddressesProvider.address;
    console.log("Deploy LendingPoolAddressesProvider at:", lendingPoolAddressesProvider.address);
  }

  if (
    (
      await lendingPoolAddressesProviderRegistry.getAddressesProviderIdByAddress(lendingPoolAddressesProvider.address)
    ).eq(constants.Zero)
  ) {
    const tx = await lendingPoolAddressesProviderRegistry.registerAddressesProvider(
      lendingPoolAddressesProvider.address,
      1
    );
    console.log(">> RegisterAddressesProvider in LendingPoolAddressesProviderRegistry, hash:", tx.hash);
    await tx.wait();
    console.log(">> ✅ Done");
  } else {
    console.log(">> LendingPoolAddressesProvider already registered in LendingPoolAddressesProviderRegistry");
  }

  if ((await lendingPoolAddressesProvider.getPoolAdmin()).toLowerCase() !== addresses.Admin.toLowerCase()) {
    const tx = await lendingPoolAddressesProvider.setPoolAdmin(addresses.Admin);
    console.log(">> SetPoolAdmin in LendingPoolAddressesProvider, hash:", tx.hash);
    await tx.wait();
    console.log(">> ✅ Done");
  } else {
    console.log(">> PoolAdmin is already set in LendingPoolAddressesProvider");
  }

  if (
    (await lendingPoolAddressesProvider.getEmergencyAdmin()).toLowerCase() !== addresses.EmergencyAdmin.toLowerCase()
  ) {
    const tx = await lendingPoolAddressesProvider.setEmergencyAdmin(addresses.EmergencyAdmin);
    console.log(">> SetEmergencyAdmin in LendingPoolAddressesProvider, hash:", tx.hash);
    await tx.wait();
    console.log(">> ✅ Done");
  } else {
    console.log(">> EmergencyAdmin is already set in LendingPoolAddressesProvider");
  }

  if (addresses.LendingPoolCollateralManager !== "") {
    lendingPoolCollateralManager = await ethers.getContractAt(
      "LendingPoolCollateralManager",
      addresses.LendingPoolCollateralManager,
      deployer
    );
    console.log("Found LendingPoolCollateralManager at:", lendingPoolCollateralManager.address);
  } else {
    const LendingPoolCollateralManager = await ethers.getContractFactory("LendingPoolCollateralManager", deployer);
    lendingPoolCollateralManager = await LendingPoolCollateralManager.deploy();
    await lendingPoolCollateralManager.deployed();
    addresses.LendingPoolCollateralManager = lendingPoolCollateralManager.address;
    console.log("Deploy LendingPoolCollateralManager at:", lendingPoolCollateralManager.address);
  }

  if ((await lendingPoolAddressesProvider.getLendingPoolCollateralManager()) !== lendingPoolCollateralManager.address) {
    const tx = await lendingPoolAddressesProvider.setLendingPoolCollateralManager(lendingPoolCollateralManager.address);
    console.log(">> SetLendingPoolCollateralManager in LendingPoolAddressesProvider, hash:", tx.hash);
    await tx.wait();
    console.log(">> ✅ Done");
  } else {
    console.log(">> LendingPoolCollateralManager is already set in LendingPoolAddressesProvider");
  }

  if (addresses.LendingPool !== "") {
    lendingPool = await ethers.getContractAt("LendingPool", addresses.LendingPool, deployer);
    console.log("Found LendingPool at:", lendingPool.address);
  } else {
    let impl: LendingPool;
    if (addresses.LendingPoolImpl === "") {
      const LendingPool = await ethers.getContractFactory("LendingPool", {
        signer: deployer,
        libraries: {
          ReserveLogic: addresses.ReserveLogic,
          ValidationLogic: addresses.ValidationLogic,
        },
      });
      impl = await LendingPool.deploy();
      await impl.deployed();
      addresses.LendingPoolImpl = impl.address;
      console.log("Deploy LendingPool Impl at:", impl.address);
    } else {
      impl = await ethers.getContractAt("LendingPool", addresses.LendingPoolImpl, deployer);
    }
    {
      const tx = await lendingPoolAddressesProvider.setLendingPoolImpl(impl.address);
      console.log(">> SetLendingPoolImpl in LendingPoolAddressesProvider, hash:", tx.hash);
      await tx.wait();
      console.log(">> ✅ Done");
    }
    const address = await lendingPoolAddressesProvider.getLendingPool();
    lendingPool = await ethers.getContractAt("LendingPool", address, deployer);
    console.log("Deploy LendingPool Proxy at:", lendingPool.address);
    addresses.LendingPool = lendingPool.address;
  }

  if (addresses.LendingPoolConfigurator !== "") {
    lendingPoolConfigurator = await ethers.getContractAt(
      "LendingPoolConfigurator",
      addresses.LendingPoolConfigurator,
      deployer
    );
    console.log("Found LendingPoolConfigurator at:", lendingPoolConfigurator.address);
  } else {
    let impl: LendingPoolConfigurator;
    if (addresses.LendingPoolConfiguratorImpl === "") {
      const LendingPoolConfigurator = await ethers.getContractFactory("LendingPoolConfigurator", deployer);
      impl = await LendingPoolConfigurator.deploy();
      await impl.deployed();
      addresses.LendingPoolConfiguratorImpl = impl.address;
      console.log("Deploy LendingPoolConfigurator Impl at:", impl.address);
    } else {
      impl = await ethers.getContractAt("LendingPoolConfigurator", addresses.LendingPoolConfiguratorImpl, deployer);
    }
    {
      const tx = await lendingPoolAddressesProvider.setLendingPoolConfiguratorImpl(impl.address);
      console.log(">> SetLendingPoolConfiguratorImpl in LendingPoolAddressesProvider, hash:", tx.hash);
      await tx.wait();
      console.log(">> ✅ Done");
    }
    const address = await lendingPoolAddressesProvider.getLendingPoolConfigurator();
    lendingPoolConfigurator = await ethers.getContractAt("LendingPoolConfigurator", address, deployer);
    console.log("Deploy LendingPoolConfigurator Proxy at:", lendingPoolConfigurator.address);
    addresses.LendingPoolConfigurator = lendingPoolConfigurator.address;
  }

  if (addresses.AaveOracle !== "") {
    aaveOracle = await ethers.getContractAt("AaveOracle", addresses.AaveOracle, deployer);
    console.log("Found AaveOracle at:", aaveOracle.address);
  } else {
    const AaveOracle = await ethers.getContractFactory("AaveOracle", deployer);
    aaveOracle = await AaveOracle.deploy([], []);
    await aaveOracle.deployed();
    addresses.AaveOracle = aaveOracle.address;
    console.log("Deploy AaveOracle at:", aaveOracle.address);
  }

  if ((await lendingPoolAddressesProvider.getPriceOracle()) !== aaveOracle.address) {
    const tx = await lendingPoolAddressesProvider.setPriceOracle(aaveOracle.address);
    console.log(">> SetPriceOracle in LendingPoolAddressesProvider, hash:", tx.hash);
    await tx.wait();
    console.log(">> ✅ Done");
  } else {
    console.log(">> PriceOracle is already set in LendingPoolAddressesProvider");
  }

  if (addresses.LendingRateOracle !== "") {
    lendingRateOracle = await ethers.getContractAt("LendingRateOracle", addresses.LendingRateOracle, deployer);
    console.log("Found LendingRateOracle at:", lendingRateOracle.address);
  } else {
    const LendingRateOracle = await ethers.getContractFactory("LendingRateOracle", deployer);
    lendingRateOracle = await LendingRateOracle.deploy();
    await lendingRateOracle.deployed();
    addresses.LendingRateOracle = lendingRateOracle.address;
    console.log("Deploy LendingRateOracle at:", lendingRateOracle.address);
  }

  if ((await lendingPoolAddressesProvider.getLendingRateOracle()) !== lendingRateOracle.address) {
    const tx = await lendingPoolAddressesProvider.setLendingRateOracle(lendingRateOracle.address);
    console.log(">> SetLendingRateOracle in LendingPoolAddressesProvider, hash:", tx.hash);
    await tx.wait();
    console.log(">> ✅ Done");
  } else {
    console.log(">> LendingRateOracle is already set in LendingPoolAddressesProvider");
  }

  if (addresses.AaveProtocolDataProvider !== "") {
    aaveProtocolDataProvider = await ethers.getContractAt(
      "AaveProtocolDataProvider",
      addresses.AaveProtocolDataProvider,
      deployer
    );
    console.log("Found AaveProtocolDataProvider at:", aaveProtocolDataProvider.address);
  } else {
    const AaveProtocolDataProvider = await ethers.getContractFactory("AaveProtocolDataProvider", deployer);
    aaveProtocolDataProvider = await AaveProtocolDataProvider.deploy(lendingPoolAddressesProvider.address);
    await aaveProtocolDataProvider.deployed();
    addresses.AaveProtocolDataProvider = aaveProtocolDataProvider.address;
    console.log("Deploy AaveProtocolDataProvider at:", aaveProtocolDataProvider.address);
  }

  // @note check if we need to set AaveProtocolDataProvider in LendingPoolAddressesProvider

  if (addresses.MultiFeeDistribution !== "") {
    multiFeeDistribution = await ethers.getContractAt("MultiFeeDistribution", addresses.MultiFeeDistribution, deployer);
    console.log("Found MultiFeeDistribution at:", multiFeeDistribution.address);
  } else {
    const MultiFeeDistribution = await ethers.getContractFactory("MultiFeeDistribution", deployer);
    multiFeeDistribution = await MultiFeeDistribution.deploy(goledoToken.address, GOLEDOVESTINGLOCKTIMESTAMP);
    await multiFeeDistribution.deployed();
    addresses.MultiFeeDistribution = multiFeeDistribution.address;
    console.log("Deploy MultiFeeDistribution at:", multiFeeDistribution.address);
  }
  if (addresses.Treasury === "") {
    addresses.Treasury = addresses.MultiFeeDistribution;
  }
  const ONEMONTH = 2628000; // 2628000; //TODO: change to 2628000 10800
  const TIMEOFFSETBASE = 0;
  const TOTALAMOUNTOFMONTHS = 4 * 12; // 5 years
  const startTimeOffset: number[] = new Array(TOTALAMOUNTOFMONTHS);
  const rewardsPerSecond: BigNumber[] = new Array(TOTALAMOUNTOFMONTHS);
  const rawRewardsPerSecond: number[] = new Array(
    505319149,
    463425485,
    425005030,
    389769837,
    357455830,
    327820827,
    300642725,
    275717833,
    252859348,
    231895954,
    212670537,
    195039010,
    178869232,
    164040015,
    150440219,
    137967919,
    126529640,
    116039655,
    106419346,
    97596612,
    89505330,
    82084859,
    75279585,
    69038504,
    63314842,
    58065703,
    53251745,
    48836890,
    44788050,
    41074881,
    37669553,
    34546546,
    31682452,
    29055807,
    26646925,
    24437752,
    22411732,
    20553679,
    18849669,
    17286930,
    15853751,
    14539390,
    13333997,
    12228537,
    11214726,
    10284965,
    9432287,
    9206710
    );
  const rewardsPerSecondForChefIncentivesController: BigNumber[] = new Array(TOTALAMOUNTOFMONTHS);
  const rewardsPerSecondForMasterChef: BigNumber[] = new Array(TOTALAMOUNTOFMONTHS);
  rewardsPerSecond[0] = BigNumber.from(rawRewardsPerSecond[0]).mul(ethers.utils.parseEther("1")).div(ONEMONTH);
  rewardsPerSecondForMasterChef[0] = rewardsPerSecond[0].div(2);
  rewardsPerSecondForChefIncentivesController[0] = rewardsPerSecond[0].sub(rewardsPerSecond[0].div(2));
  startTimeOffset[0] = TIMEOFFSETBASE;
  console.log(
    "set emission: ",
    startTimeOffset[0],
    rewardsPerSecondForMasterChef[0],
    rewardsPerSecondForChefIncentivesController[0]
  );
  for (let i = 1; i < startTimeOffset.length; i++) {
    startTimeOffset[i] = startTimeOffset[i - 1] + ONEMONTH;
    rewardsPerSecond[i] = BigNumber.from(rawRewardsPerSecond[i]).mul(ethers.utils.parseEther("1")).div(ONEMONTH);
    rewardsPerSecondForMasterChef[i] = rewardsPerSecond[i].div(2);
    rewardsPerSecondForChefIncentivesController[i] = rewardsPerSecond[i].sub(rewardsPerSecond[i].div(2));
    console.log(
      "set emission: ",
      startTimeOffset[i],
      rewardsPerSecondForMasterChef[i],
      rewardsPerSecondForChefIncentivesController[i]
    );
  }
  let totalAmount = BigNumber.from(0);
  for (let i = 0; i < startTimeOffset.length; i++) {
    totalAmount = totalAmount.add(rewardsPerSecondForMasterChef[i]).add(rewardsPerSecondForChefIncentivesController[i]);
  }
  totalAmount = totalAmount.mul(ONEMONTH);
  console.log("total amount: ", totalAmount);
  if (addresses.ChefIncentivesController !== "") {
    chefIncentivesController = await ethers.getContractAt(
      "ChefIncentivesController",
      addresses.ChefIncentivesController,
      deployer
    );
    console.log("Found ChefIncentivesController at:", chefIncentivesController.address);
  } else {
    const ChefIncentivesController = await ethers.getContractFactory("ChefIncentivesController", deployer);
    chefIncentivesController = await ChefIncentivesController.deploy(
      startTimeOffset,
      rewardsPerSecondForChefIncentivesController,
      lendingPoolConfigurator.address,
      multiFeeDistribution.address,
      MAX_SUPPLY.mul(3).div(10)
    );
    await chefIncentivesController.deployed();
    addresses.ChefIncentivesController = chefIncentivesController.address;
    console.log("Deploy ChefIncentivesController at:", chefIncentivesController.address);
    await chefIncentivesController.start();
  }

  if ((await multiFeeDistribution.incentivesController()) !== chefIncentivesController.address) {
    const tx = await multiFeeDistribution.setIncentivesController(chefIncentivesController.address);
    console.log(`>> SetIncentivesController in MultiFeeDistribution, hash:`, tx.hash);
    await tx.wait();
    console.log(">> ✅ Done");
  }

  if (addresses.MasterChef !== "") {
    masterChef = await ethers.getContractAt("MasterChef", addresses.MasterChef, deployer);
    console.log("Found MasterChef at:", masterChef.address);
    console.log(await masterChef.poolInfo(addresses.SwappiLP));
    console.log(await masterChef.totalAllocPoint());
    console.log(await masterChef.rewardsPerSecond());
  } else {
    const MasterChef = await ethers.getContractFactory("MasterChef", deployer);
    masterChef = await MasterChef.deploy(
      startTimeOffset,
      rewardsPerSecondForMasterChef,
      lendingPoolConfigurator.address,
      multiFeeDistribution.address,
      MAX_SUPPLY.mul(3).div(10)
    );
    await masterChef.deployed();
    addresses.MasterChef = masterChef.address;
    console.log("Deploy MasterChef at:", masterChef.address);
    await masterChef.start();
  }

  if (addresses.UiPoolDataProvider !== "") {
    const uiPoolDataProvider = await ethers.getContractAt("UiPoolDataProvider", addresses.UiPoolDataProvider, deployer);
    console.log("Found UiPoolDataProvider at:", uiPoolDataProvider.address);
    // console.log(await uiPoolDataProvider.getSimpleReservesData(addresses.LendingPoolAddressesProvider));
  } else {
    const UiPoolDataProvider = await ethers.getContractFactory("UiPoolDataProvider", deployer);
    const uiPoolDataProvider = await UiPoolDataProvider.deploy(constants.AddressZero, aaveOracle.address);
    await uiPoolDataProvider.deployed();
    addresses.UiPoolDataProvider = uiPoolDataProvider.address;
    console.log("Deploy UiPoolDataProvider at:", uiPoolDataProvider.address);
  }

  if (addresses.IncentiveDataProvider !== "") {
    const incentiveDataProvider = await ethers.getContractAt(
      "IncentiveDataProvider",
      addresses.IncentiveDataProvider,
      deployer
    );
    console.log("Found IncentiveDataProvider at:", incentiveDataProvider.address);
    // console.log(await incentiveDataProvider.getUserIncentive("0x121f7b3F158A2331a964Fc9cBa092fb64B464A41"));
  } else {
    const IncentiveDataProvider = await ethers.getContractFactory("IncentiveDataProvider", deployer);
    const incentiveDataProvider = await IncentiveDataProvider.deploy(
      addresses.ChefIncentivesController,
      addresses.MasterChef,
      addresses.MultiFeeDistribution
    );
    await incentiveDataProvider.deployed();
    addresses.IncentiveDataProvider = incentiveDataProvider.address;
    console.log("Deploy IncentiveDataProvider at:", incentiveDataProvider.address);
  }

  if (addresses.ATokenImpl !== "") {
    const impl = await ethers.getContractAt("AToken", addresses.ATokenImpl, deployer);
    console.log("Found AToken Impl at:", impl.address);
  } else {
    const AToken = await ethers.getContractFactory("AToken", deployer);
    const impl = await AToken.deploy();
    await impl.deployed();
    addresses.ATokenImpl = impl.address;
    console.log("Deploy AToken Impl at:", impl.address);
  }

  if (addresses.StableDebtTokenImpl !== "") {
    const impl = await ethers.getContractAt("StableDebtToken", addresses.StableDebtTokenImpl, deployer);
    console.log("Found StableDebtToken Impl at:", impl.address);
  } else {
    const StableDebtToken = await ethers.getContractFactory("StableDebtToken", deployer);
    const impl = await StableDebtToken.deploy();
    await impl.deployed();
    addresses.StableDebtTokenImpl = impl.address;
    console.log("Deploy StableDebtToken Impl at:", impl.address);
  }

  if (addresses.VariableDebtTokenImpl !== "") {
    const impl = await ethers.getContractAt("VariableDebtToken", addresses.VariableDebtTokenImpl, deployer);
    console.log("Found VariableDebtToken Impl at:", impl.address);
  } else {
    const VariableDebtToken = await ethers.getContractFactory("VariableDebtToken", deployer);
    const impl = await VariableDebtToken.deploy();
    await impl.deployed();
    addresses.VariableDebtTokenImpl = impl.address;
    console.log("Deploy VariableDebtToken Impl at:", impl.address);
  }

  for (const token of ["CFX", "USDT", "WETH", "WBTC"]) {
    const market = addresses.Markets[token];
    if (market.atoken === "") {
      if (market.DefaultReserveInterestRateStrategy !== ""){
        const defaultReserveInterestRateStrategy = await ethers.getContractAt(
          "contracts/protocol/lendingpool/DefaultReserveInterestRateStrategy.sol:DefaultReserveInterestRateStrategy",
          market.DefaultReserveInterestRateStrategy,
          deployer
        );
        console.log("Found DefaultReserveInterestRateStrategy at:", defaultReserveInterestRateStrategy.address);
      } else {
        const DefaultReserveInterestRateStrategy = await ethers.getContractFactory(
          "contracts/protocol/lendingpool/DefaultReserveInterestRateStrategy.sol:DefaultReserveInterestRateStrategy",
          deployer
        );
        const defaultReserveInterestRateStrategy = await DefaultReserveInterestRateStrategy.deploy(
          lendingPoolAddressesProvider.address,
          RATE_STRATEGY[token].optimalUtilizationRate,
          RATE_STRATEGY[token].baseVariableBorrowRate,
          RATE_STRATEGY[token].variableRateSlope1,
          RATE_STRATEGY[token].variableRateSlope2,
          RATE_STRATEGY[token].stableRateSlope1,
          RATE_STRATEGY[token].stableRateSlope2
        );
        await defaultReserveInterestRateStrategy.deployed();
        market.DefaultReserveInterestRateStrategy = defaultReserveInterestRateStrategy.address;
        console.log(
          "Deploy",
          token,
          "DefaultReserveInterestRateStrategy at:",
          defaultReserveInterestRateStrategy.address
        );
      }
      const tx = await lendingPoolConfigurator.batchInitReserve([
        {
          aTokenImpl: addresses.ATokenImpl!,
          stableDebtTokenImpl: addresses.StableDebtTokenImpl!,
          variableDebtTokenImpl: addresses.VariableDebtTokenImpl!,
          underlyingAssetDecimals: market.decimals,
          interestRateStrategyAddress: market.DefaultReserveInterestRateStrategy!,
          underlyingAsset: market.token,
          treasury: addresses.Treasury,
          incentivesController: chefIncentivesController.address,
          allocPoint: 1,
          underlyingAssetName: token,
          aTokenName: `Goledo interest bearing ${token}`,
          aTokenSymbol: `g${token}`,
          variableDebtTokenName: `Goledo variable debt bearing ${token}`,
          variableDebtTokenSymbol: `variableDebt${token}`,
          stableDebtTokenName: `Goledo stable debt bearing ${token}`,
          stableDebtTokenSymbol: `stableDebt${token}`,
          params: [],
        },
      ]);
      console.log(`>> Deploying ${token} market, hash:`, tx.hash);
      await tx.wait();
      console.log(">> ✅ Done");

      const reserveData = await lendingPool.getReserveData(market.token);
      console.log(
        `Market[${token}] aToken[${reserveData.aTokenAddress}]`,
        `sToken[${reserveData.stableDebtTokenAddress}]`,
        `vToken[${reserveData.variableDebtTokenAddress}]`
      );
      market.atoken = reserveData.aTokenAddress;
      market.stoken = reserveData.stableDebtTokenAddress;
      market.vtoken = reserveData.variableDebtTokenAddress;
    }
    if (market.oracle === "") {
      const WitnetPriceFeed = await ethers.getContractFactory("WitnetPriceFeed", deployer);
      const oracle = await WitnetPriceFeed.deploy(
        addresses.WitnetRouter,
        market.witnetConfig.assetId,
        market.witnetConfig.decimals,
        market.witnetConfig.timeout
      );
      await oracle.deployed();
      console.log(`Deploy Oracle for [${token}] at:`, oracle.address);
      market.oracle = oracle.address;
    }
    if ((await aaveOracle.getSourceOfAsset(market.token)) !== market.oracle) {
      const tx = await aaveOracle.setAssetSources([market.token], [market.oracle]);
      console.log(`>> SetAssetSources in AaveOracle for ${token}, hash:`, tx.hash);
      await tx.wait();
      console.log(">> ✅ Done");
    }
  }
  // set mock usd oracle same as usdt oracle
  const tx = await aaveOracle.setAssetSources(
    ["0x000000000000000000000000000000000000dead"],
    [addresses.Markets.USDT.oracle]
  );
  console.log(`>> SetAssetSources in AaveOracle for MOCK USD, hash:`, tx.hash);
  await tx.wait();
  console.log(">> ✅ Done");

  await wethGateway.authorizeLendingPool(addresses.LendingPool);
  await multiFeeDistribution.setMinters([addresses.MasterChef, addresses.ChefIncentivesController, deployer.address]);
  // add gCFX, gUSDT, gWETH, gWBTC as reward
  await multiFeeDistribution.addReward(addresses.Markets.CFX.atoken);
  await multiFeeDistribution.addReward(addresses.Markets.USDT.atoken);
  await multiFeeDistribution.addReward(addresses.Markets.WETH.atoken);
  await multiFeeDistribution.addReward(addresses.Markets.WBTC.atoken);
  await multiFeeDistribution.mint(deployer.address, MAX_SUPPLY.mul(4).div(10), false, {gasLimit: '10000000',});
  await multiFeeDistribution.exit(true, {gasLimit: '10000000',});
  await lendingPoolConfigurator.enableBorrowingOnReserve(addresses.Markets.CFX.token, true);
  await lendingPoolConfigurator.enableBorrowingOnReserve(addresses.Markets.USDT.token, true);
  await lendingPoolConfigurator.enableBorrowingOnReserve(addresses.Markets.WETH.token, true);
  await lendingPoolConfigurator.enableBorrowingOnReserve(addresses.Markets.WBTC.token, true);
  await lendingPoolConfigurator.configureReserveAsCollateral(addresses.Markets.CFX.token, 5000, 6500, 11000);
  await masterChef.addPool(addresses.SwappiLP, 1);
  await lendingPoolConfigurator.configureReserveAsCollateral(addresses.Markets.USDT.token, 8000, 8500, 10500);
  await lendingPoolConfigurator.configureReserveAsCollateral(addresses.Markets.WETH.token, 8000, 8250, 10500);
  await lendingPoolConfigurator.configureReserveAsCollateral(addresses.Markets.WBTC.token, 7000, 7500, 11000);
  await lendingPoolConfigurator.setReserveFactor(addresses.Markets.CFX.token, 5000);
  await lendingPoolConfigurator.setReserveFactor(addresses.Markets.USDT.token, 5000);
  await lendingPoolConfigurator.setReserveFactor(addresses.Markets.WETH.token, 5000);
  await lendingPoolConfigurator.setReserveFactor(addresses.Markets.WBTC.token, 5000);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
