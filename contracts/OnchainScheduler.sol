// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";

// A lightweight on-chain scheduler. This incremental change adds a simple pause mechanism
// controlled by the contract owner. The pause state is exposed via isPaused() and can be
// toggled with pause() and unpause().

contract OnchainScheduler is Ownable {
    // NOTE: Existing storage layout is preserved for compatibility. This introduces a
    // non-intrusive pause flag used by new administrative functions.
    bool private _paused;

    // Events for pause state changes
    event Paused(address account);
    event Unpaused(address account);

    constructor() {
        // _paused is false by default; no changes needed here beyond explicit declaration.
    }

    // Administrative: pause the contract
    function pause() external onlyOwner {
        require(!_paused, "OnchainScheduler: already paused");
        _paused = true;
        emit Paused(msg.sender);
    }

    // Administrative: unpause the contract
    function unpause() external onlyOwner {
        require(_paused, "OnchainScheduler: not paused");
        _paused = false;
        emit Unpaused(msg.sender);
    }

    // Public read accessor for the pause state
    function isPaused() external view returns (bool) {
        return _paused;
    }

    // ... existing scheduler logic remains unchanged ...
}
