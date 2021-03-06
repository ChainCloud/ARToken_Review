////// [low] Consider upgrading to newer version
pragma solidity ^0.4.11;

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
  ////// [low] Non-initialized
  uint public totalSupply;

  function balanceOf(address _owner) constant returns (uint);
  function transfer(address _to, uint _value) returns (bool success);
  function transferFrom(address _from, address _to, uint _value) returns (bool success);
  function approve(address _spender, uint _value) returns (bool success);
  function allowance(address _owner, address _spender) constant returns (uint remaining);

  event Transfer(address indexed _from, address indexed _to, uint value);
  event Approval(address indexed _owner, address indexed _spender, uint value);
}
