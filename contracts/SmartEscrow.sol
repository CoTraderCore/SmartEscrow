pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract SmartEscrow {

mapping(address => uint256) public orders;

address[] public tokens;


function createOrder(address _token, uint256 _amount) public {
  ERC20 token = ERC20(_token);

  token.transferFrom(msg.sender, address(this), _amount);

  orders[msg.sender] = _amount;
}

function execudeOrder(address _token) public {
  uint256 amount = orders[msg.sender];

  ERC20 token = ERC20(_token);

  token.transfer(msg.sender, orders[msg.sender]);

  orders[msg.sender] = 0;
}

}
