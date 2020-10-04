pragma solidity 0.5.16;

import "./BEP20Token.sol";

contract Token is BEP20Token("TEST Token", "TEST", 18, 1 * 10**9 * 10**18) {
    constructor() public {}
}
