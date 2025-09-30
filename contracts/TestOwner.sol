// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";

contract TestOwner is Ownable {
    function ownerSay(string memory g) public view onlyOwner returns (string memory) {
        return string(abi.encodePacked("owner-", g));
    }
}
