pragma solidity 0.5.16;

import "./IBEP20.sol";
import "./SafeMath.sol";
import "./IERC900.sol";

contract Staking is IERC900 {
    using SafeMath for uint256;

    // Token used for staking
    IBEP20 stakingToken;

    uint256 public index;
    mapping(uint256 => Stake) public stakes;
    mapping(address => uint256) stakingFor;

    struct Stake {
        uint256 expiry;
        uint256 amount;
        address stakedFor;
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
        _unstake(_amount, _data);
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
     * @dev Helper function to create stakes for a given address
     * @param _address address The address the stake is being created for
     * @param _amount uint256 The number of tokens being staked
     * @param _data bytes optional data to include in the Stake event. We are using for locktime period for each staking.
     */
    function _stake(
        address _address,
        uint256 _amount,
        bytes memory _data
    ) internal canStake(msg.sender, _amount) {
        uint256 expiry = decodeBytes32ToUint256(_data);
        // TODO: validate timestamp
        stakes[index] = Stake(expiry, _amount, _address);
        index++;
        stakingFor[msg.sender] = stakingFor[msg.sender].add(_amount);
        // Staked event. the logger needs to decode event to time on client side.
        // Data == 0x + index + _data
        emit Staked(
            _address,
            _amount,
            totalStakedFor(_address),
            joinLogData(index, _data)
        );
    }

    function _unstake(uint256 _amount, bytes memory _data) internal {
        uint256 stakeID = decodeBytes32ToUint256(_data);
        Stake memory target = stakes[stakeID];
        // The target amount should be same as input amount.
        require(
            target.amount == _amount,
            "The unstake amount does not match the target amount"
        );
        require(
            stakingToken.transfer(msg.sender, _amount),
            "Unable to withdraw stake"
        );
        // Reduced staking amount of current staker.
        stakingFor[msg.sender] = stakingFor[msg.sender].sub(_amount);
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

    function decodeBytes32ToUint256(bytes memory _data)
        internal
        pure
        returns (uint256)
    {
        require(_data.length == 32, "slicing out of range");
        uint256 num;
        assembly {
            num := mload(add(_data, 0))
        }
        return num;
    }
}
