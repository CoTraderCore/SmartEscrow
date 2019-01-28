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

// Need approve before execude
function createOrder(address _tokenA, address _tokenB, uint256 _amount) public {
  ERC20 tokenA = ERC20(_tokenA);

  require(tokenA.transferFrom(msg.sender, address(this), _amount));

  var order = orders[msg.sender];

  uint256 _value = getValue(_tokenA, _tokenB, _amount);

  order.price = _value;
  order.amount = _amount;
  order.TokenA = _tokenA;
  order.TokenB = _tokenB;
  order.receiver = msg.sender;


  AllOrders.push(msg.sender) -1;
}

function getValue(address _tokenA, address _tokenB, uint256 _value) public view returns(uint256){
  (uint256 expectedRate, ) = kyber.getExpectedRate(ERC20(_tokenA), ERC20(_tokenB), _value);

  return expectedRate;
}

function getAllOrdersAddress() view public returns (address[]) {
  return AllOrders;
}

// Not finished
// Need approve before execude
// TODO require compare input and order.price -/+ 5% of Kyber
function execudeOrder(address _tokenA, address _tokenB, uint256 _value, address _orderAddress) public {

  ERC20 tokenA = ERC20(_tokenA);
  ERC20 tokenB = ERC20(_tokenB);

  var order = orders[_orderAddress];

  require(tokenB.transferFrom(msg.sender, address(this), _value));

  require(tokenA.transfer(msg.sender, _value));

  require(tokenB.transfer(_orderAddress, _value));

  order.amount = order.amount.sub(_value);
}

}
