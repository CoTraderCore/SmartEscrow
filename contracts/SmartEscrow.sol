pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./KyberNetworkInterface.sol";


contract SmartEscrow {

using SafeMath for uint256;

struct Orders{
  uint256 price;
  uint256 amount;
  address TokenA;
  address TokenB;
  address receiver;
}

mapping(address => Orders) public orders;

address[] public AllOrders;

// Kyber helps to figure out the ratio beetwen A and B token
KyberNetworkInterface kyber;

constructor(address _kyber) public {
  kyber = KyberNetworkInterface(_kyber);
}

/*
* @dev create order send A token to contract
*/
// Need approve before execude
function createOrder(address _tokenA, address _tokenB, uint256 A_amount) public {
  ERC20 tokenA = ERC20(_tokenA);

  require(tokenA.transferFrom(msg.sender, address(this), A_amount));

  var order = orders[msg.sender];

  uint256 _value = getValue(_tokenA, _tokenB, A_amount);

  order.price = _value;
  order.amount = A_amount;
  order.TokenA = _tokenA;
  order.TokenB = _tokenB;
  order.receiver = msg.sender;


  AllOrders.push(msg.sender) -1;
}

/*
* @dev get rate ot tokens A/B in Keber exchange
*/
function getValue(address _tokenA, address _tokenB, uint256 A_value) public view returns(uint256){
  (uint256 expectedRate, ) = kyber.getExpectedRate(ERC20(_tokenA), ERC20(_tokenB), A_value);

  return expectedRate;
}

/*
* @dev get all curent orders
*/
function getAllOrdersAddress() view public returns (address[]) {
  return AllOrders;
}

/*
* @dev get rate A/B in Kyber by order address if order price and curent price
* does not match -/+ 5% in Kyber return false
*/
// Need approve before execude
function priceCorrectness(address _orderAddress)
view
public
returns (bool) {
  var order = orders[_orderAddress];

  uint256 curentPrice = getValue(order.TokenA, order.TokenB, order.amount);
  uint256 fivePercent = order.price.div(100).mul(5);
  uint256 maxPrice = order.price.add(fivePercent);
  uint256 minPrice = order.price.sub(fivePercent);

  if(curentPrice > maxPrice || curentPrice < minPrice){
    return false;
  }else{
    return true;
  }
}

/*
* @dev Ececude order send A to B and B to A
*/
function execudeOrder(uint256 B_value, address _orderAddress) public {
  // Exception if curent price not relevant -/+ 5% of Kyber
  require(priceCorrectness(_orderAddress));

  var order = orders[_orderAddress];

  require(order.amount != 0);

  ERC20 tokenA = ERC20(order.TokenA);
  ERC20 tokenB = ERC20(order.TokenB);

  // Get value A in B rate
  uint256 A_value = getValue(order.TokenB, order.TokenA, B_value);

  require(A_value <= order.amount);
  // Send B token to contract
  require(tokenB.transferFrom(msg.sender, address(this), B_value));
  // Send A token to B user from contract
  require(tokenA.transfer(msg.sender, A_value));
  // SEnd B token to A user from contract
  require(tokenB.transfer(_orderAddress, B_value));

  order.amount = order.amount.sub(A_value);
}

}
