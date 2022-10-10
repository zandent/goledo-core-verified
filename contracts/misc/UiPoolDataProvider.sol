pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;


interface IERC20 {
    
    function totalSupply() external view returns (uint256);

    
    function balanceOf(address account) external view returns (uint256);

    
    function transfer(address recipient, uint256 amount) external returns (bool);

    
    function allowance(address owner, address spender) external view returns (uint256);

    
    function approve(address spender, uint256 amount) external returns (bool);

    
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    
    event Transfer(address indexed from, address indexed to, uint256 value);

    
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Detailed is IERC20 {
  function name() external view returns (string memory);

  function symbol() external view returns (string memory);

  function decimals() external view returns (uint8);
}

interface ILendingPoolAddressesProvider {
  event MarketIdSet(string newMarketId);
  event LendingPoolUpdated(address indexed newAddress);
  event ConfigurationAdminUpdated(address indexed newAddress);
  event EmergencyAdminUpdated(address indexed newAddress);
  event LendingPoolConfiguratorUpdated(address indexed newAddress);
  event LendingPoolCollateralManagerUpdated(address indexed newAddress);
  event PriceOracleUpdated(address indexed newAddress);
  event LendingRateOracleUpdated(address indexed newAddress);
  event ProxyCreated(bytes32 id, address indexed newAddress);
  event AddressSet(bytes32 id, address indexed newAddress, bool hasProxy);

  function getMarketId() external view returns (string memory);

  function setMarketId(string calldata marketId) external;

  function setAddress(bytes32 id, address newAddress) external;

  function setAddressAsProxy(bytes32 id, address impl) external;

  function getAddress(bytes32 id) external view returns (address);

  function getLendingPool() external view returns (address);

  function setLendingPoolImpl(address pool) external;

  function getLendingPoolConfigurator() external view returns (address);

  function setLendingPoolConfiguratorImpl(address configurator) external;

  function getLendingPoolCollateralManager() external view returns (address);

  function setLendingPoolCollateralManager(address manager) external;

  function getPoolAdmin() external view returns (address);

  function setPoolAdmin(address admin) external;

  function getEmergencyAdmin() external view returns (address);

  function setEmergencyAdmin(address admin) external;

  function getPriceOracle() external view returns (address);

  function setPriceOracle(address priceOracle) external;

  function getLendingRateOracle() external view returns (address);

  function setLendingRateOracle(address lendingRateOracle) external;
}

interface IAaveIncentivesController {
  event RewardsAccrued(address indexed user, uint256 amount);

  event RewardsClaimed(address indexed user, address indexed to, uint256 amount);

  event RewardsClaimed(address indexed user, address indexed to, address indexed claimer, uint256 amount);

  event ClaimerSet(address indexed user, address indexed claimer);

  
  function getAssetData(address asset)
    external
    view
    returns (
      uint256,
      uint256,
      uint256
    );

  
  function setClaimer(address user, address claimer) external;

  
  function getClaimer(address user) external view returns (address);

  
  function configureAssets(address[] calldata assets, uint256[] calldata emissionsPerSecond) external;

  
  function handleAction(
    address user,
    uint256 userBalance,
    uint256 totalSupply
  ) external;

  
  function getRewardsBalance(address[] calldata assets, address user) external view returns (uint256);

  
  function claimRewards(
    address[] calldata assets,
    uint256 amount,
    address to
  ) external returns (uint256);

  
  function claimRewardsOnBehalf(
    address[] calldata assets,
    uint256 amount,
    address user,
    address to
  ) external returns (uint256);

  
  function getUserUnclaimedRewards(address user) external view returns (uint256);

  
  function getUserAssetData(address user, address asset) external view returns (uint256);

  
  function REWARD_TOKEN() external view returns (address);

  
  function PRECISION() external view returns (uint8);

  
  function DISTRIBUTION_END() external view returns (uint256);
}

interface IUiPoolDataProvider {
  struct AggregatedReserveData {
    address underlyingAsset;
    string name;
    string symbol;
    uint256 decimals;
    uint256 baseLTVasCollateral;
    uint256 reserveLiquidationThreshold;
    uint256 reserveLiquidationBonus;
    uint256 reserveFactor;
    bool usageAsCollateralEnabled;
    bool borrowingEnabled;
    bool stableBorrowRateEnabled;
    bool isActive;
    bool isFrozen;
    
    uint128 liquidityIndex;
    uint128 variableBorrowIndex;
    uint128 liquidityRate;
    uint128 variableBorrowRate;
    uint128 stableBorrowRate;
    uint40 lastUpdateTimestamp;
    address aTokenAddress;
    address stableDebtTokenAddress;
    address variableDebtTokenAddress;
    address interestRateStrategyAddress;
    
    uint256 availableLiquidity;
    uint256 totalPrincipalStableDebt;
    uint256 averageStableRate;
    uint256 stableDebtLastUpdateTimestamp;
    uint256 totalScaledVariableDebt;
    uint256 priceInEth;
    uint256 variableRateSlope1;
    uint256 variableRateSlope2;
    uint256 stableRateSlope1;
    uint256 stableRateSlope2;
    
    uint256 aEmissionPerSecond;
    uint256 vEmissionPerSecond;
    uint256 sEmissionPerSecond;
    uint256 aIncentivesLastUpdateTimestamp;
    uint256 vIncentivesLastUpdateTimestamp;
    uint256 sIncentivesLastUpdateTimestamp;
    uint256 aTokenIncentivesIndex;
    uint256 vTokenIncentivesIndex;
    uint256 sTokenIncentivesIndex;
  }

  struct UserReserveData {
    address underlyingAsset;
    uint256 scaledATokenBalance;
    bool usageAsCollateralEnabledOnUser;
    uint256 stableBorrowRate;
    uint256 scaledVariableDebt;
    uint256 principalStableDebt;
    uint256 stableBorrowLastUpdateTimestamp;
    
    uint256 aTokenincentivesUserIndex;
    uint256 vTokenincentivesUserIndex;
    uint256 sTokenincentivesUserIndex;
  }

  struct IncentivesControllerData {
    uint256 userUnclaimedRewards;
    uint256 emissionEndTimestamp;
  }

  function getReservesList(ILendingPoolAddressesProvider provider) external view returns (address[] memory);

  function incentivesController() external view returns (IAaveIncentivesController);

  function getSimpleReservesData(ILendingPoolAddressesProvider provider)
    external
    view
    returns (
      AggregatedReserveData[] memory,
      uint256, 
      uint256 
    );

  function getUserReservesData(ILendingPoolAddressesProvider provider, address user)
    external
    view
    returns (
      UserReserveData[] memory,
      uint256 
    );

  
  function getReservesData(ILendingPoolAddressesProvider provider, address user)
    external
    view
    returns (
      AggregatedReserveData[] memory,
      UserReserveData[] memory,
      uint256,
      IncentivesControllerData memory
    );
}

library DataTypes {
  
  struct ReserveData {
    
    ReserveConfigurationMap configuration;
    
    uint128 liquidityIndex;
    
    uint128 variableBorrowIndex;
    
    uint128 currentLiquidityRate;
    
    uint128 currentVariableBorrowRate;
    
    uint128 currentStableBorrowRate;
    uint40 lastUpdateTimestamp;
    
    address aTokenAddress;
    address stableDebtTokenAddress;
    address variableDebtTokenAddress;
    
    address interestRateStrategyAddress;
    
    uint8 id;
  }

  struct ReserveConfigurationMap {
    
    
    
    
    
    
    
    
    
    
    uint256 data;
  }

  struct UserConfigurationMap {
    uint256 data;
  }

  enum InterestRateMode {
    NONE,
    STABLE,
    VARIABLE
  }
}

interface ILendingPool {
  
  event Deposit(
    address indexed reserve,
    address user,
    address indexed onBehalfOf,
    uint256 amount,
    uint16 indexed referral
  );

  
  event Withdraw(address indexed reserve, address indexed user, address indexed to, uint256 amount);

  
  event Borrow(
    address indexed reserve,
    address user,
    address indexed onBehalfOf,
    uint256 amount,
    uint256 borrowRateMode,
    uint256 borrowRate,
    uint16 indexed referral
  );

  
  event Repay(address indexed reserve, address indexed user, address indexed repayer, uint256 amount);

  
  event Swap(address indexed reserve, address indexed user, uint256 rateMode);

  
  event ReserveUsedAsCollateralEnabled(address indexed reserve, address indexed user);

  
  event ReserveUsedAsCollateralDisabled(address indexed reserve, address indexed user);

  
  event RebalanceStableBorrowRate(address indexed reserve, address indexed user);

  
  event FlashLoan(
    address indexed target,
    address indexed initiator,
    address indexed asset,
    uint256 amount,
    uint256 premium,
    uint16 referralCode
  );

  
  event Paused();

  
  event Unpaused();

  
  event LiquidationCall(
    address indexed collateralAsset,
    address indexed debtAsset,
    address indexed user,
    uint256 debtToCover,
    uint256 liquidatedCollateralAmount,
    address liquidator,
    bool receiveAToken
  );

  
  event ReserveDataUpdated(
    address indexed reserve,
    uint256 liquidityRate,
    uint256 stableBorrowRate,
    uint256 variableBorrowRate,
    uint256 liquidityIndex,
    uint256 variableBorrowIndex
  );

  
  function deposit(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode
  ) external;

  
  function withdraw(
    address asset,
    uint256 amount,
    address to
  ) external returns (uint256);

  
  function borrow(
    address asset,
    uint256 amount,
    uint256 interestRateMode,
    uint16 referralCode,
    address onBehalfOf
  ) external;

  
  function repay(
    address asset,
    uint256 amount,
    uint256 rateMode,
    address onBehalfOf
  ) external returns (uint256);

  
  function swapBorrowRateMode(address asset, uint256 rateMode) external;

  
  function rebalanceStableBorrowRate(address asset, address user) external;

  
  function setUserUseReserveAsCollateral(address asset, bool useAsCollateral) external;

  
  function liquidationCall(
    address collateralAsset,
    address debtAsset,
    address user,
    uint256 debtToCover,
    bool receiveAToken
  ) external;

  
  function flashLoan(
    address receiverAddress,
    address[] calldata assets,
    uint256[] calldata amounts,
    uint256[] calldata modes,
    address onBehalfOf,
    bytes calldata params,
    uint16 referralCode
  ) external;

  
  function getUserAccountData(address user)
    external
    view
    returns (
      uint256 totalCollateralETH,
      uint256 totalDebtETH,
      uint256 availableBorrowsETH,
      uint256 currentLiquidationThreshold,
      uint256 ltv,
      uint256 healthFactor
    );

  function initReserve(
    address reserve,
    address aTokenAddress,
    address stableDebtAddress,
    address variableDebtAddress,
    address interestRateStrategyAddress
  ) external;

  function setReserveInterestRateStrategyAddress(address reserve, address rateStrategyAddress) external;

  function setConfiguration(address reserve, uint256 configuration) external;

  
  function getConfiguration(address asset) external view returns (DataTypes.ReserveConfigurationMap memory);

  
  function getUserConfiguration(address user) external view returns (DataTypes.UserConfigurationMap memory);

  
  function getReserveNormalizedIncome(address asset) external view returns (uint256);

  
  function getReserveNormalizedVariableDebt(address asset) external view returns (uint256);

  
  function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);

  function finalizeTransfer(
    address asset,
    address from,
    address to,
    uint256 amount,
    uint256 balanceFromAfter,
    uint256 balanceToBefore
  ) external;

  function getReservesList() external view returns (address[] memory);

  function getAddressesProvider() external view returns (ILendingPoolAddressesProvider);

  function setPause(bool val) external;

  function paused() external view returns (bool);
}

interface IPriceOracleGetter {
  
  function getAssetPrice(address asset) external view returns (uint256);

  function updateAssetPrice(address asset) external returns (uint256);
}

interface IScaledBalanceToken {
  
  function scaledBalanceOf(address user) external view returns (uint256);

  
  function getScaledUserBalanceAndSupply(address user) external view returns (uint256, uint256);

  
  function scaledTotalSupply() external view returns (uint256);
}

interface IInitializableAToken {
  
  event Initialized(
    address indexed underlyingAsset,
    address indexed pool,
    address treasury,
    address incentivesController,
    uint8 aTokenDecimals,
    string aTokenName,
    string aTokenSymbol,
    bytes params
  );

  
  function initialize(
    ILendingPool pool,
    address treasury,
    address underlyingAsset,
    IAaveIncentivesController incentivesController,
    uint8 aTokenDecimals,
    string calldata aTokenName,
    string calldata aTokenSymbol,
    bytes calldata params
  ) external;
}

interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
  
  event Mint(address indexed from, uint256 value, uint256 index);

  
  function mint(
    address user,
    uint256 amount,
    uint256 index
  ) external returns (bool);

  
  event Burn(address indexed from, address indexed target, uint256 value, uint256 index);

  
  event BalanceTransfer(address indexed from, address indexed to, uint256 value, uint256 index);

  
  function burn(
    address user,
    address receiverOfUnderlying,
    uint256 amount,
    uint256 index
  ) external;

  
  function mintToTreasury(uint256 amount, uint256 index) external;

  
  function transferOnLiquidation(
    address from,
    address to,
    uint256 value
  ) external;

  
  function transferUnderlyingTo(address user, uint256 amount) external returns (uint256);

  
  function handleRepayment(address user, uint256 amount) external;

  
  function getIncentivesController() external view returns (IAaveIncentivesController);

  
  function UNDERLYING_ASSET_ADDRESS() external view returns (address);
}

interface IInitializableDebtToken {
  
  event Initialized(
    address indexed underlyingAsset,
    address indexed pool,
    address incentivesController,
    uint8 debtTokenDecimals,
    string debtTokenName,
    string debtTokenSymbol,
    bytes params
  );

  
  function initialize(
    ILendingPool pool,
    address underlyingAsset,
    IAaveIncentivesController incentivesController,
    uint8 debtTokenDecimals,
    string memory debtTokenName,
    string memory debtTokenSymbol,
    bytes calldata params
  ) external;
}

interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
  
  event Mint(address indexed from, address indexed onBehalfOf, uint256 value, uint256 index);

  
  function mint(
    address user,
    address onBehalfOf,
    uint256 amount,
    uint256 index
  ) external returns (bool);

  
  event Burn(address indexed user, uint256 amount, uint256 index);

  
  function burn(
    address user,
    uint256 amount,
    uint256 index
  ) external;

  
  function getIncentivesController() external view returns (IAaveIncentivesController);
}

interface IStableDebtToken is IInitializableDebtToken {
  
  event Mint(
    address indexed user,
    address indexed onBehalfOf,
    uint256 amount,
    uint256 currentBalance,
    uint256 balanceIncrease,
    uint256 newRate,
    uint256 avgStableRate,
    uint256 newTotalSupply
  );

  
  event Burn(
    address indexed user,
    uint256 amount,
    uint256 currentBalance,
    uint256 balanceIncrease,
    uint256 avgStableRate,
    uint256 newTotalSupply
  );

  
  function mint(
    address user,
    address onBehalfOf,
    uint256 amount,
    uint256 rate
  ) external returns (bool);

  
  function burn(address user, uint256 amount) external;

  
  function getAverageStableRate() external view returns (uint256);

  
  function getUserStableRate(address user) external view returns (uint256);

  
  function getUserLastUpdated(address user) external view returns (uint40);

  
  function getSupplyData()
    external
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint40
    );

  
  function getTotalSupplyLastUpdated() external view returns (uint40);

  
  function getTotalSupplyAndAvgRate() external view returns (uint256, uint256);

  
  function principalBalanceOf(address user) external view returns (uint256);

  
  function getIncentivesController() external view returns (IAaveIncentivesController);
}

library Errors {
  
  string public constant CALLER_NOT_POOL_ADMIN = "33"; 
  string public constant BORROW_ALLOWANCE_NOT_ENOUGH = "59"; 

  
  string public constant VL_INVALID_AMOUNT = "1"; 
  string public constant VL_NO_ACTIVE_RESERVE = "2"; 
  string public constant VL_RESERVE_FROZEN = "3"; 
  string public constant VL_CURRENT_AVAILABLE_LIQUIDITY_NOT_ENOUGH = "4"; 
  string public constant VL_NOT_ENOUGH_AVAILABLE_USER_BALANCE = "5"; 
  string public constant VL_TRANSFER_NOT_ALLOWED = "6"; 
  string public constant VL_BORROWING_NOT_ENABLED = "7"; 
  string public constant VL_INVALID_INTEREST_RATE_MODE_SELECTED = "8"; 
  string public constant VL_COLLATERAL_BALANCE_IS_0 = "9"; 
  string public constant VL_HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD = "10"; 
  string public constant VL_COLLATERAL_CANNOT_COVER_NEW_BORROW = "11"; 
  string public constant VL_STABLE_BORROWING_NOT_ENABLED = "12"; 
  string public constant VL_COLLATERAL_SAME_AS_BORROWING_CURRENCY = "13"; 
  string public constant VL_AMOUNT_BIGGER_THAN_MAX_LOAN_SIZE_STABLE = "14"; 
  string public constant VL_NO_DEBT_OF_SELECTED_TYPE = "15"; 
  string public constant VL_NO_EXPLICIT_AMOUNT_TO_REPAY_ON_BEHALF = "16"; 
  string public constant VL_NO_STABLE_RATE_LOAN_IN_RESERVE = "17"; 
  string public constant VL_NO_VARIABLE_RATE_LOAN_IN_RESERVE = "18"; 
  string public constant VL_UNDERLYING_BALANCE_NOT_GREATER_THAN_0 = "19"; 
  string public constant VL_DEPOSIT_ALREADY_IN_USE = "20"; 
  string public constant LP_NOT_ENOUGH_STABLE_BORROW_BALANCE = "21"; 
  string public constant LP_INTEREST_RATE_REBALANCE_CONDITIONS_NOT_MET = "22"; 
  string public constant LP_LIQUIDATION_CALL_FAILED = "23"; 
  string public constant LP_NOT_ENOUGH_LIQUIDITY_TO_BORROW = "24"; 
  string public constant LP_REQUESTED_AMOUNT_TOO_SMALL = "25"; 
  string public constant LP_INCONSISTENT_PROTOCOL_ACTUAL_BALANCE = "26"; 
  string public constant LP_CALLER_NOT_LENDING_POOL_CONFIGURATOR = "27"; 
  string public constant LP_INCONSISTENT_FLASHLOAN_PARAMS = "28";
  string public constant CT_CALLER_MUST_BE_LENDING_POOL = "29"; 
  string public constant CT_CANNOT_GIVE_ALLOWANCE_TO_HIMSELF = "30"; 
  string public constant CT_TRANSFER_AMOUNT_NOT_GT_0 = "31"; 
  string public constant RL_RESERVE_ALREADY_INITIALIZED = "32"; 
  string public constant LPC_RESERVE_LIQUIDITY_NOT_0 = "34"; 
  string public constant LPC_INVALID_ATOKEN_POOL_ADDRESS = "35"; 
  string public constant LPC_INVALID_STABLE_DEBT_TOKEN_POOL_ADDRESS = "36"; 
  string public constant LPC_INVALID_VARIABLE_DEBT_TOKEN_POOL_ADDRESS = "37"; 
  string public constant LPC_INVALID_STABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = "38"; 
  string public constant LPC_INVALID_VARIABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = "39"; 
  string public constant LPC_INVALID_ADDRESSES_PROVIDER_ID = "40"; 
  string public constant LPC_INVALID_CONFIGURATION = "75"; 
  string public constant LPC_CALLER_NOT_EMERGENCY_ADMIN = "76"; 
  string public constant LPAPR_PROVIDER_NOT_REGISTERED = "41"; 
  string public constant LPCM_HEALTH_FACTOR_NOT_BELOW_THRESHOLD = "42"; 
  string public constant LPCM_COLLATERAL_CANNOT_BE_LIQUIDATED = "43"; 
  string public constant LPCM_SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = "44"; 
  string public constant LPCM_NOT_ENOUGH_LIQUIDITY_TO_LIQUIDATE = "45"; 
  string public constant LPCM_NO_ERRORS = "46"; 
  string public constant LP_INVALID_FLASHLOAN_MODE = "47"; 
  string public constant MATH_MULTIPLICATION_OVERFLOW = "48";
  string public constant MATH_ADDITION_OVERFLOW = "49";
  string public constant MATH_DIVISION_BY_ZERO = "50";
  string public constant RL_LIQUIDITY_INDEX_OVERFLOW = "51"; 
  string public constant RL_VARIABLE_BORROW_INDEX_OVERFLOW = "52"; 
  string public constant RL_LIQUIDITY_RATE_OVERFLOW = "53"; 
  string public constant RL_VARIABLE_BORROW_RATE_OVERFLOW = "54"; 
  string public constant RL_STABLE_BORROW_RATE_OVERFLOW = "55"; 
  string public constant CT_INVALID_MINT_AMOUNT = "56"; 
  string public constant LP_FAILED_REPAY_WITH_COLLATERAL = "57";
  string public constant CT_INVALID_BURN_AMOUNT = "58"; 
  string public constant LP_FAILED_COLLATERAL_SWAP = "60";
  string public constant LP_INVALID_EQUAL_ASSETS_TO_SWAP = "61";
  string public constant LP_REENTRANCY_NOT_ALLOWED = "62";
  string public constant LP_CALLER_MUST_BE_AN_ATOKEN = "63";
  string public constant LP_IS_PAUSED = "64"; 
  string public constant LP_NO_MORE_RESERVES_ALLOWED = "65";
  string public constant LP_INVALID_FLASH_LOAN_EXECUTOR_RETURN = "66";
  string public constant RC_INVALID_LTV = "67";
  string public constant RC_INVALID_LIQ_THRESHOLD = "68";
  string public constant RC_INVALID_LIQ_BONUS = "69";
  string public constant RC_INVALID_DECIMALS = "70";
  string public constant RC_INVALID_RESERVE_FACTOR = "71";
  string public constant LPAPR_INVALID_ADDRESSES_PROVIDER_ID = "72";
  string public constant VL_INCONSISTENT_FLASHLOAN_PARAMS = "73";
  string public constant LP_INCONSISTENT_PARAMS_LENGTH = "74";
  string public constant UL_INVALID_INDEX = "77";
  string public constant LP_NOT_CONTRACT = "78";
  string public constant SDT_STABLE_DEBT_OVERFLOW = "79";
  string public constant SDT_BURN_EXCEEDS_BALANCE = "80";

  enum CollateralManagerErrors {
    NO_ERROR,
    NO_COLLATERAL_AVAILABLE,
    COLLATERAL_CANNOT_BE_LIQUIDATED,
    CURRRENCY_NOT_BORROWED,
    HEALTH_FACTOR_ABOVE_THRESHOLD,
    NOT_ENOUGH_LIQUIDITY,
    NO_ACTIVE_RESERVE,
    HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD,
    INVALID_EQUAL_ASSETS_TO_SWAP,
    FROZEN_RESERVE
  }
}

library WadRayMath {
  uint256 internal constant WAD = 1e18;
  uint256 internal constant halfWAD = WAD / 2;

  uint256 internal constant RAY = 1e27;
  uint256 internal constant halfRAY = RAY / 2;

  uint256 internal constant WAD_RAY_RATIO = 1e9;

  
  function ray() internal pure returns (uint256) {
    return RAY;
  }

  

  function wad() internal pure returns (uint256) {
    return WAD;
  }

  
  function halfRay() internal pure returns (uint256) {
    return halfRAY;
  }

  
  function halfWad() internal pure returns (uint256) {
    return halfWAD;
  }

  
  function wadMul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0 || b == 0) {
      return 0;
    }

    require(a <= (type(uint256).max - halfWAD) / b, Errors.MATH_MULTIPLICATION_OVERFLOW);

    return (a * b + halfWAD) / WAD;
  }

  
  function wadDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0, Errors.MATH_DIVISION_BY_ZERO);
    uint256 halfB = b / 2;

    require(a <= (type(uint256).max - halfB) / WAD, Errors.MATH_MULTIPLICATION_OVERFLOW);

    return (a * WAD + halfB) / b;
  }

  
  function rayMul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0 || b == 0) {
      return 0;
    }

    require(a <= (type(uint256).max - halfRAY) / b, Errors.MATH_MULTIPLICATION_OVERFLOW);

    return (a * b + halfRAY) / RAY;
  }

  
  function rayDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0, Errors.MATH_DIVISION_BY_ZERO);
    uint256 halfB = b / 2;

    require(a <= (type(uint256).max - halfB) / RAY, Errors.MATH_MULTIPLICATION_OVERFLOW);

    return (a * RAY + halfB) / b;
  }

  
  function rayToWad(uint256 a) internal pure returns (uint256) {
    uint256 halfRatio = WAD_RAY_RATIO / 2;
    uint256 result = halfRatio + a;
    require(result >= halfRatio, Errors.MATH_ADDITION_OVERFLOW);

    return result / WAD_RAY_RATIO;
  }

  
  function wadToRay(uint256 a) internal pure returns (uint256) {
    uint256 result = a * WAD_RAY_RATIO;
    require(result / WAD_RAY_RATIO == a, Errors.MATH_MULTIPLICATION_OVERFLOW);
    return result;
  }
}

library ReserveConfiguration {
  uint256 constant LTV_MASK =                   0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000; 
  uint256 constant LIQUIDATION_THRESHOLD_MASK = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF; 
  uint256 constant LIQUIDATION_BONUS_MASK =     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFF; 
  uint256 constant DECIMALS_MASK =              0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF; 
  uint256 constant ACTIVE_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF; 
  uint256 constant FROZEN_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF; 
  uint256 constant BORROWING_MASK =             0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF; 
  uint256 constant STABLE_BORROWING_MASK =      0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFF; 
  uint256 constant RESERVE_FACTOR_MASK =        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF; 

  
  uint256 constant LIQUIDATION_THRESHOLD_START_BIT_POSITION = 16;
  uint256 constant LIQUIDATION_BONUS_START_BIT_POSITION = 32;
  uint256 constant RESERVE_DECIMALS_START_BIT_POSITION = 48;
  uint256 constant IS_ACTIVE_START_BIT_POSITION = 56;
  uint256 constant IS_FROZEN_START_BIT_POSITION = 57;
  uint256 constant BORROWING_ENABLED_START_BIT_POSITION = 58;
  uint256 constant STABLE_BORROWING_ENABLED_START_BIT_POSITION = 59;
  uint256 constant RESERVE_FACTOR_START_BIT_POSITION = 64;

  uint256 constant MAX_VALID_LTV = 65535;
  uint256 constant MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
  uint256 constant MAX_VALID_LIQUIDATION_BONUS = 65535;
  uint256 constant MAX_VALID_DECIMALS = 255;
  uint256 constant MAX_VALID_RESERVE_FACTOR = 65535;

  
  function setLtv(DataTypes.ReserveConfigurationMap memory self, uint256 ltv) internal pure {
    require(ltv <= MAX_VALID_LTV, Errors.RC_INVALID_LTV);

    self.data = (self.data & LTV_MASK) | ltv;
  }

  
  function getLtv(DataTypes.ReserveConfigurationMap storage self) internal view returns (uint256) {
    return self.data & ~LTV_MASK;
  }

  
  function setLiquidationThreshold(DataTypes.ReserveConfigurationMap memory self, uint256 threshold) internal pure {
    require(threshold <= MAX_VALID_LIQUIDATION_THRESHOLD, Errors.RC_INVALID_LIQ_THRESHOLD);

    self.data = (self.data & LIQUIDATION_THRESHOLD_MASK) | (threshold << LIQUIDATION_THRESHOLD_START_BIT_POSITION);
  }

  
  function getLiquidationThreshold(DataTypes.ReserveConfigurationMap storage self) internal view returns (uint256) {
    return (self.data & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION;
  }

  
  function setLiquidationBonus(DataTypes.ReserveConfigurationMap memory self, uint256 bonus) internal pure {
    require(bonus <= MAX_VALID_LIQUIDATION_BONUS, Errors.RC_INVALID_LIQ_BONUS);

    self.data = (self.data & LIQUIDATION_BONUS_MASK) | (bonus << LIQUIDATION_BONUS_START_BIT_POSITION);
  }

  
  function getLiquidationBonus(DataTypes.ReserveConfigurationMap storage self) internal view returns (uint256) {
    return (self.data & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION;
  }

  
  function setDecimals(DataTypes.ReserveConfigurationMap memory self, uint256 decimals) internal pure {
    require(decimals <= MAX_VALID_DECIMALS, Errors.RC_INVALID_DECIMALS);

    self.data = (self.data & DECIMALS_MASK) | (decimals << RESERVE_DECIMALS_START_BIT_POSITION);
  }

  
  function getDecimals(DataTypes.ReserveConfigurationMap storage self) internal view returns (uint256) {
    return (self.data & ~DECIMALS_MASK) >> RESERVE_DECIMALS_START_BIT_POSITION;
  }

  
  function setActive(DataTypes.ReserveConfigurationMap memory self, bool active) internal pure {
    self.data = (self.data & ACTIVE_MASK) | (uint256(active ? 1 : 0) << IS_ACTIVE_START_BIT_POSITION);
  }

  
  function getActive(DataTypes.ReserveConfigurationMap storage self) internal view returns (bool) {
    return (self.data & ~ACTIVE_MASK) != 0;
  }

  
  function setFrozen(DataTypes.ReserveConfigurationMap memory self, bool frozen) internal pure {
    self.data = (self.data & FROZEN_MASK) | (uint256(frozen ? 1 : 0) << IS_FROZEN_START_BIT_POSITION);
  }

  
  function getFrozen(DataTypes.ReserveConfigurationMap storage self) internal view returns (bool) {
    return (self.data & ~FROZEN_MASK) != 0;
  }

  
  function setBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled) internal pure {
    self.data = (self.data & BORROWING_MASK) | (uint256(enabled ? 1 : 0) << BORROWING_ENABLED_START_BIT_POSITION);
  }

  
  function getBorrowingEnabled(DataTypes.ReserveConfigurationMap storage self) internal view returns (bool) {
    return (self.data & ~BORROWING_MASK) != 0;
  }

  
  function setStableRateBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled) internal pure {
    self.data =
      (self.data & STABLE_BORROWING_MASK) |
      (uint256(enabled ? 1 : 0) << STABLE_BORROWING_ENABLED_START_BIT_POSITION);
  }

  
  function getStableRateBorrowingEnabled(DataTypes.ReserveConfigurationMap storage self) internal view returns (bool) {
    return (self.data & ~STABLE_BORROWING_MASK) != 0;
  }

  
  function setReserveFactor(DataTypes.ReserveConfigurationMap memory self, uint256 reserveFactor) internal pure {
    require(reserveFactor <= MAX_VALID_RESERVE_FACTOR, Errors.RC_INVALID_RESERVE_FACTOR);

    self.data = (self.data & RESERVE_FACTOR_MASK) | (reserveFactor << RESERVE_FACTOR_START_BIT_POSITION);
  }

  
  function getReserveFactor(DataTypes.ReserveConfigurationMap storage self) internal view returns (uint256) {
    return (self.data & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
  }

  
  function getFlags(DataTypes.ReserveConfigurationMap storage self)
    internal
    view
    returns (
      bool,
      bool,
      bool,
      bool
    )
  {
    uint256 dataLocal = self.data;

    return (
      (dataLocal & ~ACTIVE_MASK) != 0,
      (dataLocal & ~FROZEN_MASK) != 0,
      (dataLocal & ~BORROWING_MASK) != 0,
      (dataLocal & ~STABLE_BORROWING_MASK) != 0
    );
  }

  
  function getParams(DataTypes.ReserveConfigurationMap storage self)
    internal
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint256,
      uint256
    )
  {
    uint256 dataLocal = self.data;

    return (
      dataLocal & ~LTV_MASK,
      (dataLocal & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION,
      (dataLocal & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION,
      (dataLocal & ~DECIMALS_MASK) >> RESERVE_DECIMALS_START_BIT_POSITION,
      (dataLocal & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION
    );
  }

  
  function getParamsMemory(DataTypes.ReserveConfigurationMap memory self)
    internal
    pure
    returns (
      uint256,
      uint256,
      uint256,
      uint256,
      uint256
    )
  {
    return (
      self.data & ~LTV_MASK,
      (self.data & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION,
      (self.data & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION,
      (self.data & ~DECIMALS_MASK) >> RESERVE_DECIMALS_START_BIT_POSITION,
      (self.data & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION
    );
  }

  
  function getFlagsMemory(DataTypes.ReserveConfigurationMap memory self)
    internal
    pure
    returns (
      bool,
      bool,
      bool,
      bool
    )
  {
    return (
      (self.data & ~ACTIVE_MASK) != 0,
      (self.data & ~FROZEN_MASK) != 0,
      (self.data & ~BORROWING_MASK) != 0,
      (self.data & ~STABLE_BORROWING_MASK) != 0
    );
  }
}

library UserConfiguration {
  uint256 internal constant BORROWING_MASK = 0x5555555555555555555555555555555555555555555555555555555555555555;

  
  function setBorrowing(
    DataTypes.UserConfigurationMap storage self,
    uint256 reserveIndex,
    bool borrowing
  ) internal {
    require(reserveIndex < 128, Errors.UL_INVALID_INDEX);
    self.data = (self.data & ~(1 << (reserveIndex * 2))) | (uint256(borrowing ? 1 : 0) << (reserveIndex * 2));
  }

  
  function setUsingAsCollateral(
    DataTypes.UserConfigurationMap storage self,
    uint256 reserveIndex,
    bool usingAsCollateral
  ) internal {
    require(reserveIndex < 128, Errors.UL_INVALID_INDEX);
    self.data =
      (self.data & ~(1 << (reserveIndex * 2 + 1))) |
      (uint256(usingAsCollateral ? 1 : 0) << (reserveIndex * 2 + 1));
  }

  
  function isUsingAsCollateralOrBorrowing(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex)
    internal
    pure
    returns (bool)
  {
    require(reserveIndex < 128, Errors.UL_INVALID_INDEX);
    return (self.data >> (reserveIndex * 2)) & 3 != 0;
  }

  
  function isBorrowing(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex) internal pure returns (bool) {
    require(reserveIndex < 128, Errors.UL_INVALID_INDEX);
    return (self.data >> (reserveIndex * 2)) & 1 != 0;
  }

  
  function isUsingAsCollateral(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex)
    internal
    pure
    returns (bool)
  {
    require(reserveIndex < 128, Errors.UL_INVALID_INDEX);
    return (self.data >> (reserveIndex * 2 + 1)) & 1 != 0;
  }

  
  function isBorrowingAny(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
    return self.data & BORROWING_MASK != 0;
  }

  
  function isEmpty(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
    return self.data == 0;
  }
}

library SafeMath {
    
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        
        
        
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

interface IReserveInterestRateStrategy {
  function baseVariableBorrowRate() external view returns (uint256);

  function getMaxVariableBorrowRate() external view returns (uint256);

  function calculateInterestRates(
    address reserve,
    uint256 availableLiquidity,
    uint256 totalStableDebt,
    uint256 totalVariableDebt,
    uint256 averageStableBorrowRate,
    uint256 reserveFactor
  )
    external
    view
    returns (
      uint256,
      uint256,
      uint256
    );

  function calculateInterestRates(
    address reserve,
    address aToken,
    uint256 liquidityAdded,
    uint256 liquidityTaken,
    uint256 totalStableDebt,
    uint256 totalVariableDebt,
    uint256 averageStableBorrowRate,
    uint256 reserveFactor
  )
    external
    view
    returns (
      uint256 liquidityRate,
      uint256 stableBorrowRate,
      uint256 variableBorrowRate
    );
}

library PercentageMath {
  uint256 constant PERCENTAGE_FACTOR = 1e4; 
  uint256 constant HALF_PERCENT = PERCENTAGE_FACTOR / 2;

  
  function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256) {
    if (value == 0 || percentage == 0) {
      return 0;
    }

    require(value <= (type(uint256).max - HALF_PERCENT) / percentage, Errors.MATH_MULTIPLICATION_OVERFLOW);

    return (value * percentage + HALF_PERCENT) / PERCENTAGE_FACTOR;
  }

  
  function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256) {
    require(percentage != 0, Errors.MATH_DIVISION_BY_ZERO);
    uint256 halfPercentage = percentage / 2;

    require(value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR, Errors.MATH_MULTIPLICATION_OVERFLOW);

    return (value * PERCENTAGE_FACTOR + halfPercentage) / percentage;
  }
}

interface ILendingRateOracle {
  
  function getMarketBorrowRate(address asset) external view returns (uint256);

  
  function setMarketBorrowRate(address asset, uint256 rate) external;
}

contract DefaultReserveInterestRateStrategy is IReserveInterestRateStrategy {
  using WadRayMath for uint256;
  using SafeMath for uint256;
  using PercentageMath for uint256;

  
  uint256 public immutable OPTIMAL_UTILIZATION_RATE;

  

  uint256 public immutable EXCESS_UTILIZATION_RATE;

  ILendingPoolAddressesProvider public immutable addressesProvider;

  
  uint256 internal immutable _baseVariableBorrowRate;

  
  uint256 internal immutable _variableRateSlope1;

  
  uint256 internal immutable _variableRateSlope2;

  
  uint256 internal immutable _stableRateSlope1;

  
  uint256 internal immutable _stableRateSlope2;

  constructor(
    ILendingPoolAddressesProvider provider,
    uint256 optimalUtilizationRate,
    uint256 baseVariableBorrowRate,
    uint256 variableRateSlope1,
    uint256 variableRateSlope2,
    uint256 stableRateSlope1,
    uint256 stableRateSlope2
  ) {
    OPTIMAL_UTILIZATION_RATE = optimalUtilizationRate;
    EXCESS_UTILIZATION_RATE = WadRayMath.ray().sub(optimalUtilizationRate);
    addressesProvider = provider;
    _baseVariableBorrowRate = baseVariableBorrowRate;
    _variableRateSlope1 = variableRateSlope1;
    _variableRateSlope2 = variableRateSlope2;
    _stableRateSlope1 = stableRateSlope1;
    _stableRateSlope2 = stableRateSlope2;
  }

  function variableRateSlope1() external view returns (uint256) {
    return _variableRateSlope1;
  }

  function variableRateSlope2() external view returns (uint256) {
    return _variableRateSlope2;
  }

  function stableRateSlope1() external view returns (uint256) {
    return _stableRateSlope1;
  }

  function stableRateSlope2() external view returns (uint256) {
    return _stableRateSlope2;
  }

  function baseVariableBorrowRate() external view override returns (uint256) {
    return _baseVariableBorrowRate;
  }

  function getMaxVariableBorrowRate() external view override returns (uint256) {
    return _baseVariableBorrowRate.add(_variableRateSlope1).add(_variableRateSlope2);
  }

  
  function calculateInterestRates(
    address reserve,
    address aToken,
    uint256 liquidityAdded,
    uint256 liquidityTaken,
    uint256 totalStableDebt,
    uint256 totalVariableDebt,
    uint256 averageStableBorrowRate,
    uint256 reserveFactor
  )
    external
    view
    override
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    uint256 availableLiquidity = IERC20(reserve).balanceOf(aToken);
    
    availableLiquidity = availableLiquidity.add(liquidityAdded).sub(liquidityTaken);

    return
      calculateInterestRates(
        reserve,
        availableLiquidity,
        totalStableDebt,
        totalVariableDebt,
        averageStableBorrowRate,
        reserveFactor
      );
  }

  struct CalcInterestRatesLocalVars {
    uint256 totalDebt;
    uint256 currentVariableBorrowRate;
    uint256 currentStableBorrowRate;
    uint256 currentLiquidityRate;
    uint256 utilizationRate;
  }

  
  function calculateInterestRates(
    address reserve,
    uint256 availableLiquidity,
    uint256 totalStableDebt,
    uint256 totalVariableDebt,
    uint256 averageStableBorrowRate,
    uint256 reserveFactor
  )
    public
    view
    override
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    CalcInterestRatesLocalVars memory vars;

    vars.totalDebt = totalStableDebt.add(totalVariableDebt);
    vars.currentVariableBorrowRate = 0;
    vars.currentStableBorrowRate = 0;
    vars.currentLiquidityRate = 0;

    vars.utilizationRate = vars.totalDebt == 0 ? 0 : vars.totalDebt.rayDiv(availableLiquidity.add(vars.totalDebt));

    vars.currentStableBorrowRate = ILendingRateOracle(addressesProvider.getLendingRateOracle()).getMarketBorrowRate(
      reserve
    );

    if (vars.utilizationRate > OPTIMAL_UTILIZATION_RATE) {
      uint256 excessUtilizationRateRatio = vars.utilizationRate.sub(OPTIMAL_UTILIZATION_RATE).rayDiv(
        EXCESS_UTILIZATION_RATE
      );

      vars.currentStableBorrowRate = vars.currentStableBorrowRate.add(_stableRateSlope1).add(
        _stableRateSlope2.rayMul(excessUtilizationRateRatio)
      );

      vars.currentVariableBorrowRate = _baseVariableBorrowRate.add(_variableRateSlope1).add(
        _variableRateSlope2.rayMul(excessUtilizationRateRatio)
      );
    } else {
      vars.currentStableBorrowRate = vars.currentStableBorrowRate.add(
        _stableRateSlope1.rayMul(vars.utilizationRate.rayDiv(OPTIMAL_UTILIZATION_RATE))
      );
      vars.currentVariableBorrowRate = _baseVariableBorrowRate.add(
        vars.utilizationRate.rayMul(_variableRateSlope1).rayDiv(OPTIMAL_UTILIZATION_RATE)
      );
    }

    vars.currentLiquidityRate = _getOverallBorrowRate(
      totalStableDebt,
      totalVariableDebt,
      vars.currentVariableBorrowRate,
      averageStableBorrowRate
    ).rayMul(vars.utilizationRate).percentMul(PercentageMath.PERCENTAGE_FACTOR.sub(reserveFactor));

    return (vars.currentLiquidityRate, vars.currentStableBorrowRate, vars.currentVariableBorrowRate);
  }

  
  function _getOverallBorrowRate(
    uint256 totalStableDebt,
    uint256 totalVariableDebt,
    uint256 currentVariableBorrowRate,
    uint256 currentAverageStableBorrowRate
  ) internal pure returns (uint256) {
    uint256 totalDebt = totalStableDebt.add(totalVariableDebt);

    if (totalDebt == 0) return 0;

    uint256 weightedVariableRate = totalVariableDebt.wadToRay().rayMul(currentVariableBorrowRate);

    uint256 weightedStableRate = totalStableDebt.wadToRay().rayMul(currentAverageStableBorrowRate);

    uint256 overallBorrowRate = weightedVariableRate.add(weightedStableRate).rayDiv(totalDebt.wadToRay());

    return overallBorrowRate;
  }
}

contract UiPoolDataProvider is IUiPoolDataProvider {
  using WadRayMath for uint256;
  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
  using UserConfiguration for DataTypes.UserConfigurationMap;

  address public constant MOCK_USD_ADDRESS = address(0xdead);
  IAaveIncentivesController public immutable override incentivesController;
  IPriceOracleGetter public immutable oracle;

  constructor(IAaveIncentivesController _incentivesController, IPriceOracleGetter _oracle) public {
    incentivesController = _incentivesController;
    oracle = _oracle;
  }

  function getInterestRateStrategySlopes(DefaultReserveInterestRateStrategy interestRateStrategy)
    internal
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint256
    )
  {
    return (
      interestRateStrategy.variableRateSlope1(),
      interestRateStrategy.variableRateSlope2(),
      interestRateStrategy.stableRateSlope1(),
      interestRateStrategy.stableRateSlope2()
    );
  }

  function getReservesList(ILendingPoolAddressesProvider provider) public view override returns (address[] memory) {
    ILendingPool lendingPool = ILendingPool(provider.getLendingPool());
    return lendingPool.getReservesList();
  }

  function getSimpleReservesData(ILendingPoolAddressesProvider provider)
    public
    view
    override
    returns (
      AggregatedReserveData[] memory,
      uint256,
      uint256
    )
  {
    ILendingPool lendingPool = ILendingPool(provider.getLendingPool());
    address[] memory reserves = lendingPool.getReservesList();
    AggregatedReserveData[] memory reservesData = new AggregatedReserveData[](reserves.length);

    for (uint256 i = 0; i < reserves.length; i++) {
      AggregatedReserveData memory reserveData = reservesData[i];
      reserveData.underlyingAsset = reserves[i];

      
      DataTypes.ReserveData memory baseData = lendingPool.getReserveData(reserveData.underlyingAsset);
      reserveData.liquidityIndex = baseData.liquidityIndex;
      reserveData.variableBorrowIndex = baseData.variableBorrowIndex;
      reserveData.liquidityRate = baseData.currentLiquidityRate;
      reserveData.variableBorrowRate = baseData.currentVariableBorrowRate;
      reserveData.stableBorrowRate = baseData.currentStableBorrowRate;
      reserveData.lastUpdateTimestamp = baseData.lastUpdateTimestamp;
      reserveData.aTokenAddress = baseData.aTokenAddress;
      reserveData.stableDebtTokenAddress = baseData.stableDebtTokenAddress;
      reserveData.variableDebtTokenAddress = baseData.variableDebtTokenAddress;
      reserveData.interestRateStrategyAddress = baseData.interestRateStrategyAddress;
      reserveData.priceInEth = oracle.getAssetPrice(reserveData.underlyingAsset);

      reserveData.availableLiquidity = IERC20Detailed(reserveData.underlyingAsset).balanceOf(reserveData.aTokenAddress);
      (
        reserveData.totalPrincipalStableDebt,
        ,
        reserveData.averageStableRate,
        reserveData.stableDebtLastUpdateTimestamp
      ) = IStableDebtToken(reserveData.stableDebtTokenAddress).getSupplyData();
      reserveData.totalScaledVariableDebt = IVariableDebtToken(reserveData.variableDebtTokenAddress)
        .scaledTotalSupply();

      

      
      reserveData.symbol = IERC20Detailed(reserveData.underlyingAsset).symbol();
      reserveData.name = "";

      (
        reserveData.baseLTVasCollateral,
        reserveData.reserveLiquidationThreshold,
        reserveData.reserveLiquidationBonus,
        reserveData.decimals,
        reserveData.reserveFactor
      ) = baseData.configuration.getParamsMemory();
      (
        reserveData.isActive,
        reserveData.isFrozen,
        reserveData.borrowingEnabled,
        reserveData.stableBorrowRateEnabled
      ) = baseData.configuration.getFlagsMemory();
      reserveData.usageAsCollateralEnabled = reserveData.baseLTVasCollateral != 0;
      (
        reserveData.variableRateSlope1,
        reserveData.variableRateSlope2,
        reserveData.stableRateSlope1,
        reserveData.stableRateSlope2
      ) = getInterestRateStrategySlopes(DefaultReserveInterestRateStrategy(reserveData.interestRateStrategyAddress));

      
      if (address(0) != address(incentivesController)) {
        (
          reserveData.aTokenIncentivesIndex,
          reserveData.aEmissionPerSecond,
          reserveData.aIncentivesLastUpdateTimestamp
        ) = incentivesController.getAssetData(reserveData.aTokenAddress);

        (
          reserveData.sTokenIncentivesIndex,
          reserveData.sEmissionPerSecond,
          reserveData.sIncentivesLastUpdateTimestamp
        ) = incentivesController.getAssetData(reserveData.stableDebtTokenAddress);

        (
          reserveData.vTokenIncentivesIndex,
          reserveData.vEmissionPerSecond,
          reserveData.vIncentivesLastUpdateTimestamp
        ) = incentivesController.getAssetData(reserveData.variableDebtTokenAddress);
      }
    }

    uint256 emissionEndTimestamp;
    if (address(0) != address(incentivesController)) {
      emissionEndTimestamp = incentivesController.DISTRIBUTION_END();
    }

    return (reservesData, oracle.getAssetPrice(MOCK_USD_ADDRESS), emissionEndTimestamp);
  }

  function getUserReservesData(ILendingPoolAddressesProvider provider, address user)
    external
    view
    override
    returns (UserReserveData[] memory, uint256)
  {
    ILendingPool lendingPool = ILendingPool(provider.getLendingPool());
    address[] memory reserves = lendingPool.getReservesList();
    DataTypes.UserConfigurationMap memory userConfig = lendingPool.getUserConfiguration(user);

    UserReserveData[] memory userReservesData = new UserReserveData[](user != address(0) ? reserves.length : 0);

    for (uint256 i = 0; i < reserves.length; i++) {
      DataTypes.ReserveData memory baseData = lendingPool.getReserveData(reserves[i]);
      
      if (address(0) != address(incentivesController)) {
        userReservesData[i].aTokenincentivesUserIndex = incentivesController.getUserAssetData(
          user,
          baseData.aTokenAddress
        );
        userReservesData[i].vTokenincentivesUserIndex = incentivesController.getUserAssetData(
          user,
          baseData.variableDebtTokenAddress
        );
        userReservesData[i].sTokenincentivesUserIndex = incentivesController.getUserAssetData(
          user,
          baseData.stableDebtTokenAddress
        );
      }
      
      userReservesData[i].underlyingAsset = reserves[i];
      userReservesData[i].scaledATokenBalance = IAToken(baseData.aTokenAddress).scaledBalanceOf(user);
      userReservesData[i].usageAsCollateralEnabledOnUser = userConfig.isUsingAsCollateral(i);

      if (userConfig.isBorrowing(i)) {
        userReservesData[i].scaledVariableDebt = IVariableDebtToken(baseData.variableDebtTokenAddress).scaledBalanceOf(
          user
        );
        userReservesData[i].principalStableDebt = IStableDebtToken(baseData.stableDebtTokenAddress).principalBalanceOf(
          user
        );
        if (userReservesData[i].principalStableDebt != 0) {
          userReservesData[i].stableBorrowRate = IStableDebtToken(baseData.stableDebtTokenAddress).getUserStableRate(
            user
          );
          userReservesData[i].stableBorrowLastUpdateTimestamp = IStableDebtToken(baseData.stableDebtTokenAddress)
            .getUserLastUpdated(user);
        }
      }
    }

    uint256 userUnclaimedRewards;
    if (address(0) != address(incentivesController)) {
      userUnclaimedRewards = incentivesController.getUserUnclaimedRewards(user);
    }

    return (userReservesData, userUnclaimedRewards);
  }

  function getReservesData(ILendingPoolAddressesProvider provider, address user)
    external
    view
    override
    returns (
      AggregatedReserveData[] memory,
      UserReserveData[] memory,
      uint256,
      IncentivesControllerData memory
    )
  {
    ILendingPool lendingPool = ILendingPool(provider.getLendingPool());
    address[] memory reserves = lendingPool.getReservesList();
    DataTypes.UserConfigurationMap memory userConfig = lendingPool.getUserConfiguration(user);

    AggregatedReserveData[] memory reservesData = new AggregatedReserveData[](reserves.length);
    UserReserveData[] memory userReservesData = new UserReserveData[](user != address(0) ? reserves.length : 0);

    for (uint256 i = 0; i < reserves.length; i++) {
      AggregatedReserveData memory reserveData = reservesData[i];
      reserveData.underlyingAsset = reserves[i];

      
      DataTypes.ReserveData memory baseData = lendingPool.getReserveData(reserveData.underlyingAsset);
      reserveData.liquidityIndex = baseData.liquidityIndex;
      reserveData.variableBorrowIndex = baseData.variableBorrowIndex;
      reserveData.liquidityRate = baseData.currentLiquidityRate;
      reserveData.variableBorrowRate = baseData.currentVariableBorrowRate;
      reserveData.stableBorrowRate = baseData.currentStableBorrowRate;
      reserveData.lastUpdateTimestamp = baseData.lastUpdateTimestamp;
      reserveData.aTokenAddress = baseData.aTokenAddress;
      reserveData.stableDebtTokenAddress = baseData.stableDebtTokenAddress;
      reserveData.variableDebtTokenAddress = baseData.variableDebtTokenAddress;
      reserveData.interestRateStrategyAddress = baseData.interestRateStrategyAddress;
      reserveData.priceInEth = oracle.getAssetPrice(reserveData.underlyingAsset);

      reserveData.availableLiquidity = IERC20Detailed(reserveData.underlyingAsset).balanceOf(reserveData.aTokenAddress);
      (
        reserveData.totalPrincipalStableDebt,
        ,
        reserveData.averageStableRate,
        reserveData.stableDebtLastUpdateTimestamp
      ) = IStableDebtToken(reserveData.stableDebtTokenAddress).getSupplyData();
      reserveData.totalScaledVariableDebt = IVariableDebtToken(reserveData.variableDebtTokenAddress)
        .scaledTotalSupply();

      

      
      reserveData.symbol = IERC20Detailed(reserveData.underlyingAsset).symbol();
      reserveData.name = "";

      (
        reserveData.baseLTVasCollateral,
        reserveData.reserveLiquidationThreshold,
        reserveData.reserveLiquidationBonus,
        reserveData.decimals,
        reserveData.reserveFactor
      ) = baseData.configuration.getParamsMemory();
      (
        reserveData.isActive,
        reserveData.isFrozen,
        reserveData.borrowingEnabled,
        reserveData.stableBorrowRateEnabled
      ) = baseData.configuration.getFlagsMemory();
      reserveData.usageAsCollateralEnabled = reserveData.baseLTVasCollateral != 0;
      (
        reserveData.variableRateSlope1,
        reserveData.variableRateSlope2,
        reserveData.stableRateSlope1,
        reserveData.stableRateSlope2
      ) = getInterestRateStrategySlopes(DefaultReserveInterestRateStrategy(reserveData.interestRateStrategyAddress));

      
      if (address(0) != address(incentivesController)) {
        (
          reserveData.aTokenIncentivesIndex,
          reserveData.aEmissionPerSecond,
          reserveData.aIncentivesLastUpdateTimestamp
        ) = incentivesController.getAssetData(reserveData.aTokenAddress);

        (
          reserveData.sTokenIncentivesIndex,
          reserveData.sEmissionPerSecond,
          reserveData.sIncentivesLastUpdateTimestamp
        ) = incentivesController.getAssetData(reserveData.stableDebtTokenAddress);

        (
          reserveData.vTokenIncentivesIndex,
          reserveData.vEmissionPerSecond,
          reserveData.vIncentivesLastUpdateTimestamp
        ) = incentivesController.getAssetData(reserveData.variableDebtTokenAddress);
      }

      if (user != address(0)) {
        
        if (address(0) != address(incentivesController)) {
          userReservesData[i].aTokenincentivesUserIndex = incentivesController.getUserAssetData(
            user,
            reserveData.aTokenAddress
          );
          userReservesData[i].vTokenincentivesUserIndex = incentivesController.getUserAssetData(
            user,
            reserveData.variableDebtTokenAddress
          );
          userReservesData[i].sTokenincentivesUserIndex = incentivesController.getUserAssetData(
            user,
            reserveData.stableDebtTokenAddress
          );
        }
        
        userReservesData[i].underlyingAsset = reserveData.underlyingAsset;
        userReservesData[i].scaledATokenBalance = IAToken(reserveData.aTokenAddress).scaledBalanceOf(user);
        userReservesData[i].usageAsCollateralEnabledOnUser = userConfig.isUsingAsCollateral(i);

        if (userConfig.isBorrowing(i)) {
          userReservesData[i].scaledVariableDebt = IVariableDebtToken(reserveData.variableDebtTokenAddress)
            .scaledBalanceOf(user);
          userReservesData[i].principalStableDebt = IStableDebtToken(reserveData.stableDebtTokenAddress)
            .principalBalanceOf(user);
          if (userReservesData[i].principalStableDebt != 0) {
            userReservesData[i].stableBorrowRate = IStableDebtToken(reserveData.stableDebtTokenAddress)
              .getUserStableRate(user);
            userReservesData[i].stableBorrowLastUpdateTimestamp = IStableDebtToken(reserveData.stableDebtTokenAddress)
              .getUserLastUpdated(user);
          }
        }
      }
    }

    IncentivesControllerData memory incentivesControllerData;

    if (address(0) != address(incentivesController)) {
      if (user != address(0)) {
        incentivesControllerData.userUnclaimedRewards = incentivesController.getUserUnclaimedRewards(user);
      }
      incentivesControllerData.emissionEndTimestamp = incentivesController.DISTRIBUTION_END();
    }

    return (reservesData, userReservesData, oracle.getAssetPrice(MOCK_USD_ADDRESS), incentivesControllerData);
  }
}