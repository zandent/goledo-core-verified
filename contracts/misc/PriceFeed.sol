pragma solidity 0.7.6;


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

interface IBandStdReference {
  
  function getReferenceData(string memory _base, string memory _quote)
    external
    view
    returns (
      uint256 rate,
      uint256 lastUpdatedBase,
      uint256 lastUpdatedRate
    );
}

interface IChainlinkAggregator {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  
  
  
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}

contract PriceFeed is IPriceFeed {
  using SafeMath for uint256;

  uint256 public constant DECIMAL_PRECISION = 1e18;

  IChainlinkAggregator public chainlinkOracle; 
  IBandStdReference public bandOracle; 

  string public bandBase;
  string public constant bandQuote = "USD";

  
  uint256 public constant TARGET_DIGITS = 18;

  
  
  
  uint256 public immutable TIMEOUT;

  
  uint256 public constant MAX_PRICE_DEVIATION_FROM_PREVIOUS_ROUND = 5e17; 

  
  uint256 public constant MAX_PRICE_DIFFERENCE_BETWEEN_ORACLES = 5e16; 

  
  uint256 public lastGoodPrice;

  struct ChainlinkResponse {
    uint80 roundId;
    uint256 answer;
    uint256 timestamp;
    bool success;
    uint8 decimals;
  }

  struct BandResponse {
    uint256 value;
    uint256 timestamp;
    bool success;
  }

  enum Status {
    chainlinkWorking,
    usingBandChainlinkUntrusted,
    bothOraclesUntrusted,
    usingBandChainlinkFrozen,
    usingChainlinkBandUntrusted
  }

  
  Status public status;

  event LastGoodPriceUpdated(uint256 _lastGoodPrice);
  event PriceFeedStatusChanged(Status newStatus);

  

  constructor(
    IChainlinkAggregator _chainlinkOracleAddress,
    IBandStdReference _bandOracleAddress,
    uint256 _timeout,
    string memory _bandBase
  ) {
    chainlinkOracle = _chainlinkOracleAddress;
    bandOracle = _bandOracleAddress;

    TIMEOUT = _timeout;

    bandBase = _bandBase;

    
    status = Status.chainlinkWorking;

    
    ChainlinkResponse memory chainlinkResponse = _getCurrentChainlinkResponse();
    ChainlinkResponse memory prevChainlinkResponse = _getPrevChainlinkResponse(
      chainlinkResponse.roundId,
      chainlinkResponse.decimals
    );

    require(
      !_chainlinkIsBroken(chainlinkResponse, prevChainlinkResponse) &&
        block.timestamp.sub(chainlinkResponse.timestamp) < _timeout,
      "PriceFeed: Chainlink must be working and current"
    );

    lastGoodPrice = _scaleChainlinkPriceByDigits(uint256(chainlinkResponse.answer), chainlinkResponse.decimals);
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

  function _fetchPrice() internal view returns (Status, uint256) {
    
    ChainlinkResponse memory chainlinkResponse = _getCurrentChainlinkResponse();
    ChainlinkResponse memory prevChainlinkResponse = _getPrevChainlinkResponse(
      chainlinkResponse.roundId,
      chainlinkResponse.decimals
    );
    BandResponse memory bandResponse = _getCurrentBandResponse();

    
    if (status == Status.chainlinkWorking) {
      
      if (_chainlinkIsBroken(chainlinkResponse, prevChainlinkResponse)) {
        
        if (_bandIsBroken(bandResponse)) {
          return (Status.bothOraclesUntrusted, lastGoodPrice);
        }
        
        if (_bandIsFrozen(bandResponse)) {
          return (Status.usingBandChainlinkUntrusted, lastGoodPrice);
        }

        
        return (Status.usingBandChainlinkUntrusted, bandResponse.value);
      }

      
      if (_chainlinkIsFrozen(chainlinkResponse)) {
        
        if (_bandIsBroken(bandResponse)) {
          return (Status.usingChainlinkBandUntrusted, lastGoodPrice);
        }

        
        if (_bandIsFrozen(bandResponse)) {
          return (Status.usingBandChainlinkFrozen, lastGoodPrice);
        }

        
        return (Status.usingBandChainlinkFrozen, bandResponse.value);
      }

      
      if (_chainlinkPriceChangeAboveMax(chainlinkResponse, prevChainlinkResponse)) {
        
        if (_bandIsBroken(bandResponse)) {
          return (Status.bothOraclesUntrusted, lastGoodPrice);
        }

        
        if (_bandIsFrozen(bandResponse)) {
          return (Status.usingBandChainlinkUntrusted, lastGoodPrice);
        }

        
        if (_bothOraclesSimilarPrice(chainlinkResponse, bandResponse)) {
          return (Status.chainlinkWorking, chainlinkResponse.answer);
        }

        
        
        return (Status.usingBandChainlinkUntrusted, bandResponse.value);
      }

      
      if (_bandIsBroken(bandResponse)) {
        return (Status.usingChainlinkBandUntrusted, chainlinkResponse.answer);
      }

      
      return (Status.chainlinkWorking, chainlinkResponse.answer);
    }

    
    if (status == Status.usingBandChainlinkUntrusted) {
      
      if (_bothOraclesLiveAndUnbrokenAndSimilarPrice(chainlinkResponse, prevChainlinkResponse, bandResponse)) {
        return (Status.chainlinkWorking, chainlinkResponse.answer);
      }

      if (_bandIsBroken(bandResponse)) {
        return (Status.bothOraclesUntrusted, lastGoodPrice);
      }

      
      if (_bandIsFrozen(bandResponse)) {
        return (Status.usingBandChainlinkUntrusted, lastGoodPrice);
      }

      
      return (Status.usingBandChainlinkUntrusted, bandResponse.value);
    }

    
    if (status == Status.bothOraclesUntrusted) {
      
      if (_bothOraclesLiveAndUnbrokenAndSimilarPrice(chainlinkResponse, prevChainlinkResponse, bandResponse)) {
        return (Status.chainlinkWorking, chainlinkResponse.answer);
      }

      
      return (Status.bothOraclesUntrusted, lastGoodPrice);
    }

    
    if (status == Status.usingBandChainlinkFrozen) {
      if (_chainlinkIsBroken(chainlinkResponse, prevChainlinkResponse)) {
        
        if (_bandIsBroken(bandResponse)) {
          return (Status.bothOraclesUntrusted, lastGoodPrice);
        }

        

        if (_bandIsFrozen(bandResponse)) {
          return (Status.usingBandChainlinkUntrusted, lastGoodPrice);
        }

        
        return (Status.usingBandChainlinkUntrusted, bandResponse.value);
      }

      if (_chainlinkIsFrozen(chainlinkResponse)) {
        
        if (_bandIsBroken(bandResponse)) {
          return (Status.usingChainlinkBandUntrusted, lastGoodPrice);
        }

        
        if (_bandIsFrozen(bandResponse)) {
          return (Status.usingBandChainlinkFrozen, lastGoodPrice);
        }

        
        return (Status.usingBandChainlinkFrozen, bandResponse.value);
      }

      
      if (_bandIsBroken(bandResponse)) {
        return (Status.usingChainlinkBandUntrusted, chainlinkResponse.answer);
      }

      
      if (_bandIsFrozen(bandResponse)) {
        return (Status.usingBandChainlinkFrozen, lastGoodPrice);
      }

      
      
      if (_bothOraclesSimilarPrice(chainlinkResponse, bandResponse)) {
        return (Status.chainlinkWorking, chainlinkResponse.answer);
      }

      
      return (Status.usingBandChainlinkUntrusted, bandResponse.value);
    }

    
    if (status == Status.usingChainlinkBandUntrusted) {
      
      if (_chainlinkIsBroken(chainlinkResponse, prevChainlinkResponse)) {
        return (Status.bothOraclesUntrusted, lastGoodPrice);
      }

      
      if (_chainlinkIsFrozen(chainlinkResponse)) {
        return (Status.usingChainlinkBandUntrusted, lastGoodPrice);
      }

      
      if (_bothOraclesLiveAndUnbrokenAndSimilarPrice(chainlinkResponse, prevChainlinkResponse, bandResponse)) {
        return (Status.chainlinkWorking, chainlinkResponse.answer);
      }

      
      
      if (_chainlinkPriceChangeAboveMax(chainlinkResponse, prevChainlinkResponse)) {
        return (Status.bothOraclesUntrusted, lastGoodPrice);
      }

      
      
      return (Status.usingChainlinkBandUntrusted, chainlinkResponse.answer);
    }
  }

  

  
  function _chainlinkIsBroken(ChainlinkResponse memory _currentResponse, ChainlinkResponse memory _prevResponse)
    internal
    view
    returns (bool)
  {
    return _badChainlinkResponse(_currentResponse) || _badChainlinkResponse(_prevResponse);
  }

  function _badChainlinkResponse(ChainlinkResponse memory _response) internal view returns (bool) {
    
    if (!_response.success) {
      return true;
    }
    
    if (_response.roundId == 0) {
      return true;
    }
    
    if (_response.timestamp == 0 || _response.timestamp > block.timestamp) {
      return true;
    }
    
    if (int256(_response.answer) <= 0) {
      return true;
    }

    return false;
  }

  function _chainlinkIsFrozen(ChainlinkResponse memory _response) internal view returns (bool) {
    return block.timestamp.sub(_response.timestamp) > TIMEOUT;
  }

  function _chainlinkPriceChangeAboveMax(
    ChainlinkResponse memory _currentResponse,
    ChainlinkResponse memory _prevResponse
  ) internal pure returns (bool) {
    uint256 currentScaledPrice = _currentResponse.answer;
    uint256 prevScaledPrice = _prevResponse.answer;

    uint256 minPrice = (currentScaledPrice < prevScaledPrice) ? currentScaledPrice : prevScaledPrice;
    uint256 maxPrice = (currentScaledPrice >= prevScaledPrice) ? currentScaledPrice : prevScaledPrice;

    
    uint256 percentDeviation = maxPrice.sub(minPrice).mul(DECIMAL_PRECISION).div(maxPrice);

    
    return percentDeviation > MAX_PRICE_DEVIATION_FROM_PREVIOUS_ROUND;
  }

  function _bandIsBroken(BandResponse memory _response) internal view returns (bool) {
    
    if (!_response.success) {
      return true;
    }
    
    if (_response.timestamp == 0 || _response.timestamp > block.timestamp) {
      return true;
    }
    
    if (_response.value == 0) {
      return true;
    }

    return false;
  }

  function _bandIsFrozen(BandResponse memory _bandResponse) internal view returns (bool) {
    return block.timestamp.sub(_bandResponse.timestamp) > TIMEOUT;
  }

  function _bothOraclesLiveAndUnbrokenAndSimilarPrice(
    ChainlinkResponse memory _chainlinkResponse,
    ChainlinkResponse memory _prevChainlinkResponse,
    BandResponse memory _bandResponse
  ) internal view returns (bool) {
    
    if (
      _bandIsBroken(_bandResponse) ||
      _bandIsFrozen(_bandResponse) ||
      _chainlinkIsBroken(_chainlinkResponse, _prevChainlinkResponse) ||
      _chainlinkIsFrozen(_chainlinkResponse)
    ) {
      return false;
    }

    return _bothOraclesSimilarPrice(_chainlinkResponse, _bandResponse);
  }

  function _bothOraclesSimilarPrice(ChainlinkResponse memory _chainlinkResponse, BandResponse memory _bandResponse)
    internal
    pure
    returns (bool)
  {
    uint256 scaledChainlinkPrice = _chainlinkResponse.answer;
    uint256 scaledBandPrice = _bandResponse.value;

    
    uint256 minPrice = (scaledBandPrice < scaledChainlinkPrice) ? scaledBandPrice : scaledChainlinkPrice;
    uint256 maxPrice = (scaledBandPrice >= scaledChainlinkPrice) ? scaledBandPrice : scaledChainlinkPrice;
    uint256 percentPriceDifference = maxPrice.sub(minPrice).mul(DECIMAL_PRECISION).div(minPrice);

    
    return percentPriceDifference <= MAX_PRICE_DIFFERENCE_BETWEEN_ORACLES;
  }

  function _scaleChainlinkPriceByDigits(uint256 _price, uint256 _answerDigits) internal pure returns (uint256) {
    
    uint256 price;
    if (_answerDigits >= TARGET_DIGITS) {
      
      price = _price.div(10**(_answerDigits - TARGET_DIGITS));
    } else if (_answerDigits < TARGET_DIGITS) {
      
      price = _price.mul(10**(TARGET_DIGITS - _answerDigits));
    }
    return price;
  }

  

  function _getCurrentBandResponse() internal view returns (BandResponse memory bandResponse) {
    try bandOracle.getReferenceData(bandBase, bandQuote) returns (
      uint256 value,
      uint256 lastUpdatedBase,
      uint256 lastUpdatedQuote
    ) {
      
      bandResponse.value = value;
      bandResponse.timestamp = lastUpdatedBase < lastUpdatedQuote ? lastUpdatedBase : lastUpdatedQuote;
      bandResponse.success = true;

      return (bandResponse);
    } catch {
      
      return (bandResponse);
    }
  }

  function _getCurrentChainlinkResponse() internal view returns (ChainlinkResponse memory chainlinkResponse) {
    
    try chainlinkOracle.decimals() returns (uint8 decimals) {
      
      chainlinkResponse.decimals = decimals;
    } catch {
      
      return chainlinkResponse;
    }

    
    try chainlinkOracle.latestRoundData() returns (
      uint80 roundId,
      int256 answer,
      uint256, 
      uint256 timestamp,
      uint80 
    ) {
      
      chainlinkResponse.roundId = roundId;
      chainlinkResponse.answer = _scaleChainlinkPriceByDigits(uint256(answer), chainlinkResponse.decimals);
      chainlinkResponse.timestamp = timestamp;
      chainlinkResponse.success = true;
      return chainlinkResponse;
    } catch {
      
      return chainlinkResponse;
    }
  }

  function _getPrevChainlinkResponse(uint80 _currentRoundId, uint8 _currentDecimals)
    internal
    view
    returns (ChainlinkResponse memory prevChainlinkResponse)
  {
    

    
    try chainlinkOracle.getRoundData(_currentRoundId - 1) returns (
      uint80 roundId,
      int256 answer,
      uint256, 
      uint256 timestamp,
      uint80 
    ) {
      
      prevChainlinkResponse.roundId = roundId;
      prevChainlinkResponse.answer = _scaleChainlinkPriceByDigits(uint256(answer), _currentDecimals);
      prevChainlinkResponse.timestamp = timestamp;
      prevChainlinkResponse.decimals = _currentDecimals;
      prevChainlinkResponse.success = true;
      return prevChainlinkResponse;
    } catch {
      
      return prevChainlinkResponse;
    }
  }
}