pragma solidity 0.5.16;

import "./MultiSendableToken.sol";

contract Token is MultiSendableToken {
    constructor() public {
        init("TEST token", "TESTONQ", 18, 1 * 10**9 * 10**18);
    }
}
