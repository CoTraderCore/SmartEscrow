pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./KyberNetworkInterface.sol";

contract SmartEscrow {

mapping(address => uint256) public orders;

address[] public tokens;

// Kyber helps to figure out the ratio beetwen A and B token
KyberNetworkInterface kyber;

constructor(address _kyber) public {
  kyber = KyberNetworkInterface(_kyber);
}


function createOrder(address _token, uint256 _amount) public {
  ERC20 token = ERC20(_token);

  token.transferFrom(msg.sender, address(this), _amount);

  orders[msg.sender] = _amount;
}

function getValue(address _tokenA, address _tokenB, uint256 _value) public view returns(uint256){
  (uint256 expectedRate, ) = kyber.getExpectedRate(ERC20(_tokenA), ERC20(_tokenB), _value);

  return expectedRate;
}


function execudeOrder(address _tokenA, address _tokenB) public {
  uint256 amount = orders[msg.sender];

  ERC20 token = ERC20(_tokenB);

  uint256 _value = getValue(_tokenA, _tokenB, orders[msg.sender]);

  token.transfer(msg.sender, _value);

  orders[msg.sender] = 0;
}

}
