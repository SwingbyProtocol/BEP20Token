pragma solidity 0.5.16;

import "./BEP20Token.sol";

contract MultiSendableToken is BEP20Token {
    event MultiTransfer(
        address indexed _from,
        address indexed _to,
        uint256 _amount
    );

    function multiTransferTightlyPacked(
        bytes32[] memory _addressesAndAmounts,
        uint8 _inputDecimals
    ) public payable {
        for (uint256 i = 0; i < _addressesAndAmounts.length; i++) {
            address to = address(uint160(uint256(_addressesAndAmounts[i])));
            uint8 boost = this.decimals() - _inputDecimals;
            require(boost >= 0, "boost should be >= 0");
            uint256 amount;
            if (boost == uint8(0)) {
                amount = uint256(uint96(bytes12(_addressesAndAmounts[i])));
            } else {
                amount = uint256(uint96(bytes12(_addressesAndAmounts[i]))).mul(
                    10**uint256(boost)
                );
            }
            _transfer(msg.sender, to, amount);
            emit MultiTransfer(msg.sender, to, amount);
        }
    }
}
