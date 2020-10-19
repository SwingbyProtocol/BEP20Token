pragma solidity 0.5.16;

import "./IBEP20.sol";
import "./SafeMath.sol";
import "./IERC900.sol";

contract Staking is IERC900 {
    using SafeMath for uint256;
    // Token used for staking
    IBEP20 stakingToken;

    uint256 public index;
    mapping(uint256 => Stake) private stakes;
    mapping(address => uint256) private stakingFor;
    // Set node info
    mapping(address => P2PInfo) private nodes;

    struct Stake {
        uint256 expiry;
        uint256 amount;
        address stakedFor;
    }

    struct P2PInfo {
        bytes32 pubkey;
        bytes32 rewardAddress;
    }

    /**
     * @dev Modifier that checks that this contract can transfer tokens from the
     *  balance in the stakingToken contract for the given address.
     * @dev This modifier also transfers the tokens.
     * @param _address address to transfer tokens from
     * @param _amount uint256 the number of tokens
     */
    modifier canStake(address _address, uint256 _amount) {
        require(
            stakingToken.transferFrom(_address, address(this), _amount),
            "Stake required"
        );
        _;
    }

    /**
     * @dev Constructor function
     * @param _stakingToken ERC20/BEP20 The address of the token contract used for staking
     */
    constructor(IBEP20 _stakingToken) public {
        stakingToken = _stakingToken;
        index = 0;
    }

    /**
     * @notice Stakes a certain amount of tokens, this MUST transfer the given amount from the user
     * @notice MUST trigger Staked event
     * @param _amount uint256 the amount of tokens to stake
     * @param _data bytes optional data to include in the Stake event
     */
    function stake(uint256 _amount, bytes memory _data) public {
        _stake(msg.sender, _amount, _data);
    }

    /**
     * @notice Stakes a certain amount of tokens, this MUST transfer the given amount from the caller
     * @notice MUST trigger Staked event
     * @param _user address the address the tokens are staked for
     * @param _amount uint256 the amount of tokens to stake
     * @param _data bytes optional data to include in the Stake event
     */
    function stakeFor(
        address _user,
        uint256 _amount,
        bytes memory _data
    ) public {
        _stake(_user, _amount, _data);
    }

    /**
     * @notice Unstakes a certain amount of tokens, this SHOULD return the given amount of tokens to the user, if unstaking is currently not possible the function MUST revert
     * @notice MUST trigger Unstaked event
     * @param _amount uint256 the amount of tokens to unstake
     * @param _data bytes optional data to include in the Unstake event
     */
    function unstake(uint256 _amount, bytes memory _data) public {
        _unstake(msg.sender, _amount, _data);
    }

    /**
     * @notice Returns the current total of tokens staked for an address
     * @param _address address The address to query
     * @return uint256 The number of tokens staked for the given address
     */
    function totalStakedFor(address _address) public view returns (uint256) {
        return stakingFor[_address];
    }

    /**
     * @notice Returns the current total of tokens staked
     * @return uint256 The number of tokens staked in the contract
     */
    function totalStaked() public view returns (uint256) {
        return stakingToken.balanceOf(address(this));
    }

    /**
     * @notice Address of the token being used by the staking interface
     * @return address The address of the ERC20 token used for staking
     */
    function token() public view returns (address) {
        return address(stakingToken);
    }

    function supportsHistory() public pure returns (bool) {
        return false;
    }

    /**
    @TODO: add getter for each stakes like function getStake(uint256 stakeID)
     */

    /**
     * @param _addr The address of validator set
     */
    function getNodeInfo(address _addr) public view returns (bytes32, bytes32) {
        P2PInfo memory info = nodes[_addr];
        return (info.pubkey, info.rewardAddress);
    }

    /**
     * @dev Helper function to create stakes for a given address
     * @param _address address The address the stake is being created for
     * @param _amount uint256 The number of tokens being staked
     * @param _data bytes optional data to include in the Stake event. We are using for locktime period for each stake.
     */
    function _stake(
        address _address,
        uint256 _amount,
        bytes memory _data
    ) internal canStake(_address, _amount) {
        (uint256 expiry, bytes32 pubkey, bytes32 rewardAddress) = decodeBytes(
            _data
        );
        // TODO: validate timestamp
        stakes[index] = Stake(expiry, _amount, _address);
        stakingFor[_address] = stakingFor[_address].add(_amount);

        // Update node info
        nodes[_address] = P2PInfo(pubkey, rewardAddress);

        // Staked event. the logger needs to decode event to time on client side.
        // Data == 0x + index + _data
        emit Staked(
            _address,
            _amount,
            totalStakedFor(_address),
            joinLogData(index, _data)
        );
        index++;
    }

    function _unstake(
        address _address,
        uint256 _amount,
        bytes memory _data
    ) internal {
        (uint256 stakeID, , ) = decodeBytes(_data);
        Stake memory target = stakes[stakeID];
        // The target amount should be same as input amount.
        require(
            target.amount == _amount,
            "The unstake amount does not match the target amount"
        );
        require(
            target.stakedFor == _address,
            "The address does not match the target address"
        );
        require(
            block.timestamp >= target.expiry,
            "The target stake is not expired"
        );
        require(
            stakingToken.transfer(target.stakedFor, _amount),
            "Unable to withdraw stake"
        );
        // Reduced staking amount of current staker.
        stakingFor[target.stakedFor] = stakingFor[target.stakedFor].sub(
            _amount
        );
        // Removed a stake and gas is refunded.
        delete (stakes[stakeID]);
        // Unstaked event. the logger needs to decode event to time on client side.
        // Data == 0x + stakeID
        emit Unstaked(
            target.stakedFor,
            _amount,
            totalStakedFor(target.stakedFor),
            _data
        );
    }

    function joinLogData(uint256 stakeID, bytes memory data)
        internal
        pure
        returns (bytes memory)
    {
        return abi.encodePacked(stakeID, data);
    }

    function decodeBytes(bytes memory _data)
        internal
        pure
        returns (
            uint256,
            bytes32,
            bytes32
        )
    {
        require(_data.length.mod(32) == 0, "slicing out of range");
        uint256 expiry;
        bytes32 pubkey;
        bytes32 rewardAddress;
        assembly {
            expiry := mload(add(_data, 32))
            pubkey := mload(add(_data, 64))
            rewardAddress := mload(add(_data, 96))
        }
        return (expiry, pubkey, rewardAddress);
    }
}
