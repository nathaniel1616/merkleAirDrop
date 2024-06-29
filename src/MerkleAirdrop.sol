// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;
    using MerkleProof for bytes32[];

    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__ProofVerifyFailed();

    IERC20 private immutable i_token;
    bytes32 private immutable i_merkleRoot;
    // list
    address[] claimers;
    mapping(address claimer => bool claim) hasClaimed;

    event Claimed(address account, uint256 amount);

    constructor(address _token, bytes32 _merkleRoot) {
        i_token = IERC20(_token);
        i_merkleRoot = _merkleRoot;
    }

    function claimAirdrop(address account, uint256 amount, bytes32[] calldata proof) external {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        //// you can also use MerkleProof.verify(proof, i_merkleRoot, leaf)
        /// since are using MerkleProof for bytes32[];
        ///  it is a library function
        if (hasClaimed[msg.sender]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }
        if (!proof.verify(i_merkleRoot, leaf)) {
            revert MerkleAirdrop__ProofVerifyFailed();
        }

        hasClaimed[msg.sender] = true;
        emit Claimed(account, amount);

        // sent out the token
        i_token.safeTransfer(msg.sender, 10000);
    }

    // getter function

    function getMerkleRoot() public view returns (bytes32) {
        return i_merkleRoot;
    }

    function getTokenAddress() public view returns (address) {
        return address(i_token);
    }
}
