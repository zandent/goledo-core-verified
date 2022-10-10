pragma solidity 0.7.6;


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

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    
    function owner() public view virtual returns (address) {
        return _owner;
    }

    
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
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

interface IOnwardIncentivesController {
  function handleAction(
    address _token,
    address _user,
    uint256 _balance,
    uint256 _totalSupply
  ) external;
}

contract MasterChef is Ownable {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  
  struct UserInfo {
    uint256 amount;
    uint256 rewardDebt;
  }
  
  struct PoolInfo {
    uint256 allocPoint; 
    uint256 lastRewardTime; 
    uint256 accRewardPerShare; 
    IOnwardIncentivesController onwardIncentives;
  }
  
  struct EmissionPoint {
    uint128 startTimeOffset;
    uint128 rewardsPerSecond;
  }

  address public poolConfigurator;

  IMultiFeeDistribution public rewardMinter;
  uint256 public rewardsPerSecond;
  uint256 public immutable maxMintableTokens;
  uint256 public mintedTokens;

  
  address[] public registeredTokens;
  mapping(address => PoolInfo) public poolInfo;

  
  
  
  EmissionPoint[] public emissionSchedule;
  
  mapping(address => mapping(address => UserInfo)) public userInfo;
  
  mapping(address => uint256) public userBaseClaimable;
  
  uint256 public totalAllocPoint = 0;
  
  uint256 public startTime;

  
  
  
  mapping(address => address) public claimReceiver;

  event Deposit(address indexed token, address indexed user, uint256 amount);

  event Withdraw(address indexed token, address indexed user, uint256 amount);

  event EmergencyWithdraw(address indexed token, address indexed user, uint256 amount);

  constructor(
    uint128[] memory _startTimeOffset,
    uint128[] memory _rewardsPerSecond,
    address _poolConfigurator,
    IMultiFeeDistribution _rewardMinter,
    uint256 _maxMintable
  ) Ownable() {
    poolConfigurator = _poolConfigurator;
    rewardMinter = _rewardMinter;
    uint256 length = _startTimeOffset.length;
    for (uint256 i = length - 1; i + 1 != 0; i--) {
      emissionSchedule.push(
        EmissionPoint({ startTimeOffset: _startTimeOffset[i], rewardsPerSecond: _rewardsPerSecond[i] })
      );
    }
    maxMintableTokens = _maxMintable;
  }

  
  function start() public onlyOwner {
    require(startTime == 0);
    startTime = block.timestamp;
  }

  
  function addPool(address _token, uint256 _allocPoint) external onlyOwner {
    require(poolInfo[_token].lastRewardTime == 0);
    _updateEmissions();
    totalAllocPoint = totalAllocPoint.add(_allocPoint);
    registeredTokens.push(_token);
    poolInfo[_token] = PoolInfo({
      allocPoint: _allocPoint,
      lastRewardTime: block.timestamp,
      accRewardPerShare: 0,
      onwardIncentives: IOnwardIncentivesController(0)
    });
  }

  
  function batchUpdateAllocPoint(address[] calldata _tokens, uint256[] calldata _allocPoints) public onlyOwner {
    require(_tokens.length == _allocPoints.length);
    _massUpdatePools();
    uint256 _totalAllocPoint = totalAllocPoint;
    for (uint256 i = 0; i < _tokens.length; i++) {
      PoolInfo storage pool = poolInfo[_tokens[i]];
      require(pool.lastRewardTime > 0);
      _totalAllocPoint = _totalAllocPoint.sub(pool.allocPoint).add(_allocPoints[i]);
      pool.allocPoint = _allocPoints[i];
    }
    totalAllocPoint = _totalAllocPoint;
  }

  function setOnwardIncentives(address _token, IOnwardIncentivesController _incentives) external onlyOwner {
    require(poolInfo[_token].lastRewardTime != 0);
    poolInfo[_token].onwardIncentives = _incentives;
  }

  function setClaimReceiver(address _user, address _receiver) external {
    require(msg.sender == _user || msg.sender == owner());
    claimReceiver[_user] = _receiver;
  }

  function poolLength() external view returns (uint256) {
    return registeredTokens.length;
  }

  function claimableReward(address _user, address[] calldata _tokens) external view returns (uint256[] memory) {
    uint256[] memory claimable = new uint256[](_tokens.length);
    for (uint256 i = 0; i < _tokens.length; i++) {
      address token = _tokens[i];
      PoolInfo storage pool = poolInfo[token];
      UserInfo storage user = userInfo[token][_user];
      uint256 accRewardPerShare = pool.accRewardPerShare;
      uint256 lpSupply = IERC20(token).balanceOf(address(this));
      if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
        uint256 duration = block.timestamp.sub(pool.lastRewardTime);
        uint256 reward = duration.mul(rewardsPerSecond).mul(pool.allocPoint).div(totalAllocPoint);
        accRewardPerShare = accRewardPerShare.add(reward.mul(1e12).div(lpSupply));
      }
      claimable[i] = user.amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
    }
    return claimable;
  }
  function updateNextEmissions(
    uint128[] memory _startTimeOffset,
    uint128[] memory _rewardsPerSecond
  )public onlyOwner {
    uint256 oldLength = emissionSchedule.length;
    require(oldLength <= 1, "Emissions still exist.");
    uint256 length = _startTimeOffset.length;
    if (oldLength == 1) {
      EmissionPoint memory e = emissionSchedule[oldLength - 1];
      emissionSchedule.pop();
      for (uint256 i = length - 1; i + 1 != 0; i--) {
        emissionSchedule.push(
          EmissionPoint({ startTimeOffset: _startTimeOffset[i], rewardsPerSecond: _rewardsPerSecond[i] })
        );
      }
      emissionSchedule.push(e);
    }else{
      for (uint256 i = length - 1; i + 1 != 0; i--) {
        emissionSchedule.push(
          EmissionPoint({ startTimeOffset: _startTimeOffset[i], rewardsPerSecond: _rewardsPerSecond[i] })
        );
      }
    }
  }
  function _updateEmissions() internal {
    uint256 length = emissionSchedule.length;
    if (startTime > 0 && length > 0) {
      EmissionPoint memory e = emissionSchedule[length - 1];
      if (block.timestamp.sub(startTime) > e.startTimeOffset) {
        _massUpdatePools();
        rewardsPerSecond = uint256(e.rewardsPerSecond);
        emissionSchedule.pop();
      }
    }
  }

  
  function _massUpdatePools() internal {
    uint256 totalAP = totalAllocPoint;
    uint256 length = registeredTokens.length;
    for (uint256 i = 0; i < length; ++i) {
      _updatePool(registeredTokens[i], totalAP);
    }
  }

  
  function _updatePool(address _token, uint256 _totalAllocPoint) internal {
    PoolInfo storage pool = poolInfo[_token];
    if (block.timestamp <= pool.lastRewardTime) {
      return;
    }
    uint256 lpSupply = IERC20(_token).balanceOf(address(this));
    if (lpSupply == 0) {
      pool.lastRewardTime = block.timestamp;
      return;
    }
    uint256 duration = block.timestamp.sub(pool.lastRewardTime);
    uint256 reward = duration.mul(rewardsPerSecond).mul(pool.allocPoint).div(_totalAllocPoint);
    pool.accRewardPerShare = pool.accRewardPerShare.add(reward.mul(1e12).div(lpSupply));
    pool.lastRewardTime = block.timestamp;
  }

  function _mint(address _user, uint256 _amount) internal {
    uint256 minted = mintedTokens;
    if (minted.add(_amount) > maxMintableTokens) {
      _amount = maxMintableTokens.sub(minted);
    }
    if (_amount > 0) {
      mintedTokens = minted.add(_amount);
      address receiver = claimReceiver[_user];
      if (receiver == address(0)) receiver = _user;
      rewardMinter.mint(receiver, _amount, true);
    }
  }

  
  function deposit(address _token, uint256 _amount) external {
    PoolInfo storage pool = poolInfo[_token];
    require(pool.lastRewardTime > 0);
    _updateEmissions();
    _updatePool(_token, totalAllocPoint);
    UserInfo storage user = userInfo[_token][msg.sender];
    uint256 userAmount = user.amount;
    uint256 accRewardPerShare = pool.accRewardPerShare;
    if (userAmount > 0) {
      uint256 pending = userAmount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
      if (pending > 0) {
        userBaseClaimable[msg.sender] = userBaseClaimable[msg.sender].add(pending);
      }
    }
    IERC20(_token).safeTransferFrom(address(msg.sender), address(this), _amount);
    userAmount = userAmount.add(_amount);
    user.amount = userAmount;
    user.rewardDebt = userAmount.mul(accRewardPerShare).div(1e12);
    if (pool.onwardIncentives != IOnwardIncentivesController(0)) {
      uint256 lpSupply = IERC20(_token).balanceOf(address(this));
      pool.onwardIncentives.handleAction(_token, msg.sender, userAmount, lpSupply);
    }
    emit Deposit(_token, msg.sender, _amount);
  }

  
  function withdraw(address _token, uint256 _amount) external {
    PoolInfo storage pool = poolInfo[_token];
    require(pool.lastRewardTime > 0);
    UserInfo storage user = userInfo[_token][msg.sender];
    uint256 userAmount = user.amount;
    require(userAmount >= _amount, "withdraw: not good");
    _updateEmissions();
    _updatePool(_token, totalAllocPoint);
    uint256 accRewardPerShare = pool.accRewardPerShare;
    uint256 pending = userAmount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
    if (pending > 0) {
      userBaseClaimable[msg.sender] = userBaseClaimable[msg.sender].add(pending);
    }
    userAmount = userAmount.sub(_amount);
    user.amount = userAmount;
    user.rewardDebt = userAmount.mul(accRewardPerShare).div(1e12);
    IERC20(_token).safeTransfer(address(msg.sender), _amount);
    if (pool.onwardIncentives != IOnwardIncentivesController(0)) {
      uint256 lpSupply = IERC20(_token).balanceOf(address(this));
      pool.onwardIncentives.handleAction(_token, msg.sender, userAmount, lpSupply);
    }
    emit Withdraw(_token, msg.sender, _amount);
  }

  
  function emergencyWithdraw(address _token) external {
    PoolInfo storage pool = poolInfo[_token];
    UserInfo storage user = userInfo[_token][msg.sender];
    uint256 amount = user.amount;
    user.amount = 0;
    user.rewardDebt = 0;
    IERC20(_token).safeTransfer(address(msg.sender), amount);
    emit EmergencyWithdraw(_token, msg.sender, amount);
    if (pool.onwardIncentives != IOnwardIncentivesController(0)) {
      uint256 lpSupply = IERC20(_token).balanceOf(address(this));
      try pool.onwardIncentives.handleAction(_token, msg.sender, 0, lpSupply) {} catch {}
    }
  }

  
  
  function claim(address _user, address[] calldata _tokens) external {
    _updateEmissions();
    uint256 pending = userBaseClaimable[_user];
    userBaseClaimable[_user] = 0;
    uint256 _totalAllocPoint = totalAllocPoint;
    for (uint256 i = 0; i < _tokens.length; i++) {
      PoolInfo storage pool = poolInfo[_tokens[i]];
      require(pool.lastRewardTime > 0);
      _updatePool(_tokens[i], _totalAllocPoint);
      UserInfo storage user = userInfo[_tokens[i]][_user];
      uint256 rewardDebt = user.amount.mul(pool.accRewardPerShare).div(1e12);
      pending = pending.add(rewardDebt.sub(user.rewardDebt));
      user.rewardDebt = rewardDebt;
    }
    _mint(_user, pending);
  }
}