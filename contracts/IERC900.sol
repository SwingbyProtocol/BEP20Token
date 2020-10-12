pragma solidity 0.5.16;

/**
 * @title ERC900 Simple Staking Interface
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
 */

contract IERC900 {
    event Staked(
        address indexed user,
        uint256 amount,
        uint256 total,
        bytes data
    );
    event Unstaked(
        address indexed user,
        uint256 amount,
        uint256 total,
        bytes data
    );

    function stake(uint256 amount, bytes memory data) public;

    function stakeFor(
        address user,
        uint256 amount,
        bytes memory data
    ) public;

    function unstake(uint256 amount, bytes memory data) public;

    function totalStakedFor(address addr) public view returns (uint256);

    function totalStaked() public view returns (uint256);

    function token() public view returns (address);

    function supportsHistory() public pure returns (bool);
}
