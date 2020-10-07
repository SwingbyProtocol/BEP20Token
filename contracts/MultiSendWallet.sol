pragma solidity 0.5.16;

import "./IBEP20.sol";
import "./Ownable.sol";

// Gas cost = 553085 gas for deploying (0.03871595 ETH at 70Gwei)
contract MultiSendWallet is Ownable {
    event MultiTransferBEP20Token(
        address indexed _from,
        address indexed _to,
        uint256 _amount
    );

    function multiTransferERC20(
        address token,
        bytes32[] memory _addressesAndAmounts
    ) public onlyOwner returns (bool) {
        for (uint256 i = 0; i < _addressesAndAmounts.length; i++) {
            address to = address(uint256(bytes32(_addressesAndAmounts[i])));
            uint256 amount = uint256(uint96(bytes12(_addressesAndAmounts[i])));
            require(to != address(0));
            IBEP20(token).transfer(to, amount);
            emit MultiTransferBEP20Token(msg.sender, to, amount);
        }
    }

    // Ether refund
    function() external {
        revert();
    }
}
