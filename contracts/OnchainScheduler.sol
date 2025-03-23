// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./Pausable.sol";

// Onchain scheduling tool (simplified for incremental security tightening)
contract OnchainScheduler is Ownable, Pausable {
    struct Task {
        address target;
        uint256 timestamp;
        bool executed;
    }

    mapping(uint256 => Task) public tasks;
    uint256 public nextTaskId;

    event TaskScheduled(uint256 indexed taskId, address indexed target, uint256 timestamp);
    event TaskExecuted(uint256 indexed taskId);

    // Basic function to schedule a task; public but guarded by pause state
    function schedule(address target, uint256 timestamp) external whenNotPaused {
        require(target != address(0), "Invalid target");
        require(timestamp > block.timestamp, "Timestamp in the past");

        uint256 id = nextTaskId++;
        tasks[id] = Task({target: target, timestamp: timestamp, executed: false});
        emit TaskScheduled(id, target, timestamp);
    }

    // Execute a scheduled task if time reached
    function execute(uint256 taskId) external whenNotPaused {
        Task storage t = tasks[taskId];
        require(!t.executed, "Already executed");
        require(block.timestamp >= t.timestamp, "Too early");
        t.executed = true;
        (bool success, ) = t.target.call("");
        require(success, "Execution failed");
        emit TaskExecuted(taskId);
    }

    // Security enhancement: emergency pause / unpause controls are kept in Pausable
    // but we add an explicit emergencyPause available only to the owner for rapid defense
    function emergencyPause() external onlyOwner {
        _pause();
    }

    // Emergency unpause to restore operations after threat remediation
    function emergencyUnpause() external onlyOwner {
        _unpause();
    }
}
