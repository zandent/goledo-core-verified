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

contract MerkleDistributor is Ownable {
  using SafeMath for uint256;

  struct ClaimRecord {
    bytes32 merkleRoot;
    uint256 validUntil;
    uint256 total;
    uint256 claimed;
  }

  uint256 public immutable maxMintableTokens;
  uint256 public mintedTokens;
  uint256 public reservedTokens;
  uint256 public immutable startTime;
  uint256 public constant duration = 86400 * 365;
  uint256 public constant minDuration = 86400 * 7;

  IMultiFeeDistribution public rewardMinter;

  ClaimRecord[] public claims;

  event Claimed(address indexed account, uint256 indexed merkleIndex, uint256 index, uint256 amount, address receiver);

  
  mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMap;

  constructor(IMultiFeeDistribution _rewardMinter, uint256 _maxMintable) Ownable() {
    rewardMinter = _rewardMinter;
    maxMintableTokens = _maxMintable;
    startTime = block.timestamp;
  }

  function mintableBalance() public view returns (uint256) {
    uint256 elapsedTime = block.timestamp.sub(startTime);
    if (elapsedTime > duration) elapsedTime = duration;
    return maxMintableTokens.mul(elapsedTime).div(duration).sub(mintedTokens).sub(reservedTokens);
  }

  function addClaimRecord(
    bytes32 _root,
    uint256 _duration,
    uint256 _total
  ) external onlyOwner {
    require(_duration >= minDuration);
    uint256 mintable = mintableBalance();
    require(mintable >= _total);

    claims.push(ClaimRecord({ merkleRoot: _root, validUntil: block.timestamp + _duration, total: _total, claimed: 0 }));
    reservedTokens = reservedTokens.add(_total);
  }

  function releaseExpiredClaimReserves(uint256[] calldata _claimIndexes) external {
    for (uint256 i = 0; i < _claimIndexes.length; i++) {
      ClaimRecord storage c = claims[_claimIndexes[i]];
      require(block.timestamp > c.validUntil, "MerkleDistributor: Drop still active.");
      reservedTokens = reservedTokens.sub(c.total.sub(c.claimed));
      c.total = 0;
      c.claimed = 0;
    }
  }

  function isClaimed(uint256 _claimIndex, uint256 _index) public view returns (bool) {
    uint256 claimedWordIndex = _index / 256;
    uint256 claimedBitIndex = _index % 256;
    uint256 claimedWord = claimedBitMap[_claimIndex][claimedWordIndex];
    uint256 mask = (1 << claimedBitIndex);
    return claimedWord & mask == mask;
  }

  function _setClaimed(uint256 _claimIndex, uint256 _index) private {
    uint256 claimedWordIndex = _index / 256;
    uint256 claimedBitIndex = _index % 256;
    claimedBitMap[_claimIndex][claimedWordIndex] =
      claimedBitMap[_claimIndex][claimedWordIndex] |
      (1 << claimedBitIndex);
  }

  function claim(
    uint256 _claimIndex,
    uint256 _index,
    uint256 _amount,
    address _receiver,
    bytes32[] calldata _merkleProof
  ) external {
    require(_claimIndex < claims.length, "MerkleDistributor: Invalid merkleIndex");
    require(!isClaimed(_claimIndex, _index), "MerkleDistributor: Drop already claimed.");

    ClaimRecord storage c = claims[_claimIndex];
    require(c.validUntil > block.timestamp, "MerkleDistributor: Drop has expired.");

    c.claimed = c.claimed.add(_amount);
    require(c.total >= c.claimed, "MerkleDistributor: Exceeds allocated total for drop.");

    reservedTokens = reservedTokens.sub(_amount);
    mintedTokens = mintedTokens.add(_amount);

    
    bytes32 node = keccak256(abi.encodePacked(_index, msg.sender, _amount));
    require(verify(_merkleProof, c.merkleRoot, node), "MerkleDistributor: Invalid proof.");

    
    _setClaimed(_claimIndex, _index);
    rewardMinter.mint(_receiver, _amount, true);

    emit Claimed(msg.sender, _claimIndex, _index, _amount, _receiver);
  }

  function verify(
    bytes32[] calldata _proof,
    bytes32 _root,
    bytes32 _leaf
  ) internal pure returns (bool) {
    bytes32 computedHash = _leaf;

    for (uint256 i = 0; i < _proof.length; i++) {
      bytes32 proofElement = _proof[i];

      if (computedHash <= proofElement) {
        
        computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
      } else {
        
        computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
      }
    }

    
    return computedHash == _root;
  }
}