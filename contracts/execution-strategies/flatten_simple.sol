// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/// @title Zodiac Avatar - A contract that manages modules that can execute transactions via this contract.

/// @title Enum - Collection of enums
/// @author Richard Meissner - <richard@gnosis.pm>
contract Enum {
    enum Operation {Call, DelegateCall}
}

interface IAvatar {
    /// @dev Enables a module on the avatar.
    /// @notice Can only be called by the avatar.
    /// @notice Modules should be stored as a linked list.
    /// @notice Must emit EnabledModule(address module) if successful.
    /// @param module Module to be enabled.
    function enableModule(address module) external;

    /// @dev Disables a module on the avatar.
    /// @notice Can only be called by the avatar.
    /// @notice Must emit DisabledModule(address module) if successful.
    /// @param prevModule Address that pointed to the module to be removed in the linked list
    /// @param module Module to be removed.
    function disableModule(address prevModule, address module) external;

    /// @dev Allows a Module to execute a transaction.
    /// @notice Can only be called by an enabled module.
    /// @notice Must emit ExecutionFromModuleSuccess(address module) if successful.
    /// @notice Must emit ExecutionFromModuleFailure(address module) if unsuccessful.
    /// @param to Destination address of module transaction.
    /// @param value Ether value of module transaction.
    /// @param data Data payload of module transaction.
    /// @param operation Operation type of module transaction: 0 == call, 1 == delegate call.
    function execTransactionFromModule(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation
    ) external returns (bool success);

    /// @dev Allows a Module to execute a transaction and return data
    /// @notice Can only be called by an enabled module.
    /// @notice Must emit ExecutionFromModuleSuccess(address module) if successful.
    /// @notice Must emit ExecutionFromModuleFailure(address module) if unsuccessful.
    /// @param to Destination address of module transaction.
    /// @param value Ether value of module transaction.
    /// @param data Data payload of module transaction.
    /// @param operation Operation type of module transaction: 0 == call, 1 == delegate call.
    function execTransactionFromModuleReturnData(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation
    ) external returns (bool success, bytes memory returnData);

    /// @dev Returns if an module is enabled
    /// @return True if the module is enabled
    function isModuleEnabled(address module) external view returns (bool);

    /// @dev Returns array of modules.
    /// @param start Start of the page.
    /// @param pageSize Maximum number of modules that should be returned.
    /// @return array Array of modules.
    /// @return next Start of the next page.
    function getModulesPaginated(address start, uint256 pageSize)
        external
        view
        returns (address[] memory array, address next);
}

/// @dev Constants used to replace the `bool` type in mappings for gas efficiency.
uint256 constant TRUE = 1;
uint256 constant FALSE = 0;

/// @notice The data stored for each proposal when it is created.
/// @dev Packed into 4 256-bit slots.
struct Proposal {
    // SLOT 1:
    // The address of the proposal creator.
    address author;
    // The block number at which the voting period starts.
    // This is also the snapshot block number where voting power is calculated at.
    uint32 startBlockNumber;
    //
    // SLOT 2:
    // The address of execution strategy used for the proposal.
    IExecutionStrategy executionStrategy;
    // The minimum block number at which the proposal can be finalized.
    uint32 minEndBlockNumber;
    // The maximum block number at which the proposal can be finalized.
    uint32 maxEndBlockNumber;
    // An enum that stores whether a proposal is pending, executed, or cancelled.
    FinalizationStatus finalizationStatus;
    //
    // SLOT 3:
    // The hash of the execution payload. We do not store the payload itself to save gas.
    bytes32 executionPayloadHash;
    //
    // SLOT 4:
    // Bit array where the index of each each bit corresponds to whether the voting strategy.
    // at that index is active at the time of proposal creation.
    uint256 activeVotingStrategies;
}

/// @notice The data stored for each strategy.
struct Strategy {
    // The address of the strategy contract.
    address addr;
    // The parameters of the strategy.
    bytes params;
}

/// @notice The data stored for each indexed strategy.
struct IndexedStrategy {
    uint8 index;
    bytes params;
}

/// @notice The set of possible finalization statuses for a proposal.
///         This is stored inside each Proposal struct.
enum FinalizationStatus {
    Pending,
    Executed,
    Cancelled
}

/// @notice The set of possible statuses for a proposal.
enum ProposalStatus {
    VotingDelay,
    VotingPeriod,
    VotingPeriodAccepted,
    Accepted,
    Executed,
    Rejected,
    Cancelled
}

/// @notice The set of possible choices for a vote.
// enum Choice {            // @Choice
//     Against,
//     For,
//     Abstain
// }

/// @notice Transaction struct that can be used to represent transactions inside a proposal.
struct MetaTransaction {
    address to;
    uint256 value;
    bytes data;
    Enum.Operation operation;
    // We require a salt so that the struct can always be unique and we can use its hash as a unique identifier.
    uint256 salt;
}

/// @dev    Structure used for the function `initialize` of the Space contract because of solidity's stack constraints.
///         For more information, see `ISpaceActions.sol`.
struct InitializeCalldata {
    address owner;
    uint32 votingDelay;
    uint32 minVotingDuration;
    uint32 maxVotingDuration;
    Strategy proposalValidationStrategy;
    string proposalValidationStrategyMetadataURI;
    string daoURI;
    string metadataURI;
    Strategy[] votingStrategies;
    string[] votingStrategyMetadataURIs;
    address[] authenticators;
}

/// @dev    Structure used for the function `updateSettings` of the Space contract because of solidity's stack constraints.
///         For more information, see `ISpaceOwnerActions.sol`.
struct UpdateSettingsCalldata {
    uint32 minVotingDuration;
    uint32 maxVotingDuration;
    uint32 votingDelay;
    string metadataURI;
    string daoURI;
    Strategy proposalValidationStrategy;
    string proposalValidationStrategyMetadataURI;
    address[] authenticatorsToAdd;
    address[] authenticatorsToRemove;
    Strategy[] votingStrategiesToAdd;
    string[] votingStrategyMetadataURIsToAdd;
    uint8[] votingStrategiesToRemove;
}

/// @title Execution Strategy Errors
interface IExecutionStrategyErrors {
    /// @notice Thrown when the current status of a proposal does not allow the desired action.
    /// @param status The current status of the proposal.
    error InvalidProposalStatus(ProposalStatus status);

    /// @notice Thrown when the execution of a proposal fails.
    error ExecutionFailed();
}

type ebool is uint256;
type euint8 is uint256;
type euint16 is uint256;
type euint32 is uint256;

library Common {
    // Values used to communicate types to the runtime.
    uint8 internal constant ebool_t = 0;
    uint8 internal constant euint8_t = 0;
    uint8 internal constant euint16_t = 1;
    uint8 internal constant euint32_t = 2;
}

interface FhevmLib {
    function fheAdd(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheSub(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheMul(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheDiv(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheRem(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheBitAnd(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheBitOr(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheBitXor(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheShl(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheShr(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheEq(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheNe(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheGe(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheGt(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheLe(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheLt(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheMin(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheMax(uint256 lhs, uint256 rhs, bytes1 scalarByte) external pure returns (uint256 result);

    function fheNeg(uint256 ct) external pure returns (uint256 result);

    function fheNot(uint256 ct) external pure returns (uint256 result);

    function reencrypt(uint256 ct, uint256 publicKey) external view returns (bytes memory);

    function fhePubKey(bytes1 fromLib) external view returns (bytes memory result);

    function verifyCiphertext(bytes memory input) external pure returns (uint256 result);

    function cast(uint256 ct, bytes1 toType) external pure returns (uint256 result);

    function trivialEncrypt(uint256 ct, bytes1 toType) external pure returns (uint256 result);

    function decrypt(uint256 ct) external view returns (uint256 result);

    function fheIfThenElse(uint256 control, uint256 ifTrue, uint256 ifFalse) external pure returns (uint256 result);

    function fheRand(bytes1 randType) external view returns (uint256 result);

    function fheRandBounded(uint256 upperBound, bytes1 randType) external view returns (uint256 result);
}

address constant EXT_TFHE_LIBRARY = address(0x000000000000000000000000000000000000005d);

library Impl {
    // 32 bytes for the 'byte' type header + 48 bytes for the NaCl anonymous
    // box overhead + 4 bytes for the plaintext value.
    uint256 constant reencryptedSize = 32 + 48 + 4;

    // 32 bytes for the 'byte' header + 16553 bytes of key data.
    uint256 constant fhePubKeySize = 32 + 16553;

    function add(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheAdd(lhs, rhs, scalarByte);
    }

    function sub(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheSub(lhs, rhs, scalarByte);
    }

    function mul(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheMul(lhs, rhs, scalarByte);
    }

    function div(uint256 lhs, uint256 rhs) internal pure returns (uint256 result) {
        bytes1 scalarByte = 0x01;
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheDiv(lhs, rhs, scalarByte);
    }

    function rem(uint256 lhs, uint256 rhs) internal pure returns (uint256 result) {
        bytes1 scalarByte = 0x01;
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheRem(lhs, rhs, scalarByte);
    }

    function and(uint256 lhs, uint256 rhs) internal pure returns (uint256 result) {
        bytes1 scalarByte = 0x00;
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheBitAnd(lhs, rhs, scalarByte);
    }

    function or(uint256 lhs, uint256 rhs) internal pure returns (uint256 result) {
        bytes1 scalarByte = 0x00;
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheBitOr(lhs, rhs, scalarByte);
    }

    function xor(uint256 lhs, uint256 rhs) internal pure returns (uint256 result) {
        bytes1 scalarByte = 0x00;
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheBitXor(lhs, rhs, scalarByte);
    }

    function shl(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheShl(lhs, rhs, scalarByte);
    }

    function shr(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheShr(lhs, rhs, scalarByte);
    }

    function eq(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheEq(lhs, rhs, scalarByte);
    }

    function ne(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheNe(lhs, rhs, scalarByte);
    }

    function ge(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheGe(lhs, rhs, scalarByte);
    }

    function gt(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheGt(lhs, rhs, scalarByte);
    }

    function le(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheLe(lhs, rhs, scalarByte);
    }

    function lt(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheLt(lhs, rhs, scalarByte);
    }

    function min(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheMin(lhs, rhs, scalarByte);
    }

    function max(uint256 lhs, uint256 rhs, bool scalar) internal pure returns (uint256 result) {
        bytes1 scalarByte;
        if (scalar) {
            scalarByte = 0x01;
        } else {
            scalarByte = 0x00;
        }
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheMax(lhs, rhs, scalarByte);
    }

    function neg(uint256 ct) internal pure returns (uint256 result) {
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheNeg(ct);
    }

    function not(uint256 ct) internal pure returns (uint256 result) {
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheNot(ct);
    }

    // If 'control's value is 'true', the result has the same value as 'ifTrue'.
    // If 'control's value is 'false', the result has the same value as 'ifFalse'.
    function cmux(uint256 control, uint256 ifTrue, uint256 ifFalse) internal pure returns (uint256 result) {
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheIfThenElse(control, ifTrue, ifFalse);
    }

    // We do assembly here because ordinary call will emit extcodesize check which is zero for our precompiles
    // and revert the transaction because we don't return any data for this precompile method
    function optReq(uint256 ciphertext) internal view {
        bytes memory input = abi.encodeWithSignature("optimisticRequire(uint256)", ciphertext);
        uint256 inputLen = input.length;

        // Call the optimistic require method in precompile.
        address precompile = EXT_TFHE_LIBRARY;
        assembly {
            if iszero(staticcall(gas(), precompile, add(input, 32), inputLen, 0, 0)) {
                revert(0, 0)
            }
        }
    }

    function reencrypt(uint256 ciphertext, bytes32 publicKey) internal view returns (bytes memory reencrypted) {
        return FhevmLib(address(EXT_TFHE_LIBRARY)).reencrypt(ciphertext, uint256(publicKey));
    }

    function fhePubKey() internal view returns (bytes memory key) {
        // Set a byte value of 1 to signal the call comes from the library.
        key = FhevmLib(address(EXT_TFHE_LIBRARY)).fhePubKey(bytes1(0x01));
    }

    function verify(bytes memory _ciphertextBytes, uint8 _toType) internal pure returns (uint256 result) {
        bytes memory input = bytes.concat(_ciphertextBytes, bytes1(_toType));
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).verifyCiphertext(input);
    }

    function cast(uint256 ciphertext, uint8 toType) internal pure returns (uint256 result) {
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).cast(ciphertext, bytes1(toType));
    }

    function trivialEncrypt(uint256 value, uint8 toType) internal pure returns (uint256 result) {
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).trivialEncrypt(value, bytes1(toType));
    }

    function decrypt(uint256 ciphertext) internal view returns (uint256 result) {
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).decrypt(ciphertext);
    }

    function rand(uint8 randType) internal view returns (uint256 result) {
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheRand(bytes1(randType));
    }

    function randBounded(uint256 upperBound, uint8 randType) internal view returns (uint256 result) {
        result = FhevmLib(address(EXT_TFHE_LIBRARY)).fheRandBounded(upperBound, bytes1(randType));
    }
}

library TFHE {
    euint8 constant NIL8 = euint8.wrap(0);
    euint16 constant NIL16 = euint16.wrap(0);
    euint32 constant NIL32 = euint32.wrap(0);

    // Return true if the enrypted integer is initialized and false otherwise.
    function isInitialized(euint8 v) internal pure returns (bool) {
        return euint8.unwrap(v) != 0;
    }

    // Return true if the enrypted integer is initialized and false otherwise.
    function isInitialized(euint16 v) internal pure returns (bool) {
        return euint16.unwrap(v) != 0;
    }

    // Return true if the enrypted integer is initialized and false otherwise.
    function isInitialized(euint32 v) internal pure returns (bool) {
        return euint32.unwrap(v) != 0;
    }

    // Evaluate add(a, b) and return the result.
    function add(euint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.add(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.sub(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.mul(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate and(a, b) and return the result.
    function and(euint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.and(euint8.unwrap(a), euint8.unwrap(b)));
    }

    // Evaluate or(a, b) and return the result.
    function or(euint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.or(euint8.unwrap(a), euint8.unwrap(b)));
    }

    // Evaluate xor(a, b) and return the result.
    function xor(euint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.xor(euint8.unwrap(a), euint8.unwrap(b)));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.eq(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.ne(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.ge(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.gt(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.le(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.lt(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.min(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.max(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate add(a, b) and return the result.
    function add(euint8 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.add(euint16.unwrap(asEuint16(a)), euint16.unwrap(b), false));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint8 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.sub(euint16.unwrap(asEuint16(a)), euint16.unwrap(b), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint8 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.mul(euint16.unwrap(asEuint16(a)), euint16.unwrap(b), false));
    }

    // Evaluate and(a, b) and return the result.
    function and(euint8 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.and(euint16.unwrap(asEuint16(a)), euint16.unwrap(b)));
    }

    // Evaluate or(a, b) and return the result.
    function or(euint8 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.or(euint16.unwrap(asEuint16(a)), euint16.unwrap(b)));
    }

    // Evaluate xor(a, b) and return the result.
    function xor(euint8 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.xor(euint16.unwrap(asEuint16(a)), euint16.unwrap(b)));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint8 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint16.unwrap(asEuint16(a)), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint8 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint16.unwrap(asEuint16(a)), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint8 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint16.unwrap(asEuint16(a)), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint8 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint16.unwrap(asEuint16(a)), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint8 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint16.unwrap(asEuint16(a)), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint8 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint16.unwrap(asEuint16(a)), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint8 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.min(euint16.unwrap(asEuint16(a)), euint16.unwrap(b), false));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint8 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.max(euint16.unwrap(asEuint16(a)), euint16.unwrap(b), false));
    }

    // Evaluate add(a, b) and return the result.
    function add(euint8 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.add(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint8 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.sub(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint8 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.mul(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false));
    }

    // Evaluate and(a, b) and return the result.
    function and(euint8 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.and(euint32.unwrap(asEuint32(a)), euint32.unwrap(b)));
    }

    // Evaluate or(a, b) and return the result.
    function or(euint8 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.or(euint32.unwrap(asEuint32(a)), euint32.unwrap(b)));
    }

    // Evaluate xor(a, b) and return the result.
    function xor(euint8 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.xor(euint32.unwrap(asEuint32(a)), euint32.unwrap(b)));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint8 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint8 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint8 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint8 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint8 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint8 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint8 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.min(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint8 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.max(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false));
    }

    // Evaluate add(a, b) and return the result.
    function add(euint8 a, uint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return euint8.wrap(Impl.add(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate add(a, b) and return the result.
    function add(uint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.add(euint8.unwrap(b), uint256(a), true));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint8 a, uint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return euint8.wrap(Impl.sub(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(uint8 a, euint8 b) internal pure returns (euint8) {
        euint8 aEnc = asEuint8(a);
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.sub(euint8.unwrap(aEnc), euint8.unwrap(b), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint8 a, uint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return euint8.wrap(Impl.mul(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(uint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.mul(euint8.unwrap(b), uint256(a), true));
    }

    // Evaluate div(a, b) and return the result.
    function div(euint8 a, uint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return euint8.wrap(Impl.div(euint8.unwrap(a), uint256(b)));
    }

    // Evaluate rem(a, b) and return the result.
    function rem(euint8 a, uint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return euint8.wrap(Impl.rem(euint8.unwrap(a), uint256(b)));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint8 a, uint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return ebool.wrap(Impl.eq(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(uint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.eq(euint8.unwrap(b), uint256(a), true));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint8 a, uint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return ebool.wrap(Impl.ne(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(uint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.ne(euint8.unwrap(b), uint256(a), true));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint8 a, uint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return ebool.wrap(Impl.ge(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(uint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.le(euint8.unwrap(b), uint256(a), true));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint8 a, uint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return ebool.wrap(Impl.gt(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(uint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.lt(euint8.unwrap(b), uint256(a), true));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint8 a, uint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return ebool.wrap(Impl.le(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate le(a, b) and return the result.
    function le(uint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.ge(euint8.unwrap(b), uint256(a), true));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint8 a, uint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return ebool.wrap(Impl.lt(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(uint8 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.gt(euint8.unwrap(b), uint256(a), true));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint8 a, uint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return euint8.wrap(Impl.min(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate min(a, b) and return the result.
    function min(uint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.min(euint8.unwrap(b), uint256(a), true));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint8 a, uint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return euint8.wrap(Impl.max(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate max(a, b) and return the result.
    function max(uint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.max(euint8.unwrap(b), uint256(a), true));
    }

    // Evaluate add(a, b) and return the result.
    function add(euint16 a, euint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint16.wrap(Impl.add(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint16 a, euint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint16.wrap(Impl.sub(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint16 a, euint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint16.wrap(Impl.mul(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false));
    }

    // Evaluate and(a, b) and return the result.
    function and(euint16 a, euint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint16.wrap(Impl.and(euint16.unwrap(a), euint16.unwrap(asEuint16(b))));
    }

    // Evaluate or(a, b) and return the result.
    function or(euint16 a, euint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint16.wrap(Impl.or(euint16.unwrap(a), euint16.unwrap(asEuint16(b))));
    }

    // Evaluate xor(a, b) and return the result.
    function xor(euint16 a, euint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint16.wrap(Impl.xor(euint16.unwrap(a), euint16.unwrap(asEuint16(b))));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint16 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint16 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint16 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint16 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint16 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint16 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false), Common.ebool_t));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint16 a, euint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint16.wrap(Impl.min(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint16 a, euint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint16.wrap(Impl.max(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false));
    }

    // Evaluate add(a, b) and return the result.
    function add(euint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.add(euint16.unwrap(a), euint16.unwrap(b), false));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.sub(euint16.unwrap(a), euint16.unwrap(b), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.mul(euint16.unwrap(a), euint16.unwrap(b), false));
    }

    // Evaluate and(a, b) and return the result.
    function and(euint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.and(euint16.unwrap(a), euint16.unwrap(b)));
    }

    // Evaluate or(a, b) and return the result.
    function or(euint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.or(euint16.unwrap(a), euint16.unwrap(b)));
    }

    // Evaluate xor(a, b) and return the result.
    function xor(euint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.xor(euint16.unwrap(a), euint16.unwrap(b)));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint16.unwrap(a), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint16.unwrap(a), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint16.unwrap(a), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint16.unwrap(a), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint16.unwrap(a), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint16.unwrap(a), euint16.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.min(euint16.unwrap(a), euint16.unwrap(b), false));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.max(euint16.unwrap(a), euint16.unwrap(b), false));
    }

    // Evaluate add(a, b) and return the result.
    function add(euint16 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.add(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint16 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.sub(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint16 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.mul(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false));
    }

    // Evaluate and(a, b) and return the result.
    function and(euint16 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.and(euint32.unwrap(asEuint32(a)), euint32.unwrap(b)));
    }

    // Evaluate or(a, b) and return the result.
    function or(euint16 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.or(euint32.unwrap(asEuint32(a)), euint32.unwrap(b)));
    }

    // Evaluate xor(a, b) and return the result.
    function xor(euint16 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.xor(euint32.unwrap(asEuint32(a)), euint32.unwrap(b)));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint16 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint16 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint16 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint16 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint16 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint16 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint16 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.min(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint16 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.max(euint32.unwrap(asEuint32(a)), euint32.unwrap(b), false));
    }

    // Evaluate add(a, b) and return the result.
    function add(euint16 a, uint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return euint16.wrap(Impl.add(euint16.unwrap(a), uint256(b), true));
    }

    // Evaluate add(a, b) and return the result.
    function add(uint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.add(euint16.unwrap(b), uint256(a), true));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint16 a, uint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return euint16.wrap(Impl.sub(euint16.unwrap(a), uint256(b), true));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(uint16 a, euint16 b) internal pure returns (euint16) {
        euint16 aEnc = asEuint16(a);
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.sub(euint16.unwrap(aEnc), euint16.unwrap(b), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint16 a, uint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return euint16.wrap(Impl.mul(euint16.unwrap(a), uint256(b), true));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(uint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.mul(euint16.unwrap(b), uint256(a), true));
    }

    // Evaluate div(a, b) and return the result.
    function div(euint16 a, uint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return euint16.wrap(Impl.div(euint16.unwrap(a), uint256(b)));
    }

    // Evaluate rem(a, b) and return the result.
    function rem(euint16 a, uint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return euint16.wrap(Impl.rem(euint16.unwrap(a), uint256(b)));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint16 a, uint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint16.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(uint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint16.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint16 a, uint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint16.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(uint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint16.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint16 a, uint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint16.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(uint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint16.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint16 a, uint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint16.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(uint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint16.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint16 a, uint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint16.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(uint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint16.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint16 a, uint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint16.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(uint16 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint16.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint16 a, uint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return euint16.wrap(Impl.min(euint16.unwrap(a), uint256(b), true));
    }

    // Evaluate min(a, b) and return the result.
    function min(uint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.min(euint16.unwrap(b), uint256(a), true));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint16 a, uint16 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return euint16.wrap(Impl.max(euint16.unwrap(a), uint256(b), true));
    }

    // Evaluate max(a, b) and return the result.
    function max(uint16 a, euint16 b) internal pure returns (euint16) {
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint16.wrap(Impl.max(euint16.unwrap(b), uint256(a), true));
    }

    // Evaluate add(a, b) and return the result.
    function add(euint32 a, euint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint32.wrap(Impl.add(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint32 a, euint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint32.wrap(Impl.sub(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint32 a, euint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint32.wrap(Impl.mul(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate and(a, b) and return the result.
    function and(euint32 a, euint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint32.wrap(Impl.and(euint32.unwrap(a), euint32.unwrap(asEuint32(b))));
    }

    // Evaluate or(a, b) and return the result.
    function or(euint32 a, euint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint32.wrap(Impl.or(euint32.unwrap(a), euint32.unwrap(asEuint32(b))));
    }

    // Evaluate xor(a, b) and return the result.
    function xor(euint32 a, euint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint32.wrap(Impl.xor(euint32.unwrap(a), euint32.unwrap(asEuint32(b))));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint32 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint32 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint32 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint32 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint32 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint32 a, euint8 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint32 a, euint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint32.wrap(Impl.min(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint32 a, euint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint32.wrap(Impl.max(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate add(a, b) and return the result.
    function add(euint32 a, euint16 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint32.wrap(Impl.add(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint32 a, euint16 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint32.wrap(Impl.sub(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint32 a, euint16 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint32.wrap(Impl.mul(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate and(a, b) and return the result.
    function and(euint32 a, euint16 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint32.wrap(Impl.and(euint32.unwrap(a), euint32.unwrap(asEuint32(b))));
    }

    // Evaluate or(a, b) and return the result.
    function or(euint32 a, euint16 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint32.wrap(Impl.or(euint32.unwrap(a), euint32.unwrap(asEuint32(b))));
    }

    // Evaluate xor(a, b) and return the result.
    function xor(euint32 a, euint16 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint32.wrap(Impl.xor(euint32.unwrap(a), euint32.unwrap(asEuint32(b))));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint32 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint32 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint32 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint32 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint32 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint32 a, euint16 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false), Common.ebool_t));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint32 a, euint16 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint32.wrap(Impl.min(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint32 a, euint16 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint16(0);
        }
        return euint32.wrap(Impl.max(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate add(a, b) and return the result.
    function add(euint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.add(euint32.unwrap(a), euint32.unwrap(b), false));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.sub(euint32.unwrap(a), euint32.unwrap(b), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.mul(euint32.unwrap(a), euint32.unwrap(b), false));
    }

    // Evaluate and(a, b) and return the result.
    function and(euint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.and(euint32.unwrap(a), euint32.unwrap(b)));
    }

    // Evaluate or(a, b) and return the result.
    function or(euint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.or(euint32.unwrap(a), euint32.unwrap(b)));
    }

    // Evaluate xor(a, b) and return the result.
    function xor(euint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.xor(euint32.unwrap(a), euint32.unwrap(b)));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint32.unwrap(a), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint32.unwrap(a), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint32.unwrap(a), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint32.unwrap(a), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint32.unwrap(a), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint32.unwrap(a), euint32.unwrap(b), false), Common.ebool_t));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.min(euint32.unwrap(a), euint32.unwrap(b), false));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.max(euint32.unwrap(a), euint32.unwrap(b), false));
    }

    // Evaluate add(a, b) and return the result.
    function add(euint32 a, uint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return euint32.wrap(Impl.add(euint32.unwrap(a), uint256(b), true));
    }

    // Evaluate add(a, b) and return the result.
    function add(uint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.add(euint32.unwrap(b), uint256(a), true));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(euint32 a, uint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return euint32.wrap(Impl.sub(euint32.unwrap(a), uint256(b), true));
    }

    // Evaluate sub(a, b) and return the result.
    function sub(uint32 a, euint32 b) internal pure returns (euint32) {
        euint32 aEnc = asEuint32(a);
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.sub(euint32.unwrap(aEnc), euint32.unwrap(b), false));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(euint32 a, uint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return euint32.wrap(Impl.mul(euint32.unwrap(a), uint256(b), true));
    }

    // Evaluate mul(a, b) and return the result.
    function mul(uint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.mul(euint32.unwrap(b), uint256(a), true));
    }

    // Evaluate div(a, b) and return the result.
    function div(euint32 a, uint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return euint32.wrap(Impl.div(euint32.unwrap(a), uint256(b)));
    }

    // Evaluate rem(a, b) and return the result.
    function rem(euint32 a, uint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return euint32.wrap(Impl.rem(euint32.unwrap(a), uint256(b)));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(euint32 a, uint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint32.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate eq(a, b) and return the result.
    function eq(uint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.eq(euint32.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(euint32 a, uint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint32.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate ne(a, b) and return the result.
    function ne(uint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.ne(euint32.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(euint32 a, uint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint32.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate ge(a, b) and return the result.
    function ge(uint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint32.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(euint32 a, uint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint32.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate gt(a, b) and return the result.
    function gt(uint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint32.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(euint32 a, uint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.le(euint32.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate le(a, b) and return the result.
    function le(uint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.ge(euint32.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(euint32 a, uint32 b) internal pure returns (ebool) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.lt(euint32.unwrap(a), uint256(b), true), Common.ebool_t));
    }

    // Evaluate lt(a, b) and return the result.
    function lt(uint32 a, euint32 b) internal pure returns (ebool) {
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return ebool.wrap(Impl.cast(Impl.gt(euint32.unwrap(b), uint256(a), true), Common.ebool_t));
    }

    // Evaluate min(a, b) and return the result.
    function min(euint32 a, uint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return euint32.wrap(Impl.min(euint32.unwrap(a), uint256(b), true));
    }

    // Evaluate min(a, b) and return the result.
    function min(uint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.min(euint32.unwrap(b), uint256(a), true));
    }

    // Evaluate max(a, b) and return the result.
    function max(euint32 a, uint32 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return euint32.wrap(Impl.max(euint32.unwrap(a), uint256(b), true));
    }

    // Evaluate max(a, b) and return the result.
    function max(uint32 a, euint32 b) internal pure returns (euint32) {
        if (!isInitialized(b)) {
            b = asEuint32(0);
        }
        return euint32.wrap(Impl.max(euint32.unwrap(b), uint256(a), true));
    }

    // Evaluate shl(a, b) and return the result.
    function shl(euint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.shl(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate shl(a, b) and return the result.
    function shl(euint8 a, uint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return euint8.wrap(Impl.shl(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate shr(a, b) and return the result.
    function shr(euint8 a, euint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint8.wrap(Impl.shr(euint8.unwrap(a), euint8.unwrap(b), false));
    }

    // Evaluate shr(a, b) and return the result.
    function shr(euint8 a, uint8 b) internal pure returns (euint8) {
        if (!isInitialized(a)) {
            a = asEuint8(0);
        }
        return euint8.wrap(Impl.shr(euint8.unwrap(a), uint256(b), true));
    }

    // Evaluate shl(a, b) and return the result.
    function shl(euint16 a, euint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint16.wrap(Impl.shl(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false));
    }

    // Evaluate shl(a, b) and return the result.
    function shl(euint16 a, uint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return euint16.wrap(Impl.shl(euint16.unwrap(a), uint256(b), true));
    }

    // Evaluate shr(a, b) and return the result.
    function shr(euint16 a, euint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint16.wrap(Impl.shr(euint16.unwrap(a), euint16.unwrap(asEuint16(b)), false));
    }

    // Evaluate shr(a, b) and return the result.
    function shr(euint16 a, uint8 b) internal pure returns (euint16) {
        if (!isInitialized(a)) {
            a = asEuint16(0);
        }
        return euint16.wrap(Impl.shr(euint16.unwrap(a), uint256(b), true));
    }

    // Evaluate shl(a, b) and return the result.
    function shl(euint32 a, euint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint32.wrap(Impl.shl(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate shl(a, b) and return the result.
    function shl(euint32 a, uint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return euint32.wrap(Impl.shl(euint32.unwrap(a), uint256(b), true));
    }

    // Evaluate shr(a, b) and return the result.
    function shr(euint32 a, euint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        if (!isInitialized(b)) {
            b = asEuint8(0);
        }
        return euint32.wrap(Impl.shr(euint32.unwrap(a), euint32.unwrap(asEuint32(b)), false));
    }

    // Evaluate shr(a, b) and return the result.
    function shr(euint32 a, uint8 b) internal pure returns (euint32) {
        if (!isInitialized(a)) {
            a = asEuint32(0);
        }
        return euint32.wrap(Impl.shr(euint32.unwrap(a), uint256(b), true));
    }

    // If 'control''s value is 'true', the result has the same value as 'a'.
    // If 'control''s value is 'false', the result has the same value as 'b'.
    function cmux(ebool control, euint8 a, euint8 b) internal pure returns (euint8) {
        return euint8.wrap(Impl.cmux(ebool.unwrap(control), euint8.unwrap(a), euint8.unwrap(b)));
    }

    // If 'control''s value is 'true', the result has the same value as 'a'.
    // If 'control''s value is 'false', the result has the same value as 'b'.
    function cmux(ebool control, euint16 a, euint16 b) internal pure returns (euint16) {
        return euint16.wrap(Impl.cmux(ebool.unwrap(control), euint16.unwrap(a), euint16.unwrap(b)));
    }

    // If 'control''s value is 'true', the result has the same value as 'a'.
    // If 'control''s value is 'false', the result has the same value as 'b'.
    function cmux(ebool control, euint32 a, euint32 b) internal pure returns (euint32) {
        return euint32.wrap(Impl.cmux(ebool.unwrap(control), euint32.unwrap(a), euint32.unwrap(b)));
    }

    // Cast an encrypted integer from euint16 to euint8.
    function asEuint8(euint16 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(euint16.unwrap(value), Common.euint8_t));
    }

    // Cast an encrypted integer from euint32 to euint8.
    function asEuint8(euint32 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(euint32.unwrap(value), Common.euint8_t));
    }

    // Cast an encrypted integer from euint8 to ebool.
    function asEbool(euint8 value) internal pure returns (ebool) {
        return ne(value, 0);
    }

    // Convert a serialized 'ciphertext' to an encrypted boolean.
    function asEbool(bytes memory ciphertext) internal pure returns (ebool) {
        return asEbool(asEuint8(ciphertext));
    }

    // Convert a plaintext boolean to an encrypted boolean.
    function asEbool(bool value) internal pure returns (ebool) {
        if (value) {
            return asEbool(asEuint8(1));
        } else {
            return asEbool(asEuint8(0));
        }
    }

    // Converts an 'ebool' to an 'euint8'.
    function asEuint8(ebool b) internal pure returns (euint8) {
        return euint8.wrap(ebool.unwrap(b));
    }

    // Evaluate and(a, b) and return the result.
    function and(ebool a, ebool b) internal pure returns (ebool) {
        return asEbool(and(asEuint8(a), asEuint8(b)));
    }

    // Evaluate or(a, b) and return the result.
    function or(ebool a, ebool b) internal pure returns (ebool) {
        return asEbool(or(asEuint8(a), asEuint8(b)));
    }

    // Evaluate xor(a, b) and return the result.
    function xor(ebool a, ebool b) internal pure returns (ebool) {
        return asEbool(xor(asEuint8(a), asEuint8(b)));
    }

    function not(ebool a) internal pure returns (ebool) {
        return asEbool(and(not(asEuint8(a)), asEuint8(1)));
    }

    // If 'control''s value is 'true', the result has the same value as 'a'.
    // If 'control''s value is 'false', the result has the same value as 'b'.
    function cmux(ebool cond, ebool a, ebool b) internal pure returns (ebool) {
        return asEbool(cmux(cond, asEuint8(a), asEuint8(b)));
    }

    // Cast an encrypted integer from euint8 to euint16.
    function asEuint16(euint8 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(euint8.unwrap(value), Common.euint16_t));
    }

    // Cast an encrypted integer from euint32 to euint16.
    function asEuint16(euint32 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(euint32.unwrap(value), Common.euint16_t));
    }

    // Cast an encrypted integer from euint16 to ebool.
    function asEbool(euint16 value) internal pure returns (ebool) {
        return ne(value, 0);
    }

    // Converts an 'ebool' to an 'euint16'.
    function asEuint16(ebool b) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(ebool.unwrap(b), Common.euint16_t));
    }

    // Cast an encrypted integer from euint8 to euint32.
    function asEuint32(euint8 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(euint8.unwrap(value), Common.euint32_t));
    }

    // Cast an encrypted integer from euint16 to euint32.
    function asEuint32(euint16 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(euint16.unwrap(value), Common.euint32_t));
    }

    // Cast an encrypted integer from euint32 to ebool.
    function asEbool(euint32 value) internal pure returns (ebool) {
        return ne(value, 0);
    }

    // Converts an 'ebool' to an 'euint32'.
    function asEuint32(ebool b) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(ebool.unwrap(b), Common.euint32_t));
    }

    function neg(euint8 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.neg(euint8.unwrap(value)));
    }

    function not(euint8 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.not(euint8.unwrap(value)));
    }

    function neg(euint16 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.neg(euint16.unwrap(value)));
    }

    function not(euint16 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.not(euint16.unwrap(value)));
    }

    function neg(euint32 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.neg(euint32.unwrap(value)));
    }

    function not(euint32 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.not(euint32.unwrap(value)));
    }

    // Convert a serialized 'ciphertext' to an encrypted euint8 integer.
    function asEuint8(bytes memory ciphertext) internal pure returns (euint8) {
        return euint8.wrap(Impl.verify(ciphertext, Common.euint8_t));
    }

    // Convert a plaintext value to an encrypted euint8 integer.
    function asEuint8(uint256 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.trivialEncrypt(value, Common.euint8_t));
    }

    // Reencrypt the given 'value' under the given 'publicKey'.
    // Return a serialized euint8 ciphertext.
    function reencrypt(euint8 value, bytes32 publicKey) internal view returns (bytes memory reencrypted) {
        return Impl.reencrypt(euint8.unwrap(value), publicKey);
    }

    // Reencrypt the given 'value' under the given 'publicKey'.
    // If 'value' is not initialized, the returned value will contain the 'defaultValue' constant.
    // Return a serialized euint8 ciphertext.
    function reencrypt(
        euint8 value,
        bytes32 publicKey,
        uint8 defaultValue
    ) internal view returns (bytes memory reencrypted) {
        if (euint8.unwrap(value) != 0) {
            return Impl.reencrypt(euint8.unwrap(value), publicKey);
        } else {
            return Impl.reencrypt(euint8.unwrap(asEuint8(defaultValue)), publicKey);
        }
    }

    // Decrypts the encrypted 'value'.
    function decrypt(euint8 value) internal view returns (uint8) {
        return uint8(Impl.decrypt(euint8.unwrap(value)));
    }

    // Convert a serialized 'ciphertext' to an encrypted euint16 integer.
    function asEuint16(bytes memory ciphertext) internal pure returns (euint16) {
        return euint16.wrap(Impl.verify(ciphertext, Common.euint16_t));
    }

    // Convert a plaintext value to an encrypted euint16 integer.
    function asEuint16(uint256 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.trivialEncrypt(value, Common.euint16_t));
    }

    // Reencrypt the given 'value' under the given 'publicKey'.
    // Return a serialized euint16 ciphertext.
    function reencrypt(euint16 value, bytes32 publicKey) internal view returns (bytes memory reencrypted) {
        return Impl.reencrypt(euint16.unwrap(value), publicKey);
    }

    // Reencrypt the given 'value' under the given 'publicKey'.
    // If 'value' is not initialized, the returned value will contain the 'defaultValue' constant.
    // Return a serialized euint16 ciphertext.
    function reencrypt(
        euint16 value,
        bytes32 publicKey,
        uint16 defaultValue
    ) internal view returns (bytes memory reencrypted) {
        if (euint16.unwrap(value) != 0) {
            return Impl.reencrypt(euint16.unwrap(value), publicKey);
        } else {
            return Impl.reencrypt(euint16.unwrap(asEuint16(defaultValue)), publicKey);
        }
    }

    // Decrypts the encrypted 'value'.
    function decrypt(euint16 value) internal view returns (uint16) {
        return uint16(Impl.decrypt(euint16.unwrap(value)));
    }

    // Convert a serialized 'ciphertext' to an encrypted euint32 integer.
    function asEuint32(bytes memory ciphertext) internal pure returns (euint32) {
        return euint32.wrap(Impl.verify(ciphertext, Common.euint32_t));
    }

    // Convert a plaintext value to an encrypted euint32 integer.
    function asEuint32(uint256 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.trivialEncrypt(value, Common.euint32_t));
    }

    // Reencrypt the given 'value' under the given 'publicKey'.
    // Return a serialized euint32 ciphertext.
    function reencrypt(euint32 value, bytes32 publicKey) internal view returns (bytes memory reencrypted) {
        return Impl.reencrypt(euint32.unwrap(value), publicKey);
    }

    // Reencrypt the given 'value' under the given 'publicKey'.
    // If 'value' is not initialized, the returned value will contain the 'defaultValue' constant.
    // Return a serialized euint32 ciphertext.
    function reencrypt(
        euint32 value,
        bytes32 publicKey,
        uint32 defaultValue
    ) internal view returns (bytes memory reencrypted) {
        if (euint32.unwrap(value) != 0) {
            return Impl.reencrypt(euint32.unwrap(value), publicKey);
        } else {
            return Impl.reencrypt(euint32.unwrap(asEuint32(defaultValue)), publicKey);
        }
    }

    // Decrypts the encrypted 'value'.
    function decrypt(euint32 value) internal view returns (uint32) {
        return uint32(Impl.decrypt(euint32.unwrap(value)));
    }

    // Optimistically require that 'b' is true.
    //
    // This function does not evaluate 'b' at the time of the call.
    // Instead, it accumulates all optimistic requires and evaluates a single combined
    // require at the end of the transaction. A side effect of this mechanism
    // is that a method call with a failed optimistic require will always incur the full
    // gas cost, as if all optimistic requires were true. Yet, the transaction will be
    // reverted at the end if any of the optimisic requires were false.
    //
    // Exceptions to above rule are reencryptions and decryptions via
    // TFHE.reencrypt() and TFHE.decrypt(), respectively. If either of them
    // are encountered and if optimistic requires have been used before in the
    // txn, the optimisic requires will be immediately evaluated. Rationale is
    // that we want to avoid decrypting or reencrypting a value if the txn is about
    // to fail and be reverted anyway at the end. Checking immediately and reverting on the spot
    // would avoid unnecessary decryptions.
    //
    // The benefit of optimistic requires is that they are faster than non-optimistic ones,
    // because there is a single call to the decryption oracle per transaction, irrespective
    // of how many optimistic requires were used.
    function optReq(ebool b) internal view {
        Impl.optReq(ebool.unwrap(b));
    }

    // Decrypts the encrypted 'value'.
    function decrypt(ebool value) internal view returns (bool) {
        return (Impl.decrypt(ebool.unwrap(value)) != 0);
    }

    // Reencrypt the given 'value' under the given 'publicKey'.
    // Return a serialized euint8 value.
    function reencrypt(ebool value, bytes32 publicKey) internal view returns (bytes memory reencrypted) {
        return Impl.reencrypt(ebool.unwrap(value), publicKey);
    }

    // Reencrypt the given 'value' under the given 'publicKey'.
    // Return a serialized euint8 value.
    // If 'value' is not initialized, the returned value will contain the 'defaultValue' constant.
    function reencrypt(
        ebool value,
        bytes32 publicKey,
        bool defaultValue
    ) internal view returns (bytes memory reencrypted) {
        if (ebool.unwrap(value) != 0) {
            return Impl.reencrypt(ebool.unwrap(value), publicKey);
        } else {
            return Impl.reencrypt(ebool.unwrap(asEbool(defaultValue)), publicKey);
        }
    }

    // Returns the network public FHE key.
    function fhePubKey() internal view returns (bytes memory) {
        return Impl.fhePubKey();
    }

    // Generates a random encrypted 8-bit unsigned integer.
    // Important: The random integer is generated in the plain! An FHE-based version is coming soon.
    function randEuint8() internal view returns (euint8) {
        return euint8.wrap(Impl.rand(Common.euint8_t));
    }

    // Generates a random encrypted 8-bit unsigned integer in the [0, upperBound) range.
    // The upperBound must be a power of 2.
    // Important: The random integer is generated in the plain! An FHE-based version is coming soon.
    function randEuint8(uint8 upperBound) internal view returns (euint8) {
        return euint8.wrap(Impl.randBounded(upperBound, Common.euint8_t));
    }

    // Generates a random encrypted 16-bit unsigned integer.
    // Important: The random integer is generated in the plain! An FHE-based version is coming soon.
    function randEuint16() internal view returns (euint16) {
        return euint16.wrap(Impl.rand(Common.euint16_t));
    }

    // Generates a random encrypted 16-bit unsigned integer in the [0, upperBound) range.
    // The upperBound must be a power of 2.
    // Important: The random integer is generated in the plain! An FHE-based version is coming soon.
    function randEuint16(uint16 upperBound) internal view returns (euint16) {
        return euint16.wrap(Impl.randBounded(upperBound, Common.euint16_t));
    }

    // Generates a random encrypted 32-bit unsigned integer.
    // Important: The random integer is generated in the plain! An FHE-based version is coming soon.
    function randEuint32() internal view returns (euint32) {
        return euint32.wrap(Impl.rand(Common.euint32_t));
    }

    // Generates a random encrypted 32-bit unsigned integer in the [0, upperBound) range.
    // The upperBound must be a power of 2.
    // Important: The random integer is generated in the plain! An FHE-based version is coming soon.
    function randEuint32(uint32 upperBound) internal view returns (euint32) {
        return euint32.wrap(Impl.randBounded(upperBound, Common.euint32_t));
    }
}

using {tfheBinaryOperatorAdd8 as +} for euint8 global;

function tfheBinaryOperatorAdd8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return TFHE.add(lhs, rhs);
}

using {tfheBinaryOperatorSub8 as -} for euint8 global;

function tfheBinaryOperatorSub8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return TFHE.sub(lhs, rhs);
}

using {tfheBinaryOperatorMul8 as *} for euint8 global;

function tfheBinaryOperatorMul8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return TFHE.mul(lhs, rhs);
}

using {tfheBinaryOperatorAnd8 as &} for euint8 global;

function tfheBinaryOperatorAnd8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return TFHE.and(lhs, rhs);
}

using {tfheBinaryOperatorOr8 as |} for euint8 global;

function tfheBinaryOperatorOr8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return TFHE.or(lhs, rhs);
}

using {tfheBinaryOperatorXor8 as ^} for euint8 global;

function tfheBinaryOperatorXor8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return TFHE.xor(lhs, rhs);
}

using {tfheUnaryOperatorNeg8 as -} for euint8 global;

function tfheUnaryOperatorNeg8(euint8 input) pure returns (euint8) {
    return TFHE.neg(input);
}

using {tfheUnaryOperatorNot8 as ~} for euint8 global;

function tfheUnaryOperatorNot8(euint8 input) pure returns (euint8) {
    return TFHE.not(input);
}

using {tfheBinaryOperatorAdd16 as +} for euint16 global;

function tfheBinaryOperatorAdd16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return TFHE.add(lhs, rhs);
}

using {tfheBinaryOperatorSub16 as -} for euint16 global;

function tfheBinaryOperatorSub16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return TFHE.sub(lhs, rhs);
}

using {tfheBinaryOperatorMul16 as *} for euint16 global;

function tfheBinaryOperatorMul16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return TFHE.mul(lhs, rhs);
}

using {tfheBinaryOperatorAnd16 as &} for euint16 global;

function tfheBinaryOperatorAnd16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return TFHE.and(lhs, rhs);
}

using {tfheBinaryOperatorOr16 as |} for euint16 global;

function tfheBinaryOperatorOr16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return TFHE.or(lhs, rhs);
}

using {tfheBinaryOperatorXor16 as ^} for euint16 global;

function tfheBinaryOperatorXor16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return TFHE.xor(lhs, rhs);
}

using {tfheUnaryOperatorNeg16 as -} for euint16 global;

function tfheUnaryOperatorNeg16(euint16 input) pure returns (euint16) {
    return TFHE.neg(input);
}

using {tfheUnaryOperatorNot16 as ~} for euint16 global;

function tfheUnaryOperatorNot16(euint16 input) pure returns (euint16) {
    return TFHE.not(input);
}

using {tfheBinaryOperatorAdd32 as +} for euint32 global;

function tfheBinaryOperatorAdd32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return TFHE.add(lhs, rhs);
}

using {tfheBinaryOperatorSub32 as -} for euint32 global;

function tfheBinaryOperatorSub32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return TFHE.sub(lhs, rhs);
}

using {tfheBinaryOperatorMul32 as *} for euint32 global;

function tfheBinaryOperatorMul32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return TFHE.mul(lhs, rhs);
}

using {tfheBinaryOperatorAnd32 as &} for euint32 global;

function tfheBinaryOperatorAnd32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return TFHE.and(lhs, rhs);
}

using {tfheBinaryOperatorOr32 as |} for euint32 global;

function tfheBinaryOperatorOr32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return TFHE.or(lhs, rhs);
}

using {tfheBinaryOperatorXor32 as ^} for euint32 global;

function tfheBinaryOperatorXor32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return TFHE.xor(lhs, rhs);
}

using {tfheUnaryOperatorNeg32 as -} for euint32 global;

function tfheUnaryOperatorNeg32(euint32 input) pure returns (euint32) {
    return TFHE.neg(input);
}

using {tfheUnaryOperatorNot32 as ~} for euint32 global;

function tfheUnaryOperatorNot32(euint32 input) pure returns (euint32) {
    return TFHE.not(input);
}

/// @title Execution Strategy Interface
interface IExecutionStrategy is IExecutionStrategyErrors {
    function execute(           //@votePower
        uint256 proposalId,
        Proposal memory proposal,
        euint32 votesFor,
        euint32 votesAgainst,
        euint32 votesAbstain,
        bytes memory payload
    ) external;

    function getProposalStatus(             //@votePower
        Proposal memory proposal,
        euint32 votesFor,
        euint32 votesAgainst,
        euint32 votesAbstain
    ) external view returns (ProposalStatus);

    function getStrategyType() external view returns (string memory);
}

// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

// OpenZeppelin Contracts (last updated v4.9.4) (utils/Context.sol)

// OpenZeppelin Contracts (last updated v4.9.0) (proxy/utils/Initializable.sol)

// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     *
     * Furthermore, `isContract` will also return true if the target contract within
     * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
     * which only has an effect at the end of a transaction.
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```solidity
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 *
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     * @custom:oz-retyped-from bool
     */
    uint8 private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint8 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
     * constructor.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        bool isTopLevelCall = !_initializing;
        require(
            (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
            "Initializable: contract is already initialized"
        );
        _initialized = 1;
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: setting the version to 255 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint8 version) {
        require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
        _initialized = version;
        _initializing = true;
        _;
        _initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        require(!_initializing, "Initializable: contract is initializing");
        if (_initialized != type(uint8).max) {
            _initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint8) {
        return _initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _initializing;
    }
}

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {
    }

    function __Context_init_unchained() internal onlyInitializing {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function __Ownable_init() internal onlyInitializing {
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal onlyInitializing {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}

/// @title Space Manager
/// @notice Manages a whitelist of Spaces that are authorized to execute transactions via this contract.
contract SpaceManager is OwnableUpgradeable {
    /// @notice Thrown if a space is not in the whitelist.
    error InvalidSpace();

    mapping(address space => uint256 isEnabled) internal spaces;

    /// @notice Emitted when a space is enabled.
    event SpaceEnabled(address space);

    /// @notice Emitted when a space is disabled.
    event SpaceDisabled(address space);

    /// @notice Initialize the contract with a list of spaces. Called only once.
    /// @param _spaces List of spaces.
    // solhint-disable-next-line func-name-mixedcase
    function __SpaceManager_init(address[] memory _spaces) internal onlyInitializing {
        for (uint256 i = 0; i < _spaces.length; i++) {
            spaces[_spaces[i]] = TRUE;
        }
    }

    /// @notice Enable a space.
    /// @param space Address of the space.
    function enableSpace(address space) external onlyOwner {
        if (space == address(0) || (spaces[space] != FALSE)) revert InvalidSpace();
        spaces[space] = TRUE;
        emit SpaceEnabled(space);
    }

    /// @notice Disable a space.
    /// @param space Address of the space.
    function disableSpace(address space) external onlyOwner {
        if (spaces[space] == FALSE) revert InvalidSpace();
        spaces[space] = FALSE;
        emit SpaceDisabled(space);
    }

    /// @notice Check if a space is enabled.
    /// @param space Address of the space.
    /// @return uint256 whether the space is enabled.
    function isSpaceEnabled(address space) external view returns (uint256) {
        return spaces[space];
    }

    modifier onlySpace() {
        if (spaces[msg.sender] == FALSE) revert InvalidSpace();
        _;
    }
}

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

/// @title Avatar Execution Strategy
/// @notice Used to execute proposal transactions from an Avatar contract.
/// @dev An Avatar contract is any contract that implements the IAvatar interface, eg a Gnosis Safe.
contract AvatarExecutionStrategy is SimpleQuorumExecutionStrategy {
    /// @notice Emitted when a new Avatar Execution Strategy is initialized.
    /// @param _owner Address of the owner of the strategy.
    /// @param _target Address of the avatar that this module will pass transactions to.
    /// @param _spaces Array of whitelisted space contracts.
    event AvatarExecutionStrategySetUp(address _owner, address _target, address[] _spaces, uint256 _quorum);

    /// @notice Emitted each time the Target is set.
    /// @param newTarget The new target address.
    event TargetSet(address indexed newTarget);

    /// @notice Address of the avatar that this module will pass transactions to.
    address public target;

    /// @notice Constructor
    /// @param _owner Address of the owner of this contract.
    /// @param _target Address of the avatar that this module will pass transactions to.
    /// @param _spaces Array of whitelisted space contracts.
    /// @param _quorum The quorum required to execute a proposal.
    constructor(address _owner, address _target, address[] memory _spaces, uint256 _quorum) {
        bytes memory initParams = abi.encode(_owner, _target, _spaces, _quorum);
        setUp(initParams);
    }

    /// @notice Initialization function, should be called immediately after deploying a new proxy to this contract.
    /// @param initParams ABI encoded parameters, in the same order as the constructor.
    function setUp(bytes memory initParams) public initializer {
        (address _owner, address _target, address[] memory _spaces, uint256 _quorum) = abi.decode(
            initParams,
            (address, address, address[], uint256)
        );
        __Ownable_init();
        transferOwnership(_owner);
        __SpaceManager_init(_spaces);
        __SimpleQuorumExecutionStrategy_init(_quorum);
        target = _target;
        emit AvatarExecutionStrategySetUp(_owner, _target, _spaces, _quorum);
    }

    /// @notice Sets the target address.
    /// @param _target The new target address.
    function setTarget(address _target) external onlyOwner {
        target = _target;
        emit TargetSet(_target);
    }

    /// @notice Executes a proposal from the avatar contract if the proposal outcome is accepted.
    ///         Must be called by a whitelisted space contract.
    /// @param proposal The proposal to execute.
    /// @param votesFor The number of votes in favor of the proposal.
    /// @param votesAgainst The number of votes against the proposal.
    /// @param votesAbstain The number of abstaining votes.
    /// @param payload The encoded transactions to execute.
    function execute(   //@votePower
        uint256 /* proposalId */,
        Proposal memory proposal,
        euint32 votesFor,
        euint32 votesAgainst,
        euint32 votesAbstain,
        bytes memory payload
    ) external override onlySpace {
        ProposalStatus proposalStatus = getProposalStatus(proposal, votesFor, votesAgainst, votesAbstain);
        if ((proposalStatus != ProposalStatus.Accepted) && (proposalStatus != ProposalStatus.VotingPeriodAccepted)) {
            revert InvalidProposalStatus(proposalStatus);
        }
        _execute(payload);
    }

    /// @notice Decodes and executes a batch of transactions from the avatar contract.
    /// @param payload The encoded transactions to execute.
    function _execute(bytes memory payload) internal {
        MetaTransaction[] memory transactions = abi.decode(payload, (MetaTransaction[]));
        for (uint256 i = 0; i < transactions.length; i++) {
            bool success = IAvatar(target).execTransactionFromModule(
                transactions[i].to,
                transactions[i].value,
                transactions[i].data,
                transactions[i].operation
            );
            // If any transaction fails, the entire execution will revert.
            if (!success) revert ExecutionFailed();
        }
    }

    /// @notice Returns the trategy type string.
    function getStrategyType() external pure override returns (string memory) {
        return "SimpleQuorumAvatar";
    }
}
