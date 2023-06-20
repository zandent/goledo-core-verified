pragma solidity 0.7.6;

pragma solidity >=0.5.0;

interface ISwappiPair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
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

interface IPriceFeed {
  
  function fetchPrice() external view returns (uint256);

  function updatePrice() external returns (uint256);
}

interface IWitnetPriceFeed {
  
  event PriceFeeding(address indexed from, uint256 queryId, uint256 extraFee);

  
  
  
  
  function estimateUpdateFee(uint256 _gasPrice) external view returns (uint256);

  
  function lastPrice() external view returns (int256);

  
  function lastTimestamp() external view returns (uint256);

  
  
  
  
  
  
  function lastValue()
    external
    view
    returns (
      int256 _lastPrice,
      uint256 _lastTimestamp,
      bytes32 _lastDrTxHash,
      uint256 _latestUpdateStatus
    );

  
  function latestQueryId() external view returns (uint256);

  
  
  function latestUpdateDrTxHash() external view returns (bytes32);

  
  
  
  function latestUpdateErrorMessage() external view returns (string memory);

  
  
  
  
  
  function latestUpdateStatus() external view returns (uint256);

  
  
  function pendingUpdate() external view returns (bool);

  
  
  
  
  function requestUpdate() external payable;

  
  
  
  function supportsInterface(bytes4) external view returns (bool);
}

interface IERC165 {
    
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IWitnetPriceRouter {
  
  
  
  event CurrencyPairSet(bytes32 indexed erc2362ID, IERC165 pricefeed);

  
  function currencyPairId(string memory) external pure virtual returns (bytes32);

  
  
  function getPriceFeed(bytes32 _erc2362id) external view virtual returns (IERC165);

  
  
  
  
  function getPriceFeedCaption(IERC165) external view virtual returns (string memory);

  
  function lookupERC2362ID(bytes32 _erc2362id) external view virtual returns (string memory);

  
  
  
  
  function setPriceFeed(
    IERC165 _pricefeed,
    uint256 _decimals,
    string calldata _base,
    string calldata _quote
  ) external virtual;

  
  function supportedCurrencyPairs() external view virtual returns (bytes32[] memory);

  
  function supportsCurrencyPair(bytes32 _erc2362id) external view virtual returns (bool);

  
  function supportsPriceFeed(IERC165 _priceFeed) external view virtual returns (bool);

  
  
  
  
  
  
  
  
  
  
  function valueFor(bytes32 _erc2362id)
    external
    view
    returns (
      int256 _lastPrice,
      uint256 _lastTimestamp,
      uint256 _latestUpdateStatus
    );
}

contract SwappiPairPriceFeed is IPriceFeed {
  using SafeMath for uint256;

  uint256 public constant DECIMAL_PRECISION = 1e18;

  //Add a pair of custom token and CFX
  ISwappiPair public SwappiPair;
  address public baseToken;

  IPriceFeed CFXPriceFeed;
  
  IWitnetPriceRouter public witnetRouter; 

  bytes32 public witnetAssetID; 

  uint256 public witnetDecimals; 

  
  uint256 public constant TARGET_DIGITS = 18;

  
  
  
  uint256 public immutable TIMEOUT;

  
  uint256 public constant MAX_PRICE_DEVIATION_FROM_PREVIOUS_ROUND = 5e17; 

  
  uint256 public constant MAX_PRICE_DIFFERENCE_BETWEEN_ORACLES = 5e16; 

  
  uint256 public lastGoodPrice;

  struct WitnetResponse {
    uint256 lastPrice;
    uint256 timestamp;
    
    
    
    uint256 status;
  }

  enum Status {
    WitnetWorking,
    WitnetBroken,
    WitnetFrozen
  }

  
  Status public status;

  event LastGoodPriceUpdated(uint256 _lastGoodPrice);
  event PriceFeedStatusChanged(Status newStatus);

  

  constructor(
    ISwappiPair _SwappiPair,
    address _baseToken,
    IWitnetPriceRouter _witnetRouter,
    IPriceFeed _CFXPriceFeed,
    bytes32 _witnetAssetID,
    uint256 _witnetDecimals,
    uint256 _timeout
  ) {
    CFXPriceFeed = _CFXPriceFeed;
    SwappiPair = _SwappiPair;
    baseToken = _baseToken;
    witnetRouter = _witnetRouter;
    witnetAssetID = _witnetAssetID;
    witnetDecimals = _witnetDecimals;

    TIMEOUT = _timeout;

    
    status = Status.WitnetWorking;

    
    WitnetResponse memory witnetResponse = _getCurrentWitnetResponse();

    require(
      !_witnetIsBroken(witnetResponse) && block.timestamp.sub(witnetResponse.timestamp) < _timeout,
      "PriceFeed: witnet must be working and current"
    );

    lastGoodPrice = _scaleWitnetPriceByDigits(uint256(witnetResponse.lastPrice));
  }

  

  
  function fetchPrice() external view override returns (uint256) {
    (, uint256 price) = _fetchPrice();
    return price;
  }

  function updatePrice() external override returns (uint256) {
    (Status newStatus, uint256 price) = _fetchPrice();
    lastGoodPrice = price;
    if (status != newStatus) {
      status = newStatus;
      emit PriceFeedStatusChanged(newStatus);
    }
    return price;
  }

  // function forceUpdateWitnet() external payable {
  //   IWitnetPriceFeed _priceFeed = IWitnetPriceFeed(address(witnetRouter.getPriceFeed(witnetAssetID)));
  //   uint256 _updateFee = _priceFeed.estimateUpdateFee(tx.gasprice);
  //   _priceFeed.requestUpdate{ value: _updateFee }();
  //   if (msg.value > _updateFee) {
  //     payable(msg.sender).transfer(msg.value - _updateFee);
  //   }
  // }

  function _fetchPrice() internal view returns (Status, uint256) {
    
    WitnetResponse memory _response = _getCurrentWitnetResponse();

    
    if (status == Status.WitnetWorking) {
      if (_witnetIsBroken(_response)) {
        return (Status.WitnetBroken, lastGoodPrice);
      }

      if (_witnetIsFrozen(_response)) {
        return (Status.WitnetFrozen, lastGoodPrice);
      }

      return (Status.WitnetWorking, _scaleWitnetPriceByDigits(uint256(_response.lastPrice)));
    }

    
    if (status == Status.WitnetBroken) {
      if (!_witnetIsBroken(_response) && !_witnetIsFrozen(_response)) {
        return (Status.WitnetWorking, _scaleWitnetPriceByDigits(uint256(_response.lastPrice)));
      }
      if (_witnetIsFrozen(_response)) {
        return (Status.WitnetFrozen, lastGoodPrice);
      }
      return (Status.WitnetBroken, lastGoodPrice);
    }

    
    if (status == Status.WitnetFrozen) {
      if (!_witnetIsBroken(_response) && !_witnetIsFrozen(_response)) {
        return (Status.WitnetWorking, _scaleWitnetPriceByDigits(uint256(_response.lastPrice)));
      }
      if (_witnetIsFrozen(_response)) {
        return (Status.WitnetBroken, lastGoodPrice);
      }
      return (Status.WitnetFrozen, lastGoodPrice);
    }
  }

  

  function _witnetIsBroken(WitnetResponse memory _response) internal view returns (bool) {
    
    if (_response.status == 400 || _response.status == 404) {
      return true;
    }
    
    if (_response.timestamp == 0 || _response.timestamp > block.timestamp) {
      return true;
    }
    
    if (_response.lastPrice <= 0) {
      return true;
    }

    return false;
  }

  function _witnetIsFrozen(WitnetResponse memory _response) internal view returns (bool) {
    return block.timestamp.sub(_response.timestamp) > TIMEOUT;
  }

  function _scaleWitnetPriceByDigits(uint256 _price) internal view returns (uint256) {
    
    uint256 _answerDigits = witnetDecimals;
    uint256 price;
    if (_answerDigits > TARGET_DIGITS) {
      
      price = _price.div(10**(_answerDigits - TARGET_DIGITS));
    } else if (_answerDigits < TARGET_DIGITS) {
      
      price = _price.mul(10**(TARGET_DIGITS - _answerDigits));
    }
    return price;
  }

  

  function _getCurrentWitnetResponse() internal view returns (WitnetResponse memory witnetResponse) {
    try CFXPriceFeed.fetchPrice() returns (
      uint256 lastPrice
    ) {
      
      // witnetResponse.lastPrice = lastPrice;
      witnetResponse.timestamp = block.timestamp;
      witnetResponse.status = 200;

      address token0 = SwappiPair.token0();
      (uint112 reserve0, uint112 reserve1,) = SwappiPair.getReserves();

      if (token0 == baseToken){
        witnetResponse.lastPrice = uint256(lastPrice).mul(uint256(reserve0)).div(uint256(reserve1)).div(10**12);
      }else{
        witnetResponse.lastPrice = uint256(lastPrice).mul(uint256(reserve1)).div(uint256(reserve0)).div(10**12);
      }

      return (witnetResponse);
    } catch {
      witnetResponse.status = 404;
      
      return (witnetResponse);
    }
  }
}