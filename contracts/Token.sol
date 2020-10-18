pragma solidity 0.5.16;

import "./MultiSendableToken.sol";

contract Token is MultiSendableToken {
    constructor() public {
        _init("TEST token", "TESTONE", 18, 1 * 10**9 * 10**18);
    }
}