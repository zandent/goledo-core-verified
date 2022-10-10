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

interface IERC20Detailed is IERC20 {
  function name() external view returns (string memory);

  function symbol() external view returns (string memory);

  function decimals() external view returns (uint8);
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

interface IChefIncentivesController {
  
  function handleAction(
    address user,
    uint256 userBalance,
    uint256 totalSupply
  ) external;

  function addPool(address _token, uint256 _allocPoint) external;

  function claim(address _user, address[] calldata _tokens) external;

  function setClaimReceiver(address _user, address _receiver) external;

  struct UserInfo {
    uint256 amount;
    uint256 rewardDebt;
  }

  
  struct PoolInfo {
    uint256 totalSupply;
    uint256 allocPoint; 
    uint256 lastRewardTime; 
    uint256 accRewardPerShare; 
    address onwardIncentives;
  }

  function poolLength() external view returns (uint256);

  function rewardsPerSecond() external view returns (uint256);

  function totalAllocPoint() external view returns (uint256);

  function registeredTokens(uint256 _index) external view returns (address);

  function poolInfo(address _token) external view returns (PoolInfo memory);

  function userInfo(address _token, address _user) external view returns (UserInfo memory);
}

interface IMultiFeeDistribution {
  function addReward(address rewardsToken) external;

  function mint(
    address user,
    uint256 amount,
    bool withPenalty
  ) external;

  struct LockedBalance {
    uint256 amount;
    uint256 unlockTime;
  }
  struct RewardData {
    address token;
    uint256 amount;
  }

  function totalSupply() external view returns (uint256);

  function lockedSupply() external view returns (uint256);

  function stakingToken() external view returns (address);

  function claimableRewards(address account) external view returns (RewardData[] memory rewards);

  function totalBalance(address user) external view returns (uint256 amount);

  function unlockedBalance(address user) external view returns (uint256 amount);

  function earnedBalances(address user) external view returns (uint256 total, LockedBalance[] memory earningsData);

  function lockedBalances(address user)
    external
    view
    returns (
      uint256 total,
      uint256 unlockable,
      uint256 locked,
      LockedBalance[] memory lockData
    );

  function withdrawableBalance(address user) external view returns (uint256 amount, uint256 penaltyAmount);
}

interface IMasterChef {
  
  struct UserInfo {
    uint256 amount;
    uint256 rewardDebt;
  }

  
  struct PoolInfo {
    uint256 allocPoint; 
    uint256 lastRewardTime; 
    uint256 accRewardPerShare; 
    address onwardIncentives;
  }

  function poolLength() external view returns (uint256);

  function rewardsPerSecond() external view returns (uint256);

  function totalAllocPoint() external view returns (uint256);

  function registeredTokens(uint256 _index) external view returns (address);

  function poolInfo(address _token) external view returns (PoolInfo memory);

  function userInfo(address _token, address _user) external view returns (UserInfo memory);
}


contract IncentiveDataProvider {
  using SafeMath for uint256;

  IChefIncentivesController public incentiveController;
  IMasterChef public masterChef;
  IMultiFeeDistribution public multiFeeDistribution;

  struct UserIncentiveData {
    address token;
    string symbol;
    uint8 decimals;
    uint256 walletBalance;
    uint256 totalSupply;
    uint256 staked;
    uint256 claimable;
    uint256 allocPoint;
  }

  struct IncentivesData {
    uint256 totalAllocPoint;
    uint256 rewardsPerSecond;
  }

  struct UserStakeData {
    uint256 walletBalance;
    uint256 totalBalance;
    uint256 unlockedBalance;
    IMultiFeeDistribution.LockedBalance[] earnedBalances;
    IMultiFeeDistribution.LockedBalance[] lockedBalances;
    IMultiFeeDistribution.RewardData[] rewards;
  }

  struct StakeData {
    address token;
    string symbol;
    uint8 decimals;
    uint256 totalSupply;
    uint256 lockedSupply;
  }

  constructor(
    address _incentiveController,
    address _masterChef,
    address _multiFeeDistribution
  ) {
    incentiveController = IChefIncentivesController(_incentiveController);
    masterChef = IMasterChef(_masterChef);
    multiFeeDistribution = IMultiFeeDistribution(_multiFeeDistribution);
  }

  function getUserIncentive(address _account)
    external
    view
    returns (
      UserIncentiveData[] memory _controllerUserData,
      IncentivesData memory _controllerData,
      UserIncentiveData[] memory _chefUserData,
      IncentivesData memory _chefData,
      UserStakeData memory _stakeUserData,
      StakeData memory _stakeData
    )
  {
    (_controllerUserData, _controllerData) = _getIncentiveControllerData(_account);
    (_chefUserData, _chefData) = _getMasterChefData(_account);

    address _token = multiFeeDistribution.stakingToken();
    _stakeUserData.walletBalance = IERC20(_token).balanceOf(_account);
    _stakeUserData.totalBalance = multiFeeDistribution.totalBalance(_account);
    _stakeUserData.unlockedBalance = multiFeeDistribution.unlockedBalance(_account);
    (, _stakeUserData.earnedBalances) = multiFeeDistribution.earnedBalances(_account);
    (, , , _stakeUserData.lockedBalances) = multiFeeDistribution.lockedBalances(_account);
    _stakeUserData.rewards = multiFeeDistribution.claimableRewards(_account);
    _stakeData.token = _token;
    _stakeData.decimals = IERC20Detailed(_token).decimals();
    _stakeData.symbol = IERC20Detailed(_token).symbol();
    _stakeData.totalSupply = multiFeeDistribution.totalSupply();
    _stakeData.lockedSupply = multiFeeDistribution.lockedSupply();
  }

  function _getIncentiveControllerData(address _account)
    internal
    view
    returns (UserIncentiveData[] memory _controllerUserData, IncentivesData memory _controllerData)
  {
    uint256 _length = incentiveController.poolLength();
    _controllerData.rewardsPerSecond = incentiveController.rewardsPerSecond();
    _controllerData.totalAllocPoint = incentiveController.totalAllocPoint();
    _controllerUserData = new UserIncentiveData[](_length);
    for (uint256 i = 0; i < _length; i++) {
      IChefIncentivesController.PoolInfo memory pool;
      IChefIncentivesController.UserInfo memory user;
      {
        address _token = incentiveController.registeredTokens(i);
        pool = incentiveController.poolInfo(_token);
        user = incentiveController.userInfo(_token, _account);
        _controllerUserData[i].token = _token;
        _controllerUserData[i].decimals = IERC20Detailed(_token).decimals();
        _controllerUserData[i].symbol = IERC20Detailed(_token).symbol();
        _controllerUserData[i].walletBalance = IERC20(_token).balanceOf(_account);
      }
      _controllerUserData[i].staked = user.amount;
      _controllerUserData[i].totalSupply = pool.totalSupply;
      _controllerUserData[i].allocPoint = pool.allocPoint;

      uint256 accRewardPerShare = pool.accRewardPerShare;
      if (block.timestamp > pool.lastRewardTime && pool.totalSupply != 0) {
        uint256 reward = ((block.timestamp - pool.lastRewardTime) *
          _controllerData.rewardsPerSecond *
          pool.allocPoint) / _controllerData.totalAllocPoint;
        accRewardPerShare += (reward * 1e12) / pool.totalSupply;
      }
      _controllerUserData[i].claimable = user.amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
    }
  }

  function _getMasterChefData(address _account)
    internal
    view
    returns (UserIncentiveData[] memory _chefUserData, IncentivesData memory _chefData)
  {
    uint256 _length = masterChef.poolLength();
    _chefData.rewardsPerSecond = masterChef.rewardsPerSecond();
    _chefData.totalAllocPoint = masterChef.totalAllocPoint();
    _chefUserData = new UserIncentiveData[](_length);
    for (uint256 i = 0; i < _length; i++) {
      IMasterChef.PoolInfo memory pool;
      IMasterChef.UserInfo memory user;
      {
        address _token = masterChef.registeredTokens(i);
        pool = masterChef.poolInfo(_token);
        user = masterChef.userInfo(_token, _account);
        _chefUserData[i].token = _token;
        _chefUserData[i].decimals = IERC20Detailed(_token).decimals();
        _chefUserData[i].symbol = IERC20Detailed(_token).symbol();
        _chefUserData[i].totalSupply = IERC20(_token).balanceOf(address(masterChef));
        _chefUserData[i].walletBalance = IERC20(_token).balanceOf(_account);
      }
      _chefUserData[i].staked = user.amount;
      _chefUserData[i].allocPoint = pool.allocPoint;

      uint256 accRewardPerShare = pool.accRewardPerShare;
      if (block.timestamp > pool.lastRewardTime && _chefUserData[i].totalSupply != 0) {
        uint256 duration = block.timestamp.sub(pool.lastRewardTime);
        uint256 reward = (duration * _chefData.rewardsPerSecond * pool.allocPoint) / _chefData.totalAllocPoint;
        accRewardPerShare += (reward * 1e12) / _chefUserData[i].totalSupply;
      }
      _chefUserData[i].claimable = user.amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
    }
  }
}