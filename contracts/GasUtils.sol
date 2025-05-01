// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Lightweight gas-optimizing utilities. Designed to be reusable by other contracts
// within this repo without pulling in heavy dependencies.
library GasUtils {
    // Safe-ish add using unchecked to reduce gas should the caller ensure no overflow.
    // This is intended for internal composition where overflow risk is externally controlled.
    function addU256(uint256 a, uint256 b) internal pure returns (uint256) {
        unchecked {
            return a + b;
        }
    }

    // Safe-ish sub using unchecked, with caller guaranteeing a >= b to avoid underflow.
    function subU256(uint256 a, uint256 b) internal pure returns (uint256) {
        unchecked {
            return a - b;
        }
    }
}
