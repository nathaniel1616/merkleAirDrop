// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract MerkleAirdropTest is Test {
    MerkleAirdrop merkleAirdrop;
    ERC20Mock token;
    bytes32 private merkleRoot = 0x75e3755462de0e5625e24edd6c8a0994607124747793f194d9d1e467a69d2ab5;
    bytes32 proofUser = 0xb92c48e9d7abe27fd8dfd6b5dfdbfb1c9a463f80c712b66f3a5180a090cccafc;

    bytes32[] private proof;
    uint256 public constant TOKEN_TO_MINT = 100 ether;
    address user = makeAddr("user");

    function setUp() public {
        token = new ERC20Mock();

        merkleAirdrop = new MerkleAirdrop(address(token), merkleRoot);

        token.mint(address(merkleAirdrop), TOKEN_TO_MINT);
    }

    function testClaimAirdrop() public {
        uint256 amountToMint = 5000000000000000000;
        proof.push(proofUser);
        // user initial token balance
        uint256 intialUserBalance = token.balanceOf(user);
        console.log("initial balance of user", intialUserBalance);
        vm.prank(user);

        merkleAirdrop.claimAirdrop(user, amountToMint, proof);

        // user final token balance
        uint256 finalUserBalance = token.balanceOf(user);
        console.log("final balance of user", finalUserBalance);
        assert(finalUserBalance > 0);
    }

    function testCannotClaimAirdropForFalseProof(bytes32 fakeProof) public {
        vm.assume(fakeProof != proofUser);
        uint256 amountToMint = 5000000000000000000;

        proof.push(fakeProof);
        // user initial token balance
        uint256 intialUserBalance = token.balanceOf(user);
        console.log("initial balance of user", intialUserBalance);
        vm.startPrank(user);
        vm.expectRevert(MerkleAirdrop.MerkleAirdrop__ProofVerifyFailed.selector);
        merkleAirdrop.claimAirdrop(user, amountToMint, proof);

        // user final token balance
        uint256 finalUserBalance = token.balanceOf(user);
        console.log("final balance of user", finalUserBalance);
        // assert(finalUserBalance > 0);
    }

    function testCannotClaimAirdropForFalseUser(address fakeUser) public {
        // vm.assume(fakeUser != user || fakeUser != address(0));
        if (fakeUser == user || fakeUser == address(0)) {
            return;
        }

        uint256 amountToMint = 5000000000000000000;

        proof.push(proofUser);
        // user initial token balance
        uint256 intialUserBalance = token.balanceOf(user);
        console.log("initial balance of user", intialUserBalance);
        vm.startPrank(fakeUser);
        // vm.expectRevert(MerkleAirdrop.MerkleAirdrop__ProofVerifyFailed.selector);
        merkleAirdrop.claimAirdrop(user, amountToMint, proof);

        // user final token balance
        uint256 finalUserBalance = token.balanceOf(user);
        console.log("final balance of user", finalUserBalance);
        assert(finalUserBalance > 0);
    }
}
