// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import { IProposalValidationStrategy } from "../interfaces/IProposalValidationStrategy.sol";

/// @title Vanilla Proposal Validation Strategy
contract VanillaProposalValidationStrategy is IProposalValidationStrategy {
    function validate(
        address, // author,
        bytes calldata, // params,
        bytes calldata // userParams
    ) external override returns (bool) {
        return true;
    }
}
