pragma solidity 0.5.16;

import "./MultiSendWallet.sol";

contract MultiSendWalletFactory {
    function deployNewWallet(address _owner) public returns (address) {
        MultiSendWallet wallet = new MultiSendWallet(_owner);
        return address(wallet);
    }
}
