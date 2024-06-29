// import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
const { StandardMerkleTree } = require("@openzeppelin/merkle-tree");

// import fs from "fs";
const fs = require("fs");

// (1)
const values = [
    ["0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D", "5000000000000000000"],
    ["0x2222222222222222222222222222222222222222", "2500000000000000000"]
];

// (2)
const tree = StandardMerkleTree.of(values, ["address", "uint256"]);

// (3)
console.log('Merkle Root:', tree.root);

// (4)
fs.writeFileSync("tree.json", JSON.stringify(tree.dump()));