// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// A light utility to batch call methods on a target contract. This can be used to
// reduce overhead when performing multiple identical interactions from off-chain tooling.
// It is gas-intensive by nature and should be used with care, but provides a useful
// building block for incremental tooling improvements.
contract BatchCaller {
    event BatchCallExecuted(address indexed target, uint256 index, bool success);

    // Performs a batch of arbitrary calls to a target contract. Each entry in `data`
    // is the encoded function call data for the desired method on `target`.
    // Returns the raw return data for each call.
    function batchCall(address target, bytes[] calldata data) external returns (bytes[] memory results) {
        require(target != address(0), "BatchCaller: zero target");
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = target.call(data[i]);
            require(success, "BatchCaller: call failed");
            results[i] = result;
            emit BatchCallExecuted(target, i, success);
        }
    }
}
