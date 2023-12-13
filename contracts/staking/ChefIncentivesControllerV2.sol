pragma solidity 0.7.6;
pragma abicoder v2;

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
contract NeedInitialize {
    bool public initialized;

    modifier onlyInitializeOnce() {
        require(!initialized, "NeedInitialize: already initialized");
        _;
        initialized = true;
    }
}
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract OwnableUpgradeable is NeedInitialize, Context {
    /// @custom:storage-location erc7201:openzeppelin.storage.Ownable
    struct OwnableStorage {
        address _owner;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Ownable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant OwnableStorageLocation = 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300;

    function _getOwnableStorage() private pure returns (OwnableStorage storage s) {
        assembly {
            s.slot := OwnableStorageLocation
        }
    }

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    // error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    // error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    function __Ownable_init(address initialOwner) internal onlyInitializeOnce {
        __Ownable_init_unchained(initialOwner);
    }

    function __Ownable_init_unchained(address initialOwner) internal onlyInitializeOnce {
        if (initialOwner == address(0)) {
            revert();
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        OwnableStorage storage s = _getOwnableStorage();
        return s._owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert();
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert();
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        OwnableStorage storage s = _getOwnableStorage();
        address oldOwner = s._owner;
        s._owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
contract ChefIncentivesControllerV2 is NeedInitialize, OwnableUpgradeable{
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  
  struct UserInfo {
    uint256 amount;
    uint256 rewardDebt;
  }
  
  struct PoolInfo {
    uint256 totalSupply;
    uint256 allocPoint; 
    uint256 lastRewardTime; 
    uint256 accRewardPerShare; 
    IOnwardIncentivesController onwardIncentives;
  }
  
  struct EmissionPoint {
    uint128 startTimeOffset;
    uint128 rewardsPerSecond;
  }
  struct UserInfoInput {
    address user;
    uint256 userBaseClaimable;
    address[] tokens;
    uint256[] amount;
    uint256[] rewardDebt;
  }
  address public poolConfigurator;

  IMultiFeeDistribution public rewardMinter;
  uint256 public rewardsPerSecond;
  uint256 public maxMintableTokens;
  uint256 public mintedTokens;

  
  address[] public registeredTokens;
  mapping(address => PoolInfo) public poolInfo;

  
  
  
  EmissionPoint[] public emissionSchedule;
  
  mapping(address => mapping(address => UserInfo)) public userInfo;
  
  mapping(address => uint256) public userBaseClaimable;
  
  uint256 public totalAllocPoint = 0;
  
  uint256 public startTime;

  
  
  
  mapping(address => address) public claimReceiver;

  event BalanceUpdated(address indexed token, address indexed user, uint256 balance, uint256 totalSupply);

  bool public _paused;
  modifier whenNotPaused() {
    _whenNotPaused();
    _;
  }
  modifier whenPaused() {
    _whenPaused();
    _;
  }

  function _whenNotPaused() internal view {
    require(!_paused, "It is paused");
  }
  function _whenPaused() internal view {
    require(_paused, "It is not paused");
  }
  function setPause(bool val) external onlyOwner {
    _paused = val;
  }
  function initialize(
    uint128[] memory _startTimeOffset,
    uint128[] memory _rewardsPerSecond,
    address _poolConfigurator,
    IMultiFeeDistribution _rewardMinter,
    uint256 _maxMintable,
    address _owner
  ) external onlyInitializeOnce {
    poolConfigurator = _poolConfigurator;
    rewardMinter = _rewardMinter;
    uint256 length = _startTimeOffset.length;
    for (uint256 i = length - 1; i + 1 != 0; i--) {
      emissionSchedule.push(
        EmissionPoint({ startTimeOffset: _startTimeOffset[i], rewardsPerSecond: _rewardsPerSecond[i] })
      );
    }
    maxMintableTokens = _maxMintable;
    _paused= true;
    __Ownable_init(_owner);
  }

  function setUserUserInfoInput(UserInfoInput[] memory userInfoInput) external onlyOwner whenPaused{
    for (uint256 i; i < userInfoInput.length; i++) {
      userBaseClaimable[userInfoInput[i].user] = userInfoInput[i].userBaseClaimable;
      for (uint256 j; j < userInfoInput[i].tokens.length; j++) {
        userInfo[userInfoInput[i].tokens[j]][userInfoInput[i].user] = UserInfo (
            {
              amount:userInfoInput[i].amount[j],
              rewardDebt:userInfoInput[i].rewardDebt[j]
            }
          );
      }
    }
  }

  function setUserUserInfo(UserInfoInput memory userInfoInput) external onlyOwner whenPaused{
      userBaseClaimable[userInfoInput.user] = userInfoInput.userBaseClaimable;
      for (uint256 j; j < userInfoInput.tokens.length; j++) {
        userInfo[userInfoInput.tokens[j]][userInfoInput.user] = UserInfo (
            {
              amount:userInfoInput.amount[j],
              rewardDebt:userInfoInput.rewardDebt[j]
            }
          );
      }
  }

  function setmintedTokens(uint256 _mintedTokens) public onlyOwner whenPaused{
    mintedTokens = _mintedTokens;
  }

  function start() public onlyOwner {
    require(startTime == 0);
    startTime = block.timestamp;
  }

  
  function addPool(address _token, uint256 _allocPoint) external {
    require(msg.sender == poolConfigurator || owner() == _msgSender());
    require(poolInfo[_token].lastRewardTime == 0);
    _updateEmissions();
    totalAllocPoint = totalAllocPoint.add(_allocPoint);
    registeredTokens.push(_token);
    poolInfo[_token] = PoolInfo({
      totalSupply: 0,
      allocPoint: _allocPoint,
      lastRewardTime: block.timestamp,
      accRewardPerShare: 0,
      onwardIncentives: IOnwardIncentivesController(0)
    });
  }
  function setpoolInfo(address _token, PoolInfo memory _poolInfo) public onlyOwner whenPaused {
    poolInfo[_token] = _poolInfo;
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
      uint256 lpSupply = pool.totalSupply;
      if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
        uint256 duration = block.timestamp.sub(pool.lastRewardTime);
        uint256 reward = duration.mul(rewardsPerSecond).mul(pool.allocPoint).div(totalAllocPoint);
        accRewardPerShare = accRewardPerShare.add(reward.mul(1e12).div(lpSupply));
      }
      claimable[i] = user.amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
    }
    return claimable;
  }
  function claimableRewardRate(address[] calldata _tokens) external view returns (uint256) {
    uint256 claimable = 0;
    for (uint256 i = 0; i < _tokens.length; i++) {
      address token = _tokens[i];
      PoolInfo storage pool = poolInfo[token];
      uint256 accRewardPerShare = pool.accRewardPerShare;
      uint256 lpSupply = pool.totalSupply;
      if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
        uint256 reward = rewardsPerSecond.mul(pool.allocPoint).div(totalAllocPoint);
        accRewardPerShare = accRewardPerShare.add(reward.mul(1e12).div(lpSupply));
      }
      claimable = claimable.add(accRewardPerShare.div(1e12));
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
      _updatePool(poolInfo[registeredTokens[i]], totalAP);
    }
  }

  
  function _updatePool(PoolInfo storage pool, uint256 _totalAllocPoint) internal {
    if (block.timestamp <= pool.lastRewardTime) {
      return;
    }
    uint256 lpSupply = pool.totalSupply;
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

  function handleAction(
    address _user,
    uint256 _balance,
    uint256 _totalSupply
  ) external {
    PoolInfo storage pool = poolInfo[msg.sender];
    require(pool.lastRewardTime > 0);
    _updateEmissions();
    _updatePool(pool, totalAllocPoint);
    UserInfo storage user = userInfo[msg.sender][_user];
    uint256 amount = user.amount;
    uint256 accRewardPerShare = pool.accRewardPerShare;
    if (amount > 0) {
      uint256 pending = amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
      if (pending > 0) {
        userBaseClaimable[_user] = userBaseClaimable[_user].add(pending);
      }
    }
    user.amount = _balance;
    user.rewardDebt = _balance.mul(accRewardPerShare).div(1e12);
    pool.totalSupply = _totalSupply;
    if (pool.onwardIncentives != IOnwardIncentivesController(0)) {
      pool.onwardIncentives.handleAction(msg.sender, _user, _balance, _totalSupply);
    }
    emit BalanceUpdated(msg.sender, _user, _balance, _totalSupply);
  }

  
  
  function claim(address _user, address[] calldata _tokens) external {
    _updateEmissions();
    uint256 pending = userBaseClaimable[_user];
    userBaseClaimable[_user] = 0;
    uint256 _totalAllocPoint = totalAllocPoint;
    for (uint256 i = 0; i < _tokens.length; i++) {
      PoolInfo storage pool = poolInfo[_tokens[i]];
      require(pool.lastRewardTime > 0);
      _updatePool(pool, _totalAllocPoint);
      UserInfo storage user = userInfo[_tokens[i]][_user];
      uint256 rewardDebt = user.amount.mul(pool.accRewardPerShare).div(1e12);
      pending = pending.add(rewardDebt.sub(user.rewardDebt));
      user.rewardDebt = rewardDebt;
    }
    _mint(_user, pending);
  }

  function syncEmissions(
    uint128[] memory _startTimeOffset,
    uint128[] memory _rewardsPerSecond
  )public onlyOwner {
    uint256 length = _startTimeOffset.length;
    require (length == _rewardsPerSecond.length, "input length not match");
    require (length == emissionSchedule.length, "length not match original");
    for (uint256 i = 0; i < length; i++) {
      emissionSchedule[length-1-i].startTimeOffset = _startTimeOffset[i];
      emissionSchedule[length-1-i].rewardsPerSecond = _rewardsPerSecond[i];
    }
  }
}