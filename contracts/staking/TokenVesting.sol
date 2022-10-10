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

interface IMultiFeeDistribution {
  function addReward(address rewardsToken) external;

  function mint(
    address user,
    uint256 amount,
    bool withPenalty
  ) external;
}

contract TokenVesting {
  using SafeMath for uint256;

  uint256 public startTime;
  uint256 public constant duration = 86400 * 365;
  uint256 public immutable maxMintableTokens;
  uint256 public mintedTokens;
  IMultiFeeDistribution public minter;
  address public owner;

  struct Vest {
    uint256 total;
    uint256 claimed;
  }

  mapping(address => Vest) public vests;

  constructor(
    IMultiFeeDistribution _minter,
    uint256 _maxMintable,
    address[] memory _receivers,
    uint256[] memory _amounts
  ) {
    require(_receivers.length == _amounts.length);
    minter = _minter;
    uint256 mintable;
    for (uint256 i = 0; i < _receivers.length; i++) {
      require(vests[_receivers[i]].total == 0);
      mintable = mintable.add(_amounts[i]);
      vests[_receivers[i]].total = _amounts[i];
    }
    require(mintable == _maxMintable);
    maxMintableTokens = mintable;
    owner = msg.sender;
  }

  function start() external {
    require(msg.sender == owner);
    require(startTime == 0);
    startTime = block.timestamp;
  }

  function claimable(address _claimer) external view returns (uint256) {
    if (startTime == 0) return 0;
    Vest storage v = vests[_claimer];
    uint256 elapsedTime = block.timestamp.sub(startTime);
    if (elapsedTime > duration) elapsedTime = duration;
    uint256 claimable = v.total.mul(elapsedTime).div(duration);
    return claimable.sub(v.claimed);
  }

  function claim(address _receiver) external {
    require(startTime != 0);
    Vest storage v = vests[msg.sender];
    uint256 elapsedTime = block.timestamp.sub(startTime);
    if (elapsedTime > duration) elapsedTime = duration;
    uint256 claimable = v.total.mul(elapsedTime).div(duration);
    if (claimable > v.claimed) {
      uint256 amount = claimable.sub(v.claimed);
      mintedTokens = mintedTokens.add(amount);
      require(mintedTokens <= maxMintableTokens);
      minter.mint(_receiver, amount, false);
      v.claimed = claimable;
    }
  }
}