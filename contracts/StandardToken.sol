////// [low] Consider upgrading to newer version
pragma solidity ^0.4.8;

import "./ERC20.sol";

contract StandardToken is ERC20 {
    ////// [critical] Consider using Safe Math 
    ////// [low] return var is named, but using 'return true' statement instead of 'success = true;'
    ////// [low] Add onlyPayloadSize check
    function transfer(address _to, uint _value) returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    ////// [critical] Consider using Safe Math 
    ////// [low] return var is named, but using 'return true' statement instead of 'success = true;'
    function transferFrom(address _from, address _to, uint _value) returns (bool success) {
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    ////// [low] return var is named, but using 'return true' statement instead of 'success = true;'
    function balanceOf(address _owner) constant returns (uint balance) {
        return balances[_owner];
    }

    ////// [medium] https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    function approve(address _spender, uint _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    ////// [low] return var is named, but using 'return true' statement instead of 'success = true;'
    function allowance(address _owner, address _spender) constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
}
