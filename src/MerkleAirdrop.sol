// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;

    error MerkleAirdrop__AlreadyClaimed();

    IERC20 private immutable i_token;
    bytes32 private immutable i_merkleRoot;
    // list
    address[] claimers;
    mapping(address claimer => bool claim) hasClaimed;

    constructor(address _token, bytes32 _merkleRoot) {
        i_token = IERC20(_token);
        i_merkleRoot = _merkleRoot;
    }

    function claimAirdrop() external {
        if (hasClaimed[msg.sender]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }
        bool claim = false;
        for (uint256 i = 0; i < claimers.length; i++) {
            if (claimers[i] == msg.sender) {
                claim = true;
                break;
            }
        }

        hasClaimed[msg.sender] = claim;

        if (claim) {
            i_token.safeTransfer(msg.sender, 10000);
        }
    }
}
