// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import { IExecutionStrategy } from "../interfaces/IExecutionStrategy.sol";
import { FinalizationStatus, Proposal, ProposalStatus } from "../types.sol";
import { SpaceManager } from "../utils/SpaceManager.sol";

import "fhevm/lib/TFHE.sol";

/// @title Simple Quorum Base Execution Strategy
abstract contract SimpleQuorumExecutionStrategy is IExecutionStrategy, SpaceManager {
    event QuorumUpdated(uint256 newQuorum);

    /// @notice The quorum required to execute a proposal using this strategy.
    uint256 public quorum;

    /// @dev Initializer
    // solhint-disable-next-line func-name-mixedcase
    function __SimpleQuorumExecutionStrategy_init(uint256 _quorum) internal onlyInitializing {
        quorum = _quorum;
    }

    function setQuorum(uint256 _quorum) external onlyOwner {
        quorum = _quorum;
        emit QuorumUpdated(_quorum);
    }

    function execute(           //@votePower
        uint256 proposalId,
        Proposal memory proposal,
        euint32 votesFor,
        euint32 votesAgainst,
        euint32 votesAbstain,
        bytes memory payload
    ) external virtual;

    /// @notice Returns the status of a proposal that uses a simple quorum.
    ///        A proposal is accepted if the for votes exceeds the against votes
    ///        and a quorum of (for + abstain) votes is reached.
    /// @param proposal The proposal struct.
    /// @param votesFor The number of votes for the proposal.
    /// @param votesAgainst The number of votes against the proposal.
    /// @param votesAbstain The number of votes abstaining from the proposal.
    function getProposalStatus(                 //@votePower
        Proposal memory proposal,
        euint32 votesFor,
        euint32 votesAgainst,
        euint32 votesAbstain
    ) public view override returns (ProposalStatus) {
        bool accepted = _quorumReached(quorum, votesFor, votesAbstain) && _supported(votesFor, votesAgainst);
        if (proposal.finalizationStatus == FinalizationStatus.Cancelled) {
            return ProposalStatus.Cancelled;
        } else if (proposal.finalizationStatus == FinalizationStatus.Executed) {
            return ProposalStatus.Executed;
        } else if (block.number < proposal.startBlockNumber) {
            return ProposalStatus.VotingDelay;
        } else if (block.number < proposal.minEndBlockNumber) {
            return ProposalStatus.VotingPeriod;
        } else if (block.number < proposal.maxEndBlockNumber) {
            if (accepted) {
                return ProposalStatus.VotingPeriodAccepted;
            } else {
                return ProposalStatus.VotingPeriod;
            }
        } else if (accepted) {
            return ProposalStatus.Accepted;
        } else {
            return ProposalStatus.Rejected;
        }
    }

    function _quorumReached(uint256 _quorum, euint32 _votesFor, euint32 _votesAbstain) internal view returns (bool) {           //@votePower
        euint32 forAndAbstainVotesTotal = _votesFor + _votesAbstain;
        return TFHE.decrypt(TFHE.ge(forAndAbstainVotesTotal,TFHE.asEuint8(_quorum)));
    }

    function _supported(euint32 _votesFor, euint32 _votesAgainst) internal view returns (bool) {            //@votePower
        return TFHE.decrypt(TFHE.gt(_votesFor,_votesAgainst));
    }

    function getStrategyType() external view virtual override returns (string memory);
}
