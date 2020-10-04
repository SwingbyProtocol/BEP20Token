pragma solidity 0.5.16;

import "./BEP20Token.sol";

contract MultiSendableToken is BEP20Token {
    constructor() public {}

    event MultiERC20Transfer(
        address indexed _from,
        uint256 indexed _value,
        address _to,
        uint256 _amount
    );

    function multiERC20TransferTightlyPacked(
        bytes32[] memory _addressesAndAmounts
    ) public payable {
        for (uint256 i = 0; i < _addressesAndAmounts.length; i++) {
            address to = address(bytes20(_addressesAndAmounts[i] >> 96));
            uint256 amount = uint256(uint96(bytes12(_addressesAndAmounts[i])));
            require(to != address(0));
            _transfer(msg.sender, to, amount);
            emit MultiERC20Transfer(msg.sender, msg.value, to, amount);
        }
    }
}
