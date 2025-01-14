// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import './Ownable.sol';

contract OnchainScheduler is Ownable {
    struct Schedule {
        uint256 executeAfter; // timestamp after which execution is allowed
        bool executed;
        string description;
    }

    // id -> schedule
    mapping(bytes32 => Schedule) private _schedules;

    event ScheduleCreated(bytes32 indexed id, uint256 executeAfter, string description);
    event Executed(bytes32 indexed id, address executor);

    modifier exists(bytes32 id) {
        require(_schedules[id].executeAfter != 0, 'Scheduler: id does not exist');
        _;
    }

    function createSchedule(bytes32 id, uint256 executeAfter, string memory description) external onlyOwner {
        require(executeAfter > block.timestamp, 'Scheduler: executeAfter must be in the future');
        Schedule storage s = _schedules[id];
        require(s.executeAfter == 0, 'Scheduler: id already exists');
        _schedules[id] = Schedule({executeAfter: executeAfter, executed: false, description: description});
        emit ScheduleCreated(id, executeAfter, description);
    }

    function batchExecute(bytes32[] calldata ids) external onlyOwner {
        for (uint i = 0; i < ids.length; i++) {
            bytes32 id = ids[i];
            Schedule storage s = _schedules[id];
            require(s.executeAfter != 0, 'Scheduler: id does not exist');
            require(!s.executed, 'Scheduler: already executed');
            require(block.timestamp >= s.executeAfter, 'Scheduler: too early to execute');
            s.executed = true;
            emit Executed(id, msg.sender);
        }
    }

    function getSchedule(bytes32 id) external view exists(id) returns (uint256 executeAfter, bool executed, string memory description) {
        Schedule storage s = _schedules[id];
        return (s.executeAfter, s.executed, s.description);
    }
}
