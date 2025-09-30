// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "./Ownable.sol";

// A lightweight admin-annotation layer on top of Ownable.
// Owner can designate additional admin addresses who have elevated access
// to certain functions guarded by the onlyAdmin modifier.
// This is a small, self-contained utility contract to extend access control
// without modifying existing scheduling logic.
contract AdminOnly is Ownable {
    mapping(address => bool) private admins;

    event AdminUpdated(address indexed admin, bool enabled);

    modifier onlyAdmin() {
        require(isAdmin(msg.sender) || owner() == msg.sender, "AdminOnly: not an admin");
        _;
    }

    constructor() {
        // By default, the deployer is the owner; no admins until explicitly added.
    }

    function setAdmin(address admin, bool enabled) external onlyOwner {
        admins[admin] = enabled;
        emit AdminUpdated(admin, enabled);
    }

    function isAdmin(address addr) public view returns (bool) {
        return admins[addr];
    }
}
