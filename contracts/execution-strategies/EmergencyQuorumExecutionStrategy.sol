// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import { IExecutionStrategy } from "../interfaces/IExecutionStrategy.sol";
import { FinalizationStatus, Proposal, ProposalStatus } from "../types.sol";
import { SpaceManager } from "../utils/SpaceManager.sol";

import "fhevm/lib/TFHE.sol";

abstract contract EmergencyQuorumExecutionStrategy is IExecutionStrategy, SpaceManager {
    uint256 public quorum;
    uint256 public emergencyQuorum;

    event QuorumUpdated(uint256 _quorum);
    event EmergencyQuorumUpdated(uint256 _emergencyQuorum);

    /// @dev Initializer
    // solhint-disable-next-line func-name-mixedcase
    function __EmergencyQuorumExecutionStrategy_init(
        uint256 _quorum,
        uint256 _emergencyQuorum
    ) internal onlyInitializing {
        quorum = _quorum;
        emergencyQuorum = _emergencyQuorum;
    }

    function setQuorum(uint256 _quorum) external onlyOwner {
        quorum = _quorum;
        emit QuorumUpdated(_quorum);
    }

    function setEmergencyQuorum(uint256 _emergencyQuorum) external onlyOwner {
        emergencyQuorum = _emergencyQuorum;
        emit EmergencyQuorumUpdated(_emergencyQuorum);
    }

    function execute(       //@votePower
        uint256 proposalId,
        Proposal memory proposal,
        euint32 votesFor,
        euint32 votesAgainst,
        euint32 votesAbstain,
        bytes memory payload
    ) external virtual override;

    // solhint-disable-next-line code-complexity
    function getProposalStatus(     //@votePower
        Proposal memory proposal,
        euint32 votesFor,
        euint32 votesAgainst,
        euint32 votesAbstain
    ) public view override returns (ProposalStatus) {
        bool emergencyQuorumReached = _quorumReached(emergencyQuorum, votesFor, votesAbstain);

        bool accepted = _quorumReached(quorum, votesFor, votesAbstain) && _supported(votesFor, votesAgainst);

        if (proposal.finalizationStatus == FinalizationStatus.Cancelled) {
            return ProposalStatus.Cancelled;
        } else if (proposal.finalizationStatus == FinalizationStatus.Executed) {
            return ProposalStatus.Executed;
        } else if (block.number < proposal.startBlockNumber) {
            return ProposalStatus.VotingDelay;
        } else if (emergencyQuorumReached) {
            if (_supported(votesFor, votesAgainst)) {
                // Proposal is supported
                if (block.number < proposal.maxEndBlockNumber) {
                    // New votes can still come in so return `VotingPeriodAccepted`.
                    return ProposalStatus.VotingPeriodAccepted;
                } else {
                    // No new votes can't come in, so it's definitely accepted.
                    return ProposalStatus.Accepted;
                }
            } else {
                // Proposal is not supported
                if (block.number < proposal.maxEndBlockNumber) {
                    // New votes might still come in so return `VotingPeriod`.
                    return ProposalStatus.VotingPeriod;
                } else {
                    // New votes can't come in, so it's definitely rejected.
                    return ProposalStatus.Rejected;
                }
            }
        } else if (block.number < proposal.minEndBlockNumber) {
            // Proposal has not reached minEndBlockNumber yet.
            return ProposalStatus.VotingPeriod;
        } else if (block.number < proposal.maxEndBlockNumber) {
            // block number is between minEndBlockNumber and maxEndBlockNumber
            if (accepted) {
                return ProposalStatus.VotingPeriodAccepted;
            } else {
                return ProposalStatus.VotingPeriod;
            }
        } else if (accepted) {
            // Quorum reached and proposal supported: no new votes will come in so the proposal is
            // definitely  accepted.
            return ProposalStatus.Accepted;
        } else {
            // Quorum not reached reached or proposal supported: no new votes will come in so the proposal is
            // definitely rejected.
            return ProposalStatus.Rejected;
        }
    }

    function _quorumReached(uint256 _quorum, euint32 _votesFor, euint32 _votesAbstain) internal view returns (bool) {       //@votePower
        euint32 totalVotes = _votesFor + _votesAbstain;
        return TFHE.decrypt(TFHE.ge(totalVotes,TFHE.asEuint32(_quorum)));
    }

    function _supported(euint32 _votesFor, euint32 _votesAgainst) internal view returns (bool) {        //@votePower
        return TFHE.decrypt(TFHE.gt(_votesFor,_votesAgainst));
    }
}
