pragma solidity 0.5.16;

import "./IBEP20.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

// Gas cost = 553591 gas for deploying (0.03875137 ETH at 70Gwei)
contract MultiSendWallet is Ownable {
    using SafeMath for uint256;

    constructor(address _owner) public {
        _transferOwnership(_owner);
    }

    function multiTransferERC20TightlyPacked(
        address _token,
        bytes32[] memory _addressesAndAmounts,
        uint8 _inputDecimals
    ) public onlyOwner returns (bool) {
        for (uint256 i = 0; i < _addressesAndAmounts.length; i++) {
            IBEP20 token = IBEP20(_token);
            address to = address(uint256(_addressesAndAmounts[i]));
            uint8 boost = token.decimals() - _inputDecimals;
            uint256 amount = uint256(uint96(bytes12(_addressesAndAmounts[i])))
                .mul(10**uint256(boost));
            require(token.transfer(to, amount));
        }
    }

    function multiTransferERC20(
        address token,
        address[] memory _contributors,
        uint256[] memory _amounts
    ) public onlyOwner returns (bool) {
        require(_contributors.length == _amounts.length, "length is mismatch");
        for (uint256 i = 0; i < _contributors.length; i++) {
            require(IBEP20(token).transfer(_contributors[i], _amounts[i]));
        }
    }

    // The contract doesn't allow receiving Ether.
    function() external {
        revert();
    }
}
