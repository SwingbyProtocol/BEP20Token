pragma solidity 0.5.16;

import "./MultiSendableToken.sol";
import "./IBEP20.sol";

contract TokenMultiSendWrapper is MultiSendableToken {
    event Deposit(address indexed _from, address indexed _to, uint256 _amount);
    event Withdraw(address indexed _from, address indexed _to, uint256 _amount);
    // Define token address for wrapping.
    IBEP20 public token;

    function deposit(uint256 _amount) public returns (bool) {
        require(
            token.transferFrom(msg.sender, address(this), _amount),
            "deposit error"
        );
        _mint(msg.sender, _amount);
        emit Deposit(msg.sender, address(this), _amount);
        return true;
    }

    function withdraw(uint256 _amount) public returns (bool) {
        _burn(msg.sender, _amount);
        require(token.transfer(msg.sender, _amount), "withdraw error");
        emit Withdraw(address(this), msg.sender, _amount);
        return true;
    }
}
