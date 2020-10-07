pragma solidity 0.5.16;

import "./IBEP20.sol";
import "./Ownable.sol";

// Gas cost = 564385 gas for deploying (0.03950695 ETH at 70Gwei)
contract MultiSendWallet is Ownable {
    event MultiTransferERC20Token(
        address indexed _from,
        address indexed _to,
        uint256 _amount
    );

    constructor(address _owner) public {
        _transferOwnership(_owner);
    }

    function multiTransferERC20(
        address token,
        bytes32[] memory _addressesAndAmounts
    ) public onlyOwner returns (bool) {
        for (uint256 i = 0; i < _addressesAndAmounts.length; i++) {
            address to = address(uint256(bytes32(_addressesAndAmounts[i])));
            uint256 amount = uint256(uint96(bytes12(_addressesAndAmounts[i])));
            require(IBEP20(token).transfer(to, amount));
            emit MultiTransferERC20Token(msg.sender, to, amount);
        }
    }

    // Ether refund
    function() external {
        revert();
    }
}
