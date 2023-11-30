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
contract NeedInitialize {
    bool public initialized;

    modifier onlyInitializeOnce() {
        require(!initialized, "NeedInitialize: already initialized");
        _;
        initialized = true;
    }
}
contract GoledoTokenV2 is NeedInitialize, IERC20 {
  using SafeMath for uint256;

  string public constant symbol = "GOL";
  string public constant name = "Goledo Token Version 2";
  uint8 public constant decimals = 18;
  uint256 public override totalSupply;
  uint256 public maxTotalSupply;
  address public minter;

  mapping(address => uint256) public override balanceOf;
  mapping(address => mapping(address => uint256)) public override allowance;

  function initialize (uint256 _maxTotalSupply) external onlyInitializeOnce {
    maxTotalSupply = _maxTotalSupply;
    emit Transfer(address(0), msg.sender, 0);
  }

  function setMinter(address _minter) external returns (bool) {
    require(minter == address(0));
    minter = _minter;
    return true;
  }

  function approve(address _spender, uint256 _value) external override returns (bool) {
    allowance[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  
  function _transfer(
    address _from,
    address _to,
    uint256 _value
  ) internal {
    require(balanceOf[_from] >= _value, "Insufficient balance");
    balanceOf[_from] = balanceOf[_from].sub(_value);
    balanceOf[_to] = balanceOf[_to].add(_value);
    emit Transfer(_from, _to, _value);
  }

  
  function transfer(address _to, uint256 _value) public override returns (bool) {
    _transfer(msg.sender, _to, _value);
    return true;
  }

  
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  ) public override returns (bool) {
    uint256 allowed = allowance[_from][msg.sender];
    require(allowed >= _value, "Insufficient allowance");
    if (allowed != uint256(-1)) {
      allowance[_from][msg.sender] = allowed.sub(_value);
    }
    _transfer(_from, _to, _value);
    return true;
  }

  function mint(address _to, uint256 _value) external returns (bool) {
    require(msg.sender == minter);
    balanceOf[_to] = balanceOf[_to].add(_value);
    totalSupply = totalSupply.add(_value);
    require(maxTotalSupply >= totalSupply);
    emit Transfer(address(0), _to, _value);
    return true;
  }
}