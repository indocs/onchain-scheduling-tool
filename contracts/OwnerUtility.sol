// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";

// Lightweight utility to allow the current owner to transfer ownership via a dedicated function.
// This can help tests or scripts that want to programmatically transfer ownership
// without relying on internal Ownable interfaces.
contract OwnerUtility is Ownable {
    // Transfer ownership to a new owner. This simply delegates to the existing Ownable
    // transferOwnership function but exposes it through a clearly named function.
    function adminTransferOwnership(address newOwner) external onlyOwner {
        transferOwnership(newOwner);
    }
}
