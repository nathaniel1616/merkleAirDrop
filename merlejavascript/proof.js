// import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
// import fs from "fs";
const { StandardMerkleTree } = require("@openzeppelin/merkle-tree");
const fs = require("fs");
// (1)
const tree = StandardMerkleTree.load(JSON.parse(fs.readFileSync("tree.json", "utf8")));

// (2)
for (const [i, v] of tree.entries()) {
    if (v[0] === '0x2222222222222222222222222222222222222222') {
        // (3)
        const proof = tree.getProof(i);
        console.log('Value:', v);
        console.log('Proof:', proof);
    }
}