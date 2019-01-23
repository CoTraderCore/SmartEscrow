pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract KyberNetworkInterface {
  function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
    returns (uint expectedRate, uint slippageRate);
}
