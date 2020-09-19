pragma solidity 0.5.16;

import "./BEP20.sol";

contract Token is BEP20 {
    constructor() public {
        _name = "SWINGBY TEST Token";
        _symbol = "SWINGBY-888";
        _decimals = 18;
        _totalSupply = 1 * 10**9 * 10**18; // 1B tokens with decimals = 18
        _balances[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }
}
