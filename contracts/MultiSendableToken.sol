pragma solidity 0.5.16;

import "./BEP20Token.sol";

contract MultiSendableToken is BEP20Token {
    event MultiTransfer(address indexed _from, address _to, uint256 _amount);

    function multiTransferTightlyPacked(bytes32[] memory _addressesAndAmounts)
        public
        payable
    {
        for (uint256 i = 0; i < _addressesAndAmounts.length; i++) {
            address to = address(uint256(bytes32(_addressesAndAmounts[i])));
            uint256 amount = uint256(uint96(bytes12(_addressesAndAmounts[i])));
            require(to != address(0));
            _transfer(msg.sender, to, amount);
            emit MultiTransfer(msg.sender, to, amount);
        }
    }
}
