pragma solidity 0.5.16;

import "./MultiSendWallet.sol";

contract MultiSendWalletFactory {
    event Deployed(address wallet);

    function deployNewWallet(address _owner) public returns (address) {
        MultiSendWallet wallet = new MultiSendWallet(_owner);
        emit Deployed(address(wallet));
        return address(wallet);
    }

    // The contract doesn't allow receiving Ether.
    function() external {
        revert();
    }
}
