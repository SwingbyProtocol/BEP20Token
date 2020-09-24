pragma solidity 0.5.16;

contract ITokenManager {
    function approveBind(address contractAddr, string memory bep2Symbol)
        public
        payable
        returns (bool);
}
