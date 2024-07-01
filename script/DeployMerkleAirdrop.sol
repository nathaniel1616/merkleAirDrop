// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {FunToken} from "../src/FunToken.sol";

contract DeployMerkleAirdrop is Script {
    MerkleAirdrop airdrop;
    FunToken token;
    bytes32 merkleRoot = 0x75e3755462de0e5625e24edd6c8a0994607124747793f194d9d1e467a69d2ab5;
    uint256 constant TOKEN_TO_MINT = 1000 ether;

    function run() external {
        vm.startBroadcast();
        token = new FunToken();
        airdrop = new MerkleAirdrop(address(token), merkleRoot);
        token.mint(address(airdrop), TOKEN_TO_MINT);
        vm.stopBroadcast();
    }
}
