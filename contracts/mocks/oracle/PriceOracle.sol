pragma solidity 0.7.6;


interface IPriceOracle {
  
  function getAssetPrice(address asset) external view returns (uint256);

  
  function setAssetPrice(address asset, uint256 price) external;
}

contract PriceOracle is IPriceOracle {
  mapping(address => uint256) prices;
  uint256 ethPriceUsd;

  event AssetPriceUpdated(address _asset, uint256 _price, uint256 timestamp);
  event EthPriceUpdated(uint256 _price, uint256 timestamp);

  function getAssetPrice(address _asset) external view override returns (uint256) {
    return prices[_asset];
  }

  function setAssetPrice(address _asset, uint256 _price) external override {
    prices[_asset] = _price;
    emit AssetPriceUpdated(_asset, _price, block.timestamp);
  }

  function getEthUsdPrice() external view returns (uint256) {
    return ethPriceUsd;
  }

  function setEthUsdPrice(uint256 _price) external {
    ethPriceUsd = _price;
    emit EthPriceUpdated(_price, block.timestamp);
  }
}