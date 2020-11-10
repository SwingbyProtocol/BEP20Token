pragma solidity 0.5.16;

contract ITokenHub {
    function transferOut(
        address contractAddr,
        address recipient,
        uint256 amount,
        uint64 expireTime
    ) external payable returns (bool);
}
