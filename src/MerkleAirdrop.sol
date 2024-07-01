// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;
    using MerkleProof for bytes32[];

    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__ProofVerifyFailed();
    error MerkleAirdrop__SignatureInvalid();

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

    function claimAirdrop(
        address account,
        uint256 amount,
        bytes32[] calldata proof,
        bytes32 message,
        bytes memory signature
    ) external {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        address signer = ECDSA.recover(message, signature);
        //// you can also use MerkleProof.verify(proof, i_merkleRoot, leaf)
        /// since are using MerkleProof for bytes32[];
        ///  it is a library function

        if (hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }

        if (signer != account) {
            revert MerkleAirdrop__SignatureInvalid();
        }

        if (!proof.verify(i_merkleRoot, leaf)) {
            revert MerkleAirdrop__ProofVerifyFailed();
        }

        hasClaimed[account] = true;
        emit Claimed(account, amount);

        // sent out the token
        i_token.safeTransfer(account, amount);
    }

    // getter function

    function getMerkleRoot() public view returns (bytes32) {
        return i_merkleRoot;
    }

    function getTokenAddress() public view returns (address) {
        return address(i_token);
    }
}
