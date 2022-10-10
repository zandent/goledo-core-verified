pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;


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

library Address {
    
    function isContract(address account) internal view returns (bool) {
        
        
        

        uint256 size;
        
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            
            if (returndata.length > 0) {
                

                
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        
        
        
        
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        
        
        

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { 
            
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
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

interface IScaledBalanceToken {
  
  function scaledBalanceOf(address user) external view returns (uint256);

  
  function getScaledUserBalanceAndSupply(address user) external view returns (uint256, uint256);

  
  function scaledTotalSupply() external view returns (uint256);
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

interface IFlashLoanReceiver {
  function executeOperation(
    address[] calldata assets,
    uint256[] calldata amounts,
    uint256[] calldata premiums,
    address initiator,
    bytes calldata params
  ) external returns (bool);

  function ADDRESSES_PROVIDER() external view returns (ILendingPoolAddressesProvider);

  function LENDING_POOL() external view returns (ILendingPool);
}

interface IPriceOracleGetter {
  
  function getAssetPrice(address asset) external view returns (uint256);

  function updateAssetPrice(address asset) external returns (uint256);
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

abstract contract VersionedInitializable {
  
  uint256 private lastInitializedRevision = 0;

  
  bool private initializing;

  
  modifier initializer() {
    uint256 revision = getRevision();
    require(
      initializing || isConstructor() || revision > lastInitializedRevision,
      "Contract instance has already been initialized"
    );

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      lastInitializedRevision = revision;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  
  function getRevision() internal pure virtual returns (uint256);

  
  function isConstructor() private view returns (bool) {
    
    
    
    
    
    uint256 cs;
    
    assembly {
      cs := extcodesize(address())
    }
    return cs == 0;
  }

  
  uint256[50] private ______gap;
}

library Helpers {
  
  function getUserCurrentDebt(address user, DataTypes.ReserveData storage reserve)
    internal
    view
    returns (uint256, uint256)
  {
    return (
      IERC20(reserve.stableDebtTokenAddress).balanceOf(user),
      IERC20(reserve.variableDebtTokenAddress).balanceOf(user)
    );
  }

  function getUserCurrentDebtMemory(address user, DataTypes.ReserveData memory reserve)
    internal
    view
    returns (uint256, uint256)
  {
    return (
      IERC20(reserve.stableDebtTokenAddress).balanceOf(user),
      IERC20(reserve.variableDebtTokenAddress).balanceOf(user)
    );
  }
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

library MathUtils {
  using SafeMath for uint256;
  using WadRayMath for uint256;

  
  uint256 internal constant SECONDS_PER_YEAR = 365 days;

  

  function calculateLinearInterest(uint256 rate, uint40 lastUpdateTimestamp) internal view returns (uint256) {
    
    uint256 timeDifference = block.timestamp.sub(uint256(lastUpdateTimestamp));

    return (rate.mul(timeDifference) / SECONDS_PER_YEAR).add(WadRayMath.ray());
  }

  
  function calculateCompoundedInterest(
    uint256 rate,
    uint40 lastUpdateTimestamp,
    uint256 currentTimestamp
  ) internal pure returns (uint256) {
    
    uint256 exp = currentTimestamp.sub(uint256(lastUpdateTimestamp));

    if (exp == 0) {
      return WadRayMath.ray();
    }

    uint256 expMinusOne = exp - 1;

    uint256 expMinusTwo = exp > 2 ? exp - 2 : 0;

    uint256 ratePerSecond = rate / SECONDS_PER_YEAR;

    uint256 basePowerTwo = ratePerSecond.rayMul(ratePerSecond);
    uint256 basePowerThree = basePowerTwo.rayMul(ratePerSecond);

    uint256 secondTerm = exp.mul(expMinusOne).mul(basePowerTwo) / 2;
    uint256 thirdTerm = exp.mul(expMinusOne).mul(expMinusTwo).mul(basePowerThree) / 6;

    return WadRayMath.ray().add(ratePerSecond.mul(exp)).add(secondTerm).add(thirdTerm);
  }

  
  function calculateCompoundedInterest(uint256 rate, uint40 lastUpdateTimestamp) internal view returns (uint256) {
    return calculateCompoundedInterest(rate, lastUpdateTimestamp, block.timestamp);
  }
}

library ReserveLogic {
  using SafeMath for uint256;
  using WadRayMath for uint256;
  using PercentageMath for uint256;
  using SafeERC20 for IERC20;

  
  event ReserveDataUpdated(
    address indexed asset,
    uint256 liquidityRate,
    uint256 stableBorrowRate,
    uint256 variableBorrowRate,
    uint256 liquidityIndex,
    uint256 variableBorrowIndex
  );

  using ReserveLogic for DataTypes.ReserveData;
  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

  
  function getNormalizedIncome(DataTypes.ReserveData storage reserve) internal view returns (uint256) {
    uint40 timestamp = reserve.lastUpdateTimestamp;

    
    if (timestamp == uint40(block.timestamp)) {
      
      return reserve.liquidityIndex;
    }

    uint256 cumulated = MathUtils.calculateLinearInterest(reserve.currentLiquidityRate, timestamp).rayMul(
      reserve.liquidityIndex
    );

    return cumulated;
  }

  
  function getNormalizedDebt(DataTypes.ReserveData storage reserve) internal view returns (uint256) {
    uint40 timestamp = reserve.lastUpdateTimestamp;

    
    if (timestamp == uint40(block.timestamp)) {
      
      return reserve.variableBorrowIndex;
    }

    uint256 cumulated = MathUtils.calculateCompoundedInterest(reserve.currentVariableBorrowRate, timestamp).rayMul(
      reserve.variableBorrowIndex
    );

    return cumulated;
  }

  
  function updateState(DataTypes.ReserveData storage reserve) internal {
    uint256 scaledVariableDebt = IVariableDebtToken(reserve.variableDebtTokenAddress).scaledTotalSupply();
    uint256 previousVariableBorrowIndex = reserve.variableBorrowIndex;
    uint256 previousLiquidityIndex = reserve.liquidityIndex;
    uint40 lastUpdatedTimestamp = reserve.lastUpdateTimestamp;

    (uint256 newLiquidityIndex, uint256 newVariableBorrowIndex) = _updateIndexes(
      reserve,
      scaledVariableDebt,
      previousLiquidityIndex,
      previousVariableBorrowIndex,
      lastUpdatedTimestamp
    );

    _mintToTreasury(
      reserve,
      scaledVariableDebt,
      previousVariableBorrowIndex,
      newLiquidityIndex,
      newVariableBorrowIndex,
      lastUpdatedTimestamp
    );
  }

  
  function cumulateToLiquidityIndex(
    DataTypes.ReserveData storage reserve,
    uint256 totalLiquidity,
    uint256 amount
  ) internal {
    uint256 amountToLiquidityRatio = amount.wadToRay().rayDiv(totalLiquidity.wadToRay());

    uint256 result = amountToLiquidityRatio.add(WadRayMath.ray());

    result = result.rayMul(reserve.liquidityIndex);
    require(result <= type(uint128).max, Errors.RL_LIQUIDITY_INDEX_OVERFLOW);

    reserve.liquidityIndex = uint128(result);
  }

  
  function init(
    DataTypes.ReserveData storage reserve,
    address aTokenAddress,
    address stableDebtTokenAddress,
    address variableDebtTokenAddress,
    address interestRateStrategyAddress
  ) external {
    require(reserve.aTokenAddress == address(0), Errors.RL_RESERVE_ALREADY_INITIALIZED);

    reserve.liquidityIndex = uint128(WadRayMath.ray());
    reserve.variableBorrowIndex = uint128(WadRayMath.ray());
    reserve.aTokenAddress = aTokenAddress;
    reserve.stableDebtTokenAddress = stableDebtTokenAddress;
    reserve.variableDebtTokenAddress = variableDebtTokenAddress;
    reserve.interestRateStrategyAddress = interestRateStrategyAddress;
  }

  struct UpdateInterestRatesLocalVars {
    address stableDebtTokenAddress;
    uint256 availableLiquidity;
    uint256 totalStableDebt;
    uint256 newLiquidityRate;
    uint256 newStableRate;
    uint256 newVariableRate;
    uint256 avgStableRate;
    uint256 totalVariableDebt;
  }

  
  function updateInterestRates(
    DataTypes.ReserveData storage reserve,
    address reserveAddress,
    address aTokenAddress,
    uint256 liquidityAdded,
    uint256 liquidityTaken
  ) internal {
    UpdateInterestRatesLocalVars memory vars;

    vars.stableDebtTokenAddress = reserve.stableDebtTokenAddress;

    (vars.totalStableDebt, vars.avgStableRate) = IStableDebtToken(vars.stableDebtTokenAddress)
      .getTotalSupplyAndAvgRate();

    
    
    
    vars.totalVariableDebt = IVariableDebtToken(reserve.variableDebtTokenAddress).scaledTotalSupply().rayMul(
      reserve.variableBorrowIndex
    );

    (vars.newLiquidityRate, vars.newStableRate, vars.newVariableRate) = IReserveInterestRateStrategy(
      reserve.interestRateStrategyAddress
    ).calculateInterestRates(
        reserveAddress,
        aTokenAddress,
        liquidityAdded,
        liquidityTaken,
        vars.totalStableDebt,
        vars.totalVariableDebt,
        vars.avgStableRate,
        reserve.configuration.getReserveFactor()
      );
    require(vars.newLiquidityRate <= type(uint128).max, Errors.RL_LIQUIDITY_RATE_OVERFLOW);
    require(vars.newStableRate <= type(uint128).max, Errors.RL_STABLE_BORROW_RATE_OVERFLOW);
    require(vars.newVariableRate <= type(uint128).max, Errors.RL_VARIABLE_BORROW_RATE_OVERFLOW);

    reserve.currentLiquidityRate = uint128(vars.newLiquidityRate);
    reserve.currentStableBorrowRate = uint128(vars.newStableRate);
    reserve.currentVariableBorrowRate = uint128(vars.newVariableRate);

    emit ReserveDataUpdated(
      reserveAddress,
      vars.newLiquidityRate,
      vars.newStableRate,
      vars.newVariableRate,
      reserve.liquidityIndex,
      reserve.variableBorrowIndex
    );
  }

  struct MintToTreasuryLocalVars {
    uint256 currentStableDebt;
    uint256 principalStableDebt;
    uint256 previousStableDebt;
    uint256 currentVariableDebt;
    uint256 previousVariableDebt;
    uint256 avgStableRate;
    uint256 cumulatedStableInterest;
    uint256 totalDebtAccrued;
    uint256 amountToMint;
    uint256 reserveFactor;
    uint40 stableSupplyUpdatedTimestamp;
  }

  
  function _mintToTreasury(
    DataTypes.ReserveData storage reserve,
    uint256 scaledVariableDebt,
    uint256 previousVariableBorrowIndex,
    uint256 newLiquidityIndex,
    uint256 newVariableBorrowIndex,
    uint40 timestamp
  ) internal {
    MintToTreasuryLocalVars memory vars;

    vars.reserveFactor = reserve.configuration.getReserveFactor();

    if (vars.reserveFactor == 0) {
      return;
    }

    
    (
      vars.principalStableDebt,
      vars.currentStableDebt,
      vars.avgStableRate,
      vars.stableSupplyUpdatedTimestamp
    ) = IStableDebtToken(reserve.stableDebtTokenAddress).getSupplyData();

    
    vars.previousVariableDebt = scaledVariableDebt.rayMul(previousVariableBorrowIndex);

    
    vars.currentVariableDebt = scaledVariableDebt.rayMul(newVariableBorrowIndex);

    
    vars.cumulatedStableInterest = MathUtils.calculateCompoundedInterest(
      vars.avgStableRate,
      vars.stableSupplyUpdatedTimestamp,
      timestamp
    );

    vars.previousStableDebt = vars.principalStableDebt.rayMul(vars.cumulatedStableInterest);

    
    vars.totalDebtAccrued = vars.currentVariableDebt.add(vars.currentStableDebt).sub(vars.previousVariableDebt).sub(
      vars.previousStableDebt
    );

    vars.amountToMint = vars.totalDebtAccrued.percentMul(vars.reserveFactor);

    if (vars.amountToMint != 0) {
      IAToken(reserve.aTokenAddress).mintToTreasury(vars.amountToMint, newLiquidityIndex);
    }
  }

  
  function _updateIndexes(
    DataTypes.ReserveData storage reserve,
    uint256 scaledVariableDebt,
    uint256 liquidityIndex,
    uint256 variableBorrowIndex,
    uint40 timestamp
  ) internal returns (uint256, uint256) {
    uint256 currentLiquidityRate = reserve.currentLiquidityRate;

    uint256 newLiquidityIndex = liquidityIndex;
    uint256 newVariableBorrowIndex = variableBorrowIndex;

    
    if (currentLiquidityRate > 0) {
      uint256 cumulatedLiquidityInterest = MathUtils.calculateLinearInterest(currentLiquidityRate, timestamp);
      newLiquidityIndex = cumulatedLiquidityInterest.rayMul(liquidityIndex);
      require(newLiquidityIndex <= type(uint128).max, Errors.RL_LIQUIDITY_INDEX_OVERFLOW);

      reserve.liquidityIndex = uint128(newLiquidityIndex);

      
      
      if (scaledVariableDebt != 0) {
        uint256 cumulatedVariableBorrowInterest = MathUtils.calculateCompoundedInterest(
          reserve.currentVariableBorrowRate,
          timestamp
        );
        newVariableBorrowIndex = cumulatedVariableBorrowInterest.rayMul(variableBorrowIndex);
        require(newVariableBorrowIndex <= type(uint128).max, Errors.RL_VARIABLE_BORROW_INDEX_OVERFLOW);
        reserve.variableBorrowIndex = uint128(newVariableBorrowIndex);
      }
    }

    
    reserve.lastUpdateTimestamp = uint40(block.timestamp);
    return (newLiquidityIndex, newVariableBorrowIndex);
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

library GenericLogic {
  using ReserveLogic for DataTypes.ReserveData;
  using SafeMath for uint256;
  using WadRayMath for uint256;
  using PercentageMath for uint256;
  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
  using UserConfiguration for DataTypes.UserConfigurationMap;

  uint256 public constant HEALTH_FACTOR_LIQUIDATION_THRESHOLD = 1 ether;

  struct balanceDecreaseAllowedLocalVars {
    uint256 decimals;
    uint256 liquidationThreshold;
    uint256 totalCollateralInETH;
    uint256 totalDebtInETH;
    uint256 avgLiquidationThreshold;
    uint256 amountToDecreaseInETH;
    uint256 collateralBalanceAfterDecrease;
    uint256 liquidationThresholdAfterDecrease;
    uint256 healthFactorAfterDecrease;
    bool reserveUsageAsCollateralEnabled;
  }

  
  function balanceDecreaseAllowed(
    address asset,
    address user,
    uint256 amount,
    mapping(address => DataTypes.ReserveData) storage reservesData,
    DataTypes.UserConfigurationMap calldata userConfig,
    mapping(uint256 => address) storage reserves,
    uint256 reservesCount,
    address oracle
  ) external view returns (bool) {
    if (!userConfig.isBorrowingAny() || !userConfig.isUsingAsCollateral(reservesData[asset].id)) {
      return true;
    }

    balanceDecreaseAllowedLocalVars memory vars;

    (, vars.liquidationThreshold, , vars.decimals, ) = reservesData[asset].configuration.getParams();

    if (vars.liquidationThreshold == 0) {
      return true;
    }

    (vars.totalCollateralInETH, vars.totalDebtInETH, , vars.avgLiquidationThreshold, ) = calculateUserAccountData(
      user,
      reservesData,
      userConfig,
      reserves,
      reservesCount,
      oracle
    );

    if (vars.totalDebtInETH == 0) {
      return true;
    }

    vars.amountToDecreaseInETH = IPriceOracleGetter(oracle).getAssetPrice(asset).mul(amount).div(10**vars.decimals);

    vars.collateralBalanceAfterDecrease = vars.totalCollateralInETH.sub(vars.amountToDecreaseInETH);

    
    if (vars.collateralBalanceAfterDecrease == 0) {
      return false;
    }

    vars.liquidationThresholdAfterDecrease = vars
      .totalCollateralInETH
      .mul(vars.avgLiquidationThreshold)
      .sub(vars.amountToDecreaseInETH.mul(vars.liquidationThreshold))
      .div(vars.collateralBalanceAfterDecrease);

    uint256 healthFactorAfterDecrease = calculateHealthFactorFromBalances(
      vars.collateralBalanceAfterDecrease,
      vars.totalDebtInETH,
      vars.liquidationThresholdAfterDecrease
    );

    return healthFactorAfterDecrease >= GenericLogic.HEALTH_FACTOR_LIQUIDATION_THRESHOLD;
  }

  struct CalculateUserAccountDataVars {
    uint256 reserveUnitPrice;
    uint256 tokenUnit;
    uint256 compoundedLiquidityBalance;
    uint256 compoundedBorrowBalance;
    uint256 decimals;
    uint256 ltv;
    uint256 liquidationThreshold;
    uint256 i;
    uint256 healthFactor;
    uint256 totalCollateralInETH;
    uint256 totalDebtInETH;
    uint256 avgLtv;
    uint256 avgLiquidationThreshold;
    uint256 reservesLength;
    bool healthFactorBelowThreshold;
    address currentReserveAddress;
    bool usageAsCollateralEnabled;
    bool userUsesReserveAsCollateral;
  }

  
  function calculateUserAccountData(
    address user,
    mapping(address => DataTypes.ReserveData) storage reservesData,
    DataTypes.UserConfigurationMap memory userConfig,
    mapping(uint256 => address) storage reserves,
    uint256 reservesCount,
    address oracle
  )
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
    CalculateUserAccountDataVars memory vars;

    if (userConfig.isEmpty()) {
      return (0, 0, 0, 0, uint256(-1));
    }
    for (vars.i = 0; vars.i < reservesCount; vars.i++) {
      if (!userConfig.isUsingAsCollateralOrBorrowing(vars.i)) {
        continue;
      }

      vars.currentReserveAddress = reserves[vars.i];
      DataTypes.ReserveData storage currentReserve = reservesData[vars.currentReserveAddress];

      (vars.ltv, vars.liquidationThreshold, , vars.decimals, ) = currentReserve.configuration.getParams();

      vars.tokenUnit = 10**vars.decimals;
      vars.reserveUnitPrice = IPriceOracleGetter(oracle).getAssetPrice(vars.currentReserveAddress);

      if (vars.liquidationThreshold != 0 && userConfig.isUsingAsCollateral(vars.i)) {
        vars.compoundedLiquidityBalance = IERC20(currentReserve.aTokenAddress).balanceOf(user);

        uint256 liquidityBalanceETH = vars.reserveUnitPrice.mul(vars.compoundedLiquidityBalance).div(vars.tokenUnit);

        vars.totalCollateralInETH = vars.totalCollateralInETH.add(liquidityBalanceETH);

        vars.avgLtv = vars.avgLtv.add(liquidityBalanceETH.mul(vars.ltv));
        vars.avgLiquidationThreshold = vars.avgLiquidationThreshold.add(
          liquidityBalanceETH.mul(vars.liquidationThreshold)
        );
      }

      if (userConfig.isBorrowing(vars.i)) {
        vars.compoundedBorrowBalance = IERC20(currentReserve.stableDebtTokenAddress).balanceOf(user);
        vars.compoundedBorrowBalance = vars.compoundedBorrowBalance.add(
          IERC20(currentReserve.variableDebtTokenAddress).balanceOf(user)
        );

        vars.totalDebtInETH = vars.totalDebtInETH.add(
          vars.reserveUnitPrice.mul(vars.compoundedBorrowBalance).div(vars.tokenUnit)
        );
      }
    }

    vars.avgLtv = vars.totalCollateralInETH > 0 ? vars.avgLtv.div(vars.totalCollateralInETH) : 0;
    vars.avgLiquidationThreshold = vars.totalCollateralInETH > 0
      ? vars.avgLiquidationThreshold.div(vars.totalCollateralInETH)
      : 0;

    vars.healthFactor = calculateHealthFactorFromBalances(
      vars.totalCollateralInETH,
      vars.totalDebtInETH,
      vars.avgLiquidationThreshold
    );
    return (
      vars.totalCollateralInETH,
      vars.totalDebtInETH,
      vars.avgLtv,
      vars.avgLiquidationThreshold,
      vars.healthFactor
    );
  }

  
  function calculateHealthFactorFromBalances(
    uint256 totalCollateralInETH,
    uint256 totalDebtInETH,
    uint256 liquidationThreshold
  ) internal pure returns (uint256) {
    if (totalDebtInETH == 0) return uint256(-1);

    return (totalCollateralInETH.percentMul(liquidationThreshold)).wadDiv(totalDebtInETH);
  }

  

  function calculateAvailableBorrowsETH(
    uint256 totalCollateralInETH,
    uint256 totalDebtInETH,
    uint256 ltv
  ) internal pure returns (uint256) {
    uint256 availableBorrowsETH = totalCollateralInETH.percentMul(ltv);

    if (availableBorrowsETH < totalDebtInETH) {
      return 0;
    }

    availableBorrowsETH = availableBorrowsETH.sub(totalDebtInETH);
    return availableBorrowsETH;
  }
}

library ValidationLogic {
  using ReserveLogic for DataTypes.ReserveData;
  using SafeMath for uint256;
  using WadRayMath for uint256;
  using PercentageMath for uint256;
  using SafeERC20 for IERC20;
  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
  using UserConfiguration for DataTypes.UserConfigurationMap;

  uint256 public constant REBALANCE_UP_LIQUIDITY_RATE_THRESHOLD = 4000;
  uint256 public constant REBALANCE_UP_USAGE_RATIO_THRESHOLD = 0.95 * 1e27; 

  
  function validateDeposit(DataTypes.ReserveData storage reserve, uint256 amount) external view {
    (bool isActive, bool isFrozen, , ) = reserve.configuration.getFlags();

    require(amount != 0, Errors.VL_INVALID_AMOUNT);
    require(isActive, Errors.VL_NO_ACTIVE_RESERVE);
    require(!isFrozen, Errors.VL_RESERVE_FROZEN);
  }

  
  function validateWithdraw(
    address reserveAddress,
    uint256 amount,
    uint256 userBalance,
    mapping(address => DataTypes.ReserveData) storage reservesData,
    DataTypes.UserConfigurationMap storage userConfig,
    mapping(uint256 => address) storage reserves,
    uint256 reservesCount,
    address oracle
  ) external view {
    require(amount != 0, Errors.VL_INVALID_AMOUNT);
    require(amount <= userBalance, Errors.VL_NOT_ENOUGH_AVAILABLE_USER_BALANCE);

    (bool isActive, , , ) = reservesData[reserveAddress].configuration.getFlags();
    require(isActive, Errors.VL_NO_ACTIVE_RESERVE);

    require(
      GenericLogic.balanceDecreaseAllowed(
        reserveAddress,
        msg.sender,
        amount,
        reservesData,
        userConfig,
        reserves,
        reservesCount,
        oracle
      ),
      Errors.VL_TRANSFER_NOT_ALLOWED
    );
  }

  struct ValidateBorrowLocalVars {
    uint256 currentLtv;
    uint256 currentLiquidationThreshold;
    uint256 amountOfCollateralNeededETH;
    uint256 userCollateralBalanceETH;
    uint256 userBorrowBalanceETH;
    uint256 availableLiquidity;
    uint256 healthFactor;
    bool isActive;
    bool isFrozen;
    bool borrowingEnabled;
    bool stableRateBorrowingEnabled;
  }

  

  function validateBorrow(
    address asset,
    DataTypes.ReserveData storage reserve,
    address userAddress,
    uint256 amount,
    uint256 amountInETH,
    uint256 interestRateMode,
    uint256 maxStableLoanPercent,
    mapping(address => DataTypes.ReserveData) storage reservesData,
    DataTypes.UserConfigurationMap storage userConfig,
    mapping(uint256 => address) storage reserves,
    uint256 reservesCount,
    address oracle
  ) external view {
    ValidateBorrowLocalVars memory vars;

    (vars.isActive, vars.isFrozen, vars.borrowingEnabled, vars.stableRateBorrowingEnabled) = reserve
      .configuration
      .getFlags();

    require(vars.isActive, Errors.VL_NO_ACTIVE_RESERVE);
    require(!vars.isFrozen, Errors.VL_RESERVE_FROZEN);
    require(amount != 0, Errors.VL_INVALID_AMOUNT);

    require(vars.borrowingEnabled, Errors.VL_BORROWING_NOT_ENABLED);

    
    require(
      uint256(DataTypes.InterestRateMode.VARIABLE) == interestRateMode ||
        uint256(DataTypes.InterestRateMode.STABLE) == interestRateMode,
      Errors.VL_INVALID_INTEREST_RATE_MODE_SELECTED
    );

    (
      vars.userCollateralBalanceETH,
      vars.userBorrowBalanceETH,
      vars.currentLtv,
      vars.currentLiquidationThreshold,
      vars.healthFactor
    ) = GenericLogic.calculateUserAccountData(userAddress, reservesData, userConfig, reserves, reservesCount, oracle);

    require(vars.userCollateralBalanceETH > 0, Errors.VL_COLLATERAL_BALANCE_IS_0);

    require(
      vars.healthFactor > GenericLogic.HEALTH_FACTOR_LIQUIDATION_THRESHOLD,
      Errors.VL_HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD
    );

    
    vars.amountOfCollateralNeededETH = vars.userBorrowBalanceETH.add(amountInETH).percentDiv(vars.currentLtv); 

    require(
      vars.amountOfCollateralNeededETH <= vars.userCollateralBalanceETH,
      Errors.VL_COLLATERAL_CANNOT_COVER_NEW_BORROW
    );

    

    if (interestRateMode == uint256(DataTypes.InterestRateMode.STABLE)) {
      

      require(vars.stableRateBorrowingEnabled, Errors.VL_STABLE_BORROWING_NOT_ENABLED);

      require(
        !userConfig.isUsingAsCollateral(reserve.id) ||
          reserve.configuration.getLtv() == 0 ||
          amount > IERC20(reserve.aTokenAddress).balanceOf(userAddress),
        Errors.VL_COLLATERAL_SAME_AS_BORROWING_CURRENCY
      );

      vars.availableLiquidity = IERC20(asset).balanceOf(reserve.aTokenAddress);

      
      
      uint256 maxLoanSizeStable = vars.availableLiquidity.percentMul(maxStableLoanPercent);

      require(amount <= maxLoanSizeStable, Errors.VL_AMOUNT_BIGGER_THAN_MAX_LOAN_SIZE_STABLE);
    }
  }

  
  function validateRepay(
    DataTypes.ReserveData storage reserve,
    uint256 amountSent,
    DataTypes.InterestRateMode rateMode,
    address onBehalfOf,
    uint256 stableDebt,
    uint256 variableDebt
  ) external view {
    bool isActive = reserve.configuration.getActive();

    require(isActive, Errors.VL_NO_ACTIVE_RESERVE);

    require(amountSent > 0, Errors.VL_INVALID_AMOUNT);

    require(
      (stableDebt > 0 && DataTypes.InterestRateMode(rateMode) == DataTypes.InterestRateMode.STABLE) ||
        (variableDebt > 0 && DataTypes.InterestRateMode(rateMode) == DataTypes.InterestRateMode.VARIABLE),
      Errors.VL_NO_DEBT_OF_SELECTED_TYPE
    );

    require(amountSent != uint256(-1) || msg.sender == onBehalfOf, Errors.VL_NO_EXPLICIT_AMOUNT_TO_REPAY_ON_BEHALF);
  }

  
  function validateSwapRateMode(
    DataTypes.ReserveData storage reserve,
    DataTypes.UserConfigurationMap storage userConfig,
    uint256 stableDebt,
    uint256 variableDebt,
    DataTypes.InterestRateMode currentRateMode
  ) external view {
    (bool isActive, bool isFrozen, , bool stableRateEnabled) = reserve.configuration.getFlags();

    require(isActive, Errors.VL_NO_ACTIVE_RESERVE);
    require(!isFrozen, Errors.VL_RESERVE_FROZEN);

    if (currentRateMode == DataTypes.InterestRateMode.STABLE) {
      require(stableDebt > 0, Errors.VL_NO_STABLE_RATE_LOAN_IN_RESERVE);
    } else if (currentRateMode == DataTypes.InterestRateMode.VARIABLE) {
      require(variableDebt > 0, Errors.VL_NO_VARIABLE_RATE_LOAN_IN_RESERVE);
      
      require(stableRateEnabled, Errors.VL_STABLE_BORROWING_NOT_ENABLED);

      require(
        !userConfig.isUsingAsCollateral(reserve.id) ||
          reserve.configuration.getLtv() == 0 ||
          stableDebt.add(variableDebt) > IERC20(reserve.aTokenAddress).balanceOf(msg.sender),
        Errors.VL_COLLATERAL_SAME_AS_BORROWING_CURRENCY
      );
    } else {
      revert(Errors.VL_INVALID_INTEREST_RATE_MODE_SELECTED);
    }
  }

  
  function validateRebalanceStableBorrowRate(
    DataTypes.ReserveData storage reserve,
    address reserveAddress,
    IERC20 stableDebtToken,
    IERC20 variableDebtToken,
    address aTokenAddress
  ) external view {
    (bool isActive, , , ) = reserve.configuration.getFlags();

    require(isActive, Errors.VL_NO_ACTIVE_RESERVE);

    
    uint256 totalDebt = stableDebtToken.totalSupply().add(variableDebtToken.totalSupply()).wadToRay();
    uint256 availableLiquidity = IERC20(reserveAddress).balanceOf(aTokenAddress).wadToRay();
    uint256 usageRatio = totalDebt == 0 ? 0 : totalDebt.rayDiv(availableLiquidity.add(totalDebt));

    
    

    uint256 currentLiquidityRate = reserve.currentLiquidityRate;
    uint256 maxVariableBorrowRate = IReserveInterestRateStrategy(reserve.interestRateStrategyAddress)
      .getMaxVariableBorrowRate();

    require(
      usageRatio >= REBALANCE_UP_USAGE_RATIO_THRESHOLD &&
        currentLiquidityRate <= maxVariableBorrowRate.percentMul(REBALANCE_UP_LIQUIDITY_RATE_THRESHOLD),
      Errors.LP_INTEREST_RATE_REBALANCE_CONDITIONS_NOT_MET
    );
  }

  
  function validateSetUseReserveAsCollateral(
    DataTypes.ReserveData storage reserve,
    address reserveAddress,
    bool useAsCollateral,
    mapping(address => DataTypes.ReserveData) storage reservesData,
    DataTypes.UserConfigurationMap storage userConfig,
    mapping(uint256 => address) storage reserves,
    uint256 reservesCount,
    address oracle
  ) external view {
    uint256 underlyingBalance = IERC20(reserve.aTokenAddress).balanceOf(msg.sender);

    require(underlyingBalance > 0, Errors.VL_UNDERLYING_BALANCE_NOT_GREATER_THAN_0);

    require(
      useAsCollateral ||
        GenericLogic.balanceDecreaseAllowed(
          reserveAddress,
          msg.sender,
          underlyingBalance,
          reservesData,
          userConfig,
          reserves,
          reservesCount,
          oracle
        ),
      Errors.VL_DEPOSIT_ALREADY_IN_USE
    );
  }

  
  function validateFlashloan(address[] memory assets, uint256[] memory amounts) internal pure {
    require(assets.length == amounts.length, Errors.VL_INCONSISTENT_FLASHLOAN_PARAMS);
  }

  
  function validateLiquidationCall(
    DataTypes.ReserveData storage collateralReserve,
    DataTypes.ReserveData storage principalReserve,
    DataTypes.UserConfigurationMap storage userConfig,
    uint256 userHealthFactor,
    uint256 userStableDebt,
    uint256 userVariableDebt
  ) internal view returns (uint256, string memory) {
    if (!collateralReserve.configuration.getActive() || !principalReserve.configuration.getActive()) {
      return (uint256(Errors.CollateralManagerErrors.NO_ACTIVE_RESERVE), Errors.VL_NO_ACTIVE_RESERVE);
    }

    if (userHealthFactor >= GenericLogic.HEALTH_FACTOR_LIQUIDATION_THRESHOLD) {
      return (
        uint256(Errors.CollateralManagerErrors.HEALTH_FACTOR_ABOVE_THRESHOLD),
        Errors.LPCM_HEALTH_FACTOR_NOT_BELOW_THRESHOLD
      );
    }

    bool isCollateralEnabled = collateralReserve.configuration.getLiquidationThreshold() > 0 &&
      userConfig.isUsingAsCollateral(collateralReserve.id);

    
    if (!isCollateralEnabled) {
      return (
        uint256(Errors.CollateralManagerErrors.COLLATERAL_CANNOT_BE_LIQUIDATED),
        Errors.LPCM_COLLATERAL_CANNOT_BE_LIQUIDATED
      );
    }

    if (userStableDebt == 0 && userVariableDebt == 0) {
      return (
        uint256(Errors.CollateralManagerErrors.CURRRENCY_NOT_BORROWED),
        Errors.LPCM_SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER
      );
    }

    return (uint256(Errors.CollateralManagerErrors.NO_ERROR), Errors.LPCM_NO_ERRORS);
  }

  
  function validateTransfer(
    address from,
    mapping(address => DataTypes.ReserveData) storage reservesData,
    DataTypes.UserConfigurationMap storage userConfig,
    mapping(uint256 => address) storage reserves,
    uint256 reservesCount,
    address oracle
  ) internal view {
    (, , , , uint256 healthFactor) = GenericLogic.calculateUserAccountData(
      from,
      reservesData,
      userConfig,
      reserves,
      reservesCount,
      oracle
    );

    require(healthFactor >= GenericLogic.HEALTH_FACTOR_LIQUIDATION_THRESHOLD, Errors.VL_TRANSFER_NOT_ALLOWED);
  }
}

contract LendingPoolStorage {
  using ReserveLogic for DataTypes.ReserveData;
  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
  using UserConfiguration for DataTypes.UserConfigurationMap;

  ILendingPoolAddressesProvider internal _addressesProvider;

  mapping(address => DataTypes.ReserveData) internal _reserves;
  mapping(address => DataTypes.UserConfigurationMap) internal _usersConfig;

  
  mapping(uint256 => address) internal _reservesList;

  uint256 internal _reservesCount;

  bool internal _paused;

  uint256 internal _maxStableRateBorrowSizePercent;

  uint256 internal _flashLoanPremiumTotal;

  uint256 internal _maxNumberOfReserves;
}

contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage {
  using SafeMath for uint256;
  using WadRayMath for uint256;
  using PercentageMath for uint256;
  using SafeERC20 for IERC20;
  using ReserveLogic for DataTypes.ReserveData;
  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
  using UserConfiguration for DataTypes.UserConfigurationMap;

  uint256 public constant LENDINGPOOL_REVISION = 0x2;

  modifier whenNotPaused() {
    _whenNotPaused();
    _;
  }

  modifier onlyLendingPoolConfigurator() {
    _onlyLendingPoolConfigurator();
    _;
  }

  function _whenNotPaused() internal view {
    require(!_paused, Errors.LP_IS_PAUSED);
  }

  function _onlyLendingPoolConfigurator() internal view {
    require(
      _addressesProvider.getLendingPoolConfigurator() == msg.sender,
      Errors.LP_CALLER_NOT_LENDING_POOL_CONFIGURATOR
    );
  }

  function getRevision() internal pure override returns (uint256) {
    return LENDINGPOOL_REVISION;
  }

  
  function initialize(ILendingPoolAddressesProvider provider) public initializer {
    _addressesProvider = provider;
    _maxStableRateBorrowSizePercent = 2500;
    _flashLoanPremiumTotal = 9;
    _maxNumberOfReserves = 128;
  }

  
  function deposit(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode
  ) external override whenNotPaused {
    DataTypes.ReserveData storage reserve = _reserves[asset];

    ValidationLogic.validateDeposit(reserve, amount);

    address aToken = reserve.aTokenAddress;

    reserve.updateState();
    reserve.updateInterestRates(asset, aToken, amount, 0);

    IERC20(asset).safeTransferFrom(msg.sender, aToken, amount);

    bool isFirstDeposit = IAToken(aToken).mint(onBehalfOf, amount, reserve.liquidityIndex);

    if (isFirstDeposit) {
      _usersConfig[onBehalfOf].setUsingAsCollateral(reserve.id, true);
      emit ReserveUsedAsCollateralEnabled(asset, onBehalfOf);
    }

    emit Deposit(asset, msg.sender, onBehalfOf, amount, referralCode);
  }

  
  function withdraw(
    address asset,
    uint256 amount,
    address to
  ) external override whenNotPaused returns (uint256) {
    DataTypes.ReserveData storage reserve = _reserves[asset];

    address aToken = reserve.aTokenAddress;

    uint256 userBalance = IAToken(aToken).balanceOf(msg.sender);

    uint256 amountToWithdraw = amount;

    if (amount == type(uint256).max) {
      amountToWithdraw = userBalance;
    }

    ValidationLogic.validateWithdraw(
      asset,
      amountToWithdraw,
      userBalance,
      _reserves,
      _usersConfig[msg.sender],
      _reservesList,
      _reservesCount,
      _addressesProvider.getPriceOracle()
    );

    reserve.updateState();

    reserve.updateInterestRates(asset, aToken, 0, amountToWithdraw);

    if (amountToWithdraw == userBalance) {
      _usersConfig[msg.sender].setUsingAsCollateral(reserve.id, false);
      emit ReserveUsedAsCollateralDisabled(asset, msg.sender);
    }

    IAToken(aToken).burn(msg.sender, to, amountToWithdraw, reserve.liquidityIndex);

    emit Withdraw(asset, msg.sender, to, amountToWithdraw);

    return amountToWithdraw;
  }

  
  function borrow(
    address asset,
    uint256 amount,
    uint256 interestRateMode,
    uint16 referralCode,
    address onBehalfOf
  ) external override whenNotPaused {
    DataTypes.ReserveData storage reserve = _reserves[asset];

    _executeBorrow(
      ExecuteBorrowParams(
        asset,
        msg.sender,
        onBehalfOf,
        amount,
        interestRateMode,
        reserve.aTokenAddress,
        referralCode,
        true
      )
    );
  }

  
  function repay(
    address asset,
    uint256 amount,
    uint256 rateMode,
    address onBehalfOf
  ) external override whenNotPaused returns (uint256) {
    DataTypes.ReserveData storage reserve = _reserves[asset];

    (uint256 stableDebt, uint256 variableDebt) = Helpers.getUserCurrentDebt(onBehalfOf, reserve);

    DataTypes.InterestRateMode interestRateMode = DataTypes.InterestRateMode(rateMode);

    ValidationLogic.validateRepay(reserve, amount, interestRateMode, onBehalfOf, stableDebt, variableDebt);

    uint256 paybackAmount = interestRateMode == DataTypes.InterestRateMode.STABLE ? stableDebt : variableDebt;

    if (amount < paybackAmount) {
      paybackAmount = amount;
    }

    reserve.updateState();

    if (interestRateMode == DataTypes.InterestRateMode.STABLE) {
      IStableDebtToken(reserve.stableDebtTokenAddress).burn(onBehalfOf, paybackAmount);
    } else {
      IVariableDebtToken(reserve.variableDebtTokenAddress).burn(onBehalfOf, paybackAmount, reserve.variableBorrowIndex);
    }

    address aToken = reserve.aTokenAddress;
    reserve.updateInterestRates(asset, aToken, paybackAmount, 0);

    if (stableDebt.add(variableDebt).sub(paybackAmount) == 0) {
      _usersConfig[onBehalfOf].setBorrowing(reserve.id, false);
    }

    IERC20(asset).safeTransferFrom(msg.sender, aToken, paybackAmount);

    IAToken(aToken).handleRepayment(msg.sender, paybackAmount);

    emit Repay(asset, onBehalfOf, msg.sender, paybackAmount);

    return paybackAmount;
  }

  
  function swapBorrowRateMode(address asset, uint256 rateMode) external override whenNotPaused {
    DataTypes.ReserveData storage reserve = _reserves[asset];

    (uint256 stableDebt, uint256 variableDebt) = Helpers.getUserCurrentDebt(msg.sender, reserve);

    DataTypes.InterestRateMode interestRateMode = DataTypes.InterestRateMode(rateMode);

    ValidationLogic.validateSwapRateMode(reserve, _usersConfig[msg.sender], stableDebt, variableDebt, interestRateMode);

    reserve.updateState();

    if (interestRateMode == DataTypes.InterestRateMode.STABLE) {
      IStableDebtToken(reserve.stableDebtTokenAddress).burn(msg.sender, stableDebt);
      IVariableDebtToken(reserve.variableDebtTokenAddress).mint(
        msg.sender,
        msg.sender,
        stableDebt,
        reserve.variableBorrowIndex
      );
    } else {
      IVariableDebtToken(reserve.variableDebtTokenAddress).burn(msg.sender, variableDebt, reserve.variableBorrowIndex);
      IStableDebtToken(reserve.stableDebtTokenAddress).mint(
        msg.sender,
        msg.sender,
        variableDebt,
        reserve.currentStableBorrowRate
      );
    }

    reserve.updateInterestRates(asset, reserve.aTokenAddress, 0, 0);

    emit Swap(asset, msg.sender, rateMode);
  }

  
  function rebalanceStableBorrowRate(address asset, address user) external override whenNotPaused {
    DataTypes.ReserveData storage reserve = _reserves[asset];

    IERC20 stableDebtToken = IERC20(reserve.stableDebtTokenAddress);
    IERC20 variableDebtToken = IERC20(reserve.variableDebtTokenAddress);
    address aTokenAddress = reserve.aTokenAddress;

    uint256 stableDebt = IERC20(stableDebtToken).balanceOf(user);

    ValidationLogic.validateRebalanceStableBorrowRate(
      reserve,
      asset,
      stableDebtToken,
      variableDebtToken,
      aTokenAddress
    );

    reserve.updateState();

    IStableDebtToken(address(stableDebtToken)).burn(user, stableDebt);
    IStableDebtToken(address(stableDebtToken)).mint(user, user, stableDebt, reserve.currentStableBorrowRate);

    reserve.updateInterestRates(asset, aTokenAddress, 0, 0);

    emit RebalanceStableBorrowRate(asset, user);
  }

  
  function setUserUseReserveAsCollateral(address asset, bool useAsCollateral) external override whenNotPaused {
    DataTypes.ReserveData storage reserve = _reserves[asset];

    ValidationLogic.validateSetUseReserveAsCollateral(
      reserve,
      asset,
      useAsCollateral,
      _reserves,
      _usersConfig[msg.sender],
      _reservesList,
      _reservesCount,
      _addressesProvider.getPriceOracle()
    );

    _usersConfig[msg.sender].setUsingAsCollateral(reserve.id, useAsCollateral);

    if (useAsCollateral) {
      emit ReserveUsedAsCollateralEnabled(asset, msg.sender);
    } else {
      emit ReserveUsedAsCollateralDisabled(asset, msg.sender);
    }
  }

  
  function liquidationCall(
    address collateralAsset,
    address debtAsset,
    address user,
    uint256 debtToCover,
    bool receiveAToken
  ) external override whenNotPaused {
    address collateralManager = _addressesProvider.getLendingPoolCollateralManager();

    
    (bool success, bytes memory result) = collateralManager.delegatecall(
      abi.encodeWithSignature(
        "liquidationCall(address,address,address,uint256,bool)",
        collateralAsset,
        debtAsset,
        user,
        debtToCover,
        receiveAToken
      )
    );

    require(success, Errors.LP_LIQUIDATION_CALL_FAILED);

    (uint256 returnCode, string memory returnMessage) = abi.decode(result, (uint256, string));

    require(returnCode == 0, string(abi.encodePacked(returnMessage)));
  }

  struct FlashLoanLocalVars {
    IFlashLoanReceiver receiver;
    address oracle;
    uint256 i;
    address currentAsset;
    address currentATokenAddress;
    uint256 currentAmount;
    uint256 currentPremium;
    uint256 currentAmountPlusPremium;
    address debtToken;
  }

  
  function flashLoan(
    address receiverAddress,
    address[] calldata assets,
    uint256[] calldata amounts,
    uint256[] calldata modes,
    address onBehalfOf,
    bytes calldata params,
    uint16 referralCode
  ) external override whenNotPaused {
    FlashLoanLocalVars memory vars;

    ValidationLogic.validateFlashloan(assets, amounts);

    address[] memory aTokenAddresses = new address[](assets.length);
    uint256[] memory premiums = new uint256[](assets.length);

    vars.receiver = IFlashLoanReceiver(receiverAddress);

    for (vars.i = 0; vars.i < assets.length; vars.i++) {
      aTokenAddresses[vars.i] = _reserves[assets[vars.i]].aTokenAddress;

      premiums[vars.i] = amounts[vars.i].mul(_flashLoanPremiumTotal).div(10000);

      IAToken(aTokenAddresses[vars.i]).transferUnderlyingTo(receiverAddress, amounts[vars.i]);
    }

    require(
      vars.receiver.executeOperation(assets, amounts, premiums, msg.sender, params),
      Errors.LP_INVALID_FLASH_LOAN_EXECUTOR_RETURN
    );

    for (vars.i = 0; vars.i < assets.length; vars.i++) {
      vars.currentAsset = assets[vars.i];
      vars.currentAmount = amounts[vars.i];
      vars.currentPremium = premiums[vars.i];
      vars.currentATokenAddress = aTokenAddresses[vars.i];
      vars.currentAmountPlusPremium = vars.currentAmount.add(vars.currentPremium);

      if (DataTypes.InterestRateMode(modes[vars.i]) == DataTypes.InterestRateMode.NONE) {
        _reserves[vars.currentAsset].updateState();
        _reserves[vars.currentAsset].cumulateToLiquidityIndex(
          IERC20(vars.currentATokenAddress).totalSupply(),
          vars.currentPremium
        );
        _reserves[vars.currentAsset].updateInterestRates(
          vars.currentAsset,
          vars.currentATokenAddress,
          vars.currentAmountPlusPremium,
          0
        );

        IERC20(vars.currentAsset).safeTransferFrom(
          receiverAddress,
          vars.currentATokenAddress,
          vars.currentAmountPlusPremium
        );
      } else {
        
        
        _executeBorrow(
          ExecuteBorrowParams(
            vars.currentAsset,
            msg.sender,
            onBehalfOf,
            vars.currentAmount,
            modes[vars.i],
            vars.currentATokenAddress,
            referralCode,
            false
          )
        );
      }
      emit FlashLoan(
        receiverAddress,
        msg.sender,
        vars.currentAsset,
        vars.currentAmount,
        vars.currentPremium,
        referralCode
      );
    }
  }

  
  function getReserveData(address asset) external view override returns (DataTypes.ReserveData memory) {
    return _reserves[asset];
  }

  
  function getUserAccountData(address user)
    external
    view
    override
    returns (
      uint256 totalCollateralETH,
      uint256 totalDebtETH,
      uint256 availableBorrowsETH,
      uint256 currentLiquidationThreshold,
      uint256 ltv,
      uint256 healthFactor
    )
  {
    (totalCollateralETH, totalDebtETH, ltv, currentLiquidationThreshold, healthFactor) = GenericLogic
      .calculateUserAccountData(
        user,
        _reserves,
        _usersConfig[user],
        _reservesList,
        _reservesCount,
        _addressesProvider.getPriceOracle()
      );

    availableBorrowsETH = GenericLogic.calculateAvailableBorrowsETH(totalCollateralETH, totalDebtETH, ltv);
  }

  
  function getConfiguration(address asset) external view override returns (DataTypes.ReserveConfigurationMap memory) {
    return _reserves[asset].configuration;
  }

  
  function getUserConfiguration(address user) external view override returns (DataTypes.UserConfigurationMap memory) {
    return _usersConfig[user];
  }

  
  function getReserveNormalizedIncome(address asset) external view virtual override returns (uint256) {
    return _reserves[asset].getNormalizedIncome();
  }

  
  function getReserveNormalizedVariableDebt(address asset) external view override returns (uint256) {
    return _reserves[asset].getNormalizedDebt();
  }

  
  function paused() external view override returns (bool) {
    return _paused;
  }

  
  function getReservesList() external view override returns (address[] memory) {
    address[] memory _activeReserves = new address[](_reservesCount);

    for (uint256 i = 0; i < _reservesCount; i++) {
      _activeReserves[i] = _reservesList[i];
    }
    return _activeReserves;
  }

  
  function getAddressesProvider() external view override returns (ILendingPoolAddressesProvider) {
    return _addressesProvider;
  }

  
  function MAX_STABLE_RATE_BORROW_SIZE_PERCENT() public view returns (uint256) {
    return _maxStableRateBorrowSizePercent;
  }

  
  function FLASHLOAN_PREMIUM_TOTAL() public view returns (uint256) {
    return _flashLoanPremiumTotal;
  }

  
  function MAX_NUMBER_RESERVES() public view returns (uint256) {
    return _maxNumberOfReserves;
  }

  
  function finalizeTransfer(
    address asset,
    address from,
    address to,
    uint256 amount,
    uint256 balanceFromBefore,
    uint256 balanceToBefore
  ) external override whenNotPaused {
    require(msg.sender == _reserves[asset].aTokenAddress, Errors.LP_CALLER_MUST_BE_AN_ATOKEN);

    ValidationLogic.validateTransfer(
      from,
      _reserves,
      _usersConfig[from],
      _reservesList,
      _reservesCount,
      _addressesProvider.getPriceOracle()
    );

    uint256 reserveId = _reserves[asset].id;

    if (from != to) {
      if (balanceFromBefore.sub(amount) == 0) {
        DataTypes.UserConfigurationMap storage fromConfig = _usersConfig[from];
        fromConfig.setUsingAsCollateral(reserveId, false);
        emit ReserveUsedAsCollateralDisabled(asset, from);
      }

      if (balanceToBefore == 0 && amount != 0) {
        DataTypes.UserConfigurationMap storage toConfig = _usersConfig[to];
        toConfig.setUsingAsCollateral(reserveId, true);
        emit ReserveUsedAsCollateralEnabled(asset, to);
      }
    }
  }

  
  function initReserve(
    address asset,
    address aTokenAddress,
    address stableDebtAddress,
    address variableDebtAddress,
    address interestRateStrategyAddress
  ) external override onlyLendingPoolConfigurator {
    require(Address.isContract(asset), Errors.LP_NOT_CONTRACT);
    _reserves[asset].init(aTokenAddress, stableDebtAddress, variableDebtAddress, interestRateStrategyAddress);
    _addReserveToList(asset);
  }

  
  function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress)
    external
    override
    onlyLendingPoolConfigurator
  {
    _reserves[asset].interestRateStrategyAddress = rateStrategyAddress;
  }

  
  function setConfiguration(address asset, uint256 configuration) external override onlyLendingPoolConfigurator {
    _reserves[asset].configuration.data = configuration;
  }

  
  function setPause(bool val) external override onlyLendingPoolConfigurator {
    _paused = val;
    if (_paused) {
      emit Paused();
    } else {
      emit Unpaused();
    }
  }

  struct ExecuteBorrowParams {
    address asset;
    address user;
    address onBehalfOf;
    uint256 amount;
    uint256 interestRateMode;
    address aTokenAddress;
    uint16 referralCode;
    bool releaseUnderlying;
  }

  function _executeBorrow(ExecuteBorrowParams memory vars) internal {
    DataTypes.ReserveData storage reserve = _reserves[vars.asset];
    DataTypes.UserConfigurationMap storage userConfig = _usersConfig[vars.onBehalfOf];

    address oracle = _addressesProvider.getPriceOracle();

    uint256 amountInETH = IPriceOracleGetter(oracle).updateAssetPrice(vars.asset).mul(vars.amount).div(
      10**reserve.configuration.getDecimals()
    );

    ValidationLogic.validateBorrow(
      vars.asset,
      reserve,
      vars.onBehalfOf,
      vars.amount,
      amountInETH,
      vars.interestRateMode,
      _maxStableRateBorrowSizePercent,
      _reserves,
      userConfig,
      _reservesList,
      _reservesCount,
      oracle
    );

    reserve.updateState();

    uint256 currentStableRate = 0;

    bool isFirstBorrowing = false;
    if (DataTypes.InterestRateMode(vars.interestRateMode) == DataTypes.InterestRateMode.STABLE) {
      currentStableRate = reserve.currentStableBorrowRate;

      isFirstBorrowing = IStableDebtToken(reserve.stableDebtTokenAddress).mint(
        vars.user,
        vars.onBehalfOf,
        vars.amount,
        currentStableRate
      );
    } else {
      isFirstBorrowing = IVariableDebtToken(reserve.variableDebtTokenAddress).mint(
        vars.user,
        vars.onBehalfOf,
        vars.amount,
        reserve.variableBorrowIndex
      );
    }

    if (isFirstBorrowing) {
      userConfig.setBorrowing(reserve.id, true);
    }

    reserve.updateInterestRates(vars.asset, vars.aTokenAddress, 0, vars.releaseUnderlying ? vars.amount : 0);

    if (vars.releaseUnderlying) {
      IAToken(vars.aTokenAddress).transferUnderlyingTo(vars.user, vars.amount);
    }

    emit Borrow(
      vars.asset,
      vars.user,
      vars.onBehalfOf,
      vars.amount,
      vars.interestRateMode,
      DataTypes.InterestRateMode(vars.interestRateMode) == DataTypes.InterestRateMode.STABLE
        ? currentStableRate
        : reserve.currentVariableBorrowRate,
      vars.referralCode
    );
  }

  function _addReserveToList(address asset) internal {
    uint256 reservesCount = _reservesCount;

    require(reservesCount < _maxNumberOfReserves, Errors.LP_NO_MORE_RESERVES_ALLOWED);

    bool reserveAlreadyAdded = _reserves[asset].id != 0 || _reservesList[0] == asset;

    if (!reserveAlreadyAdded) {
      _reserves[asset].id = uint8(reservesCount);
      _reservesList[reservesCount] = asset;

      _reservesCount = reservesCount + 1;
    }
  }
}