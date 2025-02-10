// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * A lightweight pausable guard for use with existing contracts.
 * Provides internal functions to pause/unpause and modifiers to
 * restrict function execution when paused.
 * This is intentionally minimal to avoid pulling in heavy dependencies.
 */

abstract contract Pausable {
    bool private _paused;

    event Paused(address account);
    event Unpaused(address account);

    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    // Caller should implement access control for who can pause/unpause
    function _pause() internal whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    function _unpause() internal whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}
