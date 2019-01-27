pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./KyberNetworkInterface.sol";

contract SmartEscrow {

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


function createOrder(address _tokenA, address _tokenB, uint256 _amount) public {
  ERC20 tokenA = ERC20(_tokenA);

  tokenA.transferFrom(msg.sender, address(this), _amount);

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
function execudeOrder(address _tokenA, address _tokenB, uint256 _value) public {

  ERC20 tokenA = ERC20(_tokenA);
  ERC20 tokenB = ERC20(_tokenB);

  var order = orders[msg.sender];

  // TODO convert correct rate
  //uint256 _value = getValue(_tokenA, _tokenB, order.amount);

  tokenB.transferFrom(msg.sender, address(this), _value);

  tokenA.transfer(msg.sender, _value);

  tokenB.transfer(order.receiver, _value);

  delete orders[msg.sender];
}

}
