pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./KyberNetworkInterface.sol";

contract SmartEscrow {

struct Orders{
  uint256 price;
  uint256 amount;
  address TokenA;
  address TokenB;
}

mapping(address => Orders) public orders;

address[] public AllOrders;

// Kyber helps to figure out the ratio beetwen A and B token
KyberNetworkInterface kyber;

constructor(address _kyber) public {
  kyber = KyberNetworkInterface(_kyber);
}


function createOrder(address _tokenA, address _tokenB, uint256 _amount) public {
  ERC20 token = ERC20(_token);

  token.transferFrom(msg.sender, address(this), _amount);

  var order = Orders[msg.sender];

  //uint256 _value = getValue(_tokenA, _tokenB, _amount);
  //order.price = _value;
  order.price = 10;
  order.amount = _amount;
  order.TokenA = _tokenA;
  order.TokenB = _tokenB;


  AllOrders.push(msg.sender) -1;
}

function getValue(address _tokenA, address _tokenB, uint256 _value) public view returns(uint256){
  (uint256 expectedRate, ) = kyber.getExpectedRate(ERC20(_tokenA), ERC20(_tokenB), _value);

  return expectedRate;
}

// Not finished
function execudeOrder(address _tokenA, address _tokenB) public {
  uint256 amount = orders[msg.sender];

  ERC20 token = ERC20(_tokenB);

  uint256 _value = getValue(_tokenA, _tokenB, orders[msg.sender]);

  token.transfer(msg.sender, _value);

  //orders[msg.sender] = 0;
}

}
