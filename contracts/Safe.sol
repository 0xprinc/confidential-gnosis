// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.7.0 <0.9.0;

import {ITransactionGuard, GuardManager} from "./base/GuardManager.sol";
import {ModuleManager} from "./base/ModuleManager.sol";
import {OwnerManager} from "./base/OwnerManager.sol";
import {FallbackManager} from "./base/FallbackManager.sol";
import {NativeCurrencyPaymentFallback} from "./common/NativeCurrencyPaymentFallback.sol";
import {Singleton} from "./common/Singleton.sol";
import {SignatureDecoder} from "./common/SignatureDecoder.sol";
import {SecuredTokenTransfer} from "./common/SecuredTokenTransfer.sol";
import {StorageAccessible} from "./common/StorageAccessible.sol";
import {Enum} from "./libraries/Enum.sol";
import {ISignatureValidator, ISignatureValidatorConstants} from "./interfaces/ISignatureValidator.sol";
import {SafeMath} from "./external/SafeMath.sol";
import {ISafe} from "./interfaces/ISafe.sol";

/**
 * @title Safe - A multisignature wallet with support for confirmations using signed messages based on EIP-712.
 * @dev Most important concepts:
 *      - Threshold: Number of required confirmations for a Safe transaction.
 *      - Owners: List of addresses that control the Safe. They are the only ones that can add/remove owners, change the threshold and
 *        approve transactions. Managed in `OwnerManager`.
 *      - Transaction Hash: Hash of a transaction is calculated using the EIP-712 typed structured data hashing scheme.
 *      - Nonce: Each transaction should have a different nonce to prevent replay attacks.
 *      - Signature: A valid signature of an owner of the Safe for a transaction hash.
 *      - Guards: Guards are contracts that can execute pre- and post- transaction checks. There are two types of guards:
 *          1. Transaction Guard: managed in `GuardManager` for transactions executed with `execTransaction`.
 *          2. Module Guard: managed in `ModuleManager` for transactions executed with `execTransactionFromModule`
 *      - Modules: Modules are contracts that can be used to extend the write functionality of a Safe. Managed in `ModuleManager`.
 *      - Fallback: Fallback handler is a contract that can provide additional read-only functional for Safe. Managed in `FallbackManager`.
 *      Note: This version of the implementation contract doesn't emit events for the sake of gas efficiency and therefore requires a tracing node for indexing/
 *      For the events-based implementation see `SafeL2.sol`.
 * @author Stefan George - @Georgi87
 * @author Richard Meissner - @rmeissner
 */
contract Safe is
    Singleton,
    NativeCurrencyPaymentFallback,
    ModuleManager,
    GuardManager,
    OwnerManager,
    SignatureDecoder,
    SecuredTokenTransfer,
    ISignatureValidatorConstants,
    FallbackManager,
    StorageAccessible,
    ISafe
{
    using SafeMath for uint256;

    string public constant override VERSION = "1.4.1";

    // keccak256(
    //     "EIP712Domain(uint256 chainId,address verifyingContract)"
    // );
    bytes32 private constant DOMAIN_SEPARATOR_TYPEHASH = 0x47e79534a245952e8b16893a336b85a3d9ea9fa8c573f3d803afb92a79469218;

    // keccak256(
    //     "SafeTx(address to,uint256 value,bytes data,uint8 operation,uint256 safeTxGas,uint256 baseGas,uint256 gasPrice,address gasToken,address refundReceiver,uint256 nonce)"
    // );
    bytes32 private constant SAFE_TX_TYPEHASH = 0xbb8310d486368db6bd6f849402fdd73ad53d316b5a4b2644ad6efe0f941286d8;

    uint256 public override nonce;
    bytes32 private _deprecatedDomainSeparator;
    // Mapping to keep track of all message hashes that have been approved by ALL REQUIRED owners
    mapping(bytes32 => uint256) public override signedMessages;
    // Mapping to keep track of all hashes (message or transaction) that have been approved by ANY owners
    mapping(address => mapping(bytes32 => uint256)) public override approvedHashes;

    // This constructor ensures that this contract can only be used as a singleton for Proxy contracts
    constructor(address[] memory owners, uint threshold) {
        /**
         * By setting the threshold it is not possible to call setup anymore,
         * so we create a Safe with 0 owners and threshold 1.
         * This is an unusable Safe, perfect for the singleton
         */
        setup(owners, threshold, address(0), abi.encode(0xdead), address(0), address(0), 0, payable(address(0)));
        threshold = 1;
    }

    function getAddress() public view returns (address) {
        return address(this);
    }

    /**
     * @inheritdoc ISafe
     */
    function setup(
        address[] memory _owners,
        uint256 _threshold,
        address to,
        bytes memory data,
        address fallbackHandler,
        address paymentToken,
        uint256 payment,
        address payable paymentReceiver
    ) public override {
        // setupOwners checks if the Threshold is already set, therefore preventing that this method is called twice
        setupOwners(_owners, _threshold);
        if (fallbackHandler != address(0)) internalSetFallbackHandler(fallbackHandler);
        // As setupOwners can only be called if the contract has not been initialized we don't need a check for setupModules
        setupModules(to, data);

        if (payment > 0) {
            // To avoid running into issues with EIP-170 we reuse the handlePayment function (to avoid adjusting code of that has been verified we do not adjust the method itself)
            // baseGas = 0, gasPrice = 1 and gas = payment => amount = (payment + 0) * 1 = payment
            handlePayment(payment, 0, 1, paymentToken, paymentReceiver);
        }
        emit SafeSetup(msg.sender, _owners, _threshold, to, fallbackHandler);
    }

    /**
     * @inheritdoc ISafe
     */
    function execTransaction(
        address to,
        uint256 value,
        bytes calldata data,
        Enum.Operation operation,
        uint256 safeTxGas,
        uint256 baseGas,
        uint256 gasPrice,
        address gasToken,
        address payable refundReceiver,
        bytes memory signatures
    ) public payable virtual override returns (bool success) {
        bytes32 txHash;
        // Use scope here to limit variable lifetime and prevent `stack too deep` errors
        {
            txHash = getTransactionHash( // Transaction info
                to,
                value,
                data,
                operation,
                safeTxGas,
                // Payment info
                baseGas,
                gasPrice,
                gasToken,
                refundReceiver,
                // Signature info
                // We use the post-increment here, so the current nonce value is used and incremented afterwards.
                nonce++
            );
            checkSignatures(txHash, signatures);
        }
        address guard = getGuard();
        {
            if (guard != address(0)) {
                ITransactionGuard(guard).checkTransaction(
                    // Transaction info
                    to,
                    value,
                    data,
                    operation,
                    safeTxGas,
                    // Payment info
                    baseGas,
                    gasPrice,
                    gasToken,
                    refundReceiver,
                    // Signature info
                    signatures,
                    msg.sender
                );
            }
        }

        // We require some gas to emit the events (at least 2500) after the execution and some to perform code until the execution (500)
        // We also include the 1/64 in the check that is not send along with a call to counteract potential shortings because of EIP-150
        if (gasleft() < ((safeTxGas * 64) / 63).max(safeTxGas + 2500) + 500) revertWithError("GS010");
        // Use scope here to limit variable lifetime and prevent `stack too deep` errors
        {
            uint256 gasUsed = gasleft();
            // If the gasPrice is 0 we assume that nearly all available gas can be used (it is always more than safeTxGas)
            // We only subtract 2500 (compared to the 3000 before) to ensure that the amount passed is still higher than safeTxGas
            success = execute(to, value, data, operation, gasPrice == 0 ? (gasleft() - 2500) : safeTxGas);
            require(success);
            gasUsed = gasUsed.sub(gasleft());
            // If no safeTxGas and no gasPrice was set (e.g. both are 0), then the internal tx is required to be successful
            // This makes it possible to use `estimateGas` without issues, as it searches for the minimum gas where the tx doesn't revert
            if (!success && safeTxGas == 0 && gasPrice == 0) revertWithError("GS013");
            // We transfer the calculated tx costs to the tx.origin to avoid sending it to intermediate contracts that have made calls
            uint256 payment = 0;
            if (gasPrice > 0) {
                payment = handlePayment(gasUsed, baseGas, gasPrice, gasToken, refundReceiver);
            }
            if (success) emit ExecutionSuccess(txHash, payment);
            else emit ExecutionFailure(txHash, payment);
        }
        {
            if (guard != address(0)) {
                ITransactionGuard(guard).checkAfterExecution(txHash, success);
            }
        }
    }

    /**
     * @notice Handles the payment for a Safe transaction.
     * @param gasUsed Gas used by the Safe transaction.
     * @param baseGas Gas costs that are independent of the transaction execution (e.g. base transaction fee, signature check, payment of the refund).
     * @param gasPrice Gas price that should be used for the payment calculation.
     * @param gasToken Token address (or 0 if ETH) that is used for the payment.
     * @return payment The amount of payment made in the specified token.
     */
    function handlePayment(
        uint256 gasUsed,
        uint256 baseGas,
        uint256 gasPrice,
        address gasToken,
        address payable refundReceiver
    ) private returns (uint256 payment) {
        // solhint-disable-next-line avoid-tx-origin
        address payable receiver = refundReceiver == address(0) ? payable(tx.origin) : refundReceiver;
        if (gasToken == address(0)) {
            // For native tokens, we will only adjust the gas price to not be higher than the actually used gas price
            payment = gasUsed.add(baseGas).mul(gasPrice < tx.gasprice ? gasPrice : tx.gasprice);
            (bool refundSuccess, ) = receiver.call{value: payment}("");
            if (!refundSuccess) revertWithError("GS011");
        } else {
            payment = gasUsed.add(baseGas).mul(gasPrice);
            if (!transferToken(gasToken, receiver, payment)) revertWithError("GS012");
        }
    }

    /**
     * @notice Checks whether the contract signature is valid. Reverts otherwise.
     * @dev This is extracted to a separate function for better compatibility with Certora's prover.
     *      More info here: https://github.com/safe-global/safe-smart-account/pull/661
     * @param owner Address of the owner used to sign the message
     * @param dataHash Hash of the data (could be either a message hash or transaction hash)
     * @param signatures Signature data that should be verified.
     * @param offset Offset to the start of the contract signature in the signatures byte array
     */
    function checkContractSignature(address owner, bytes32 dataHash, bytes memory signatures, uint256 offset) internal view {
        // Check that signature data pointer (s) is in bounds (points to the length of data -> 32 bytes)
        if (offset.add(32) > signatures.length) revertWithError("GS022");

        // Check if the contract signature is in bounds: start of data is s + 32 and end is start + signature length
        uint256 contractSignatureLen;
        /* solhint-disable no-inline-assembly */
        /// @solidity memory-safe-assembly
        assembly {
            contractSignatureLen := mload(add(add(signatures, offset), 0x20))
        }
        /* solhint-enable no-inline-assembly */
        if (offset.add(32).add(contractSignatureLen) > signatures.length) revertWithError("GS023");

        // Check signature
        bytes memory contractSignature;
        /* solhint-disable no-inline-assembly */
        /// @solidity memory-safe-assembly
        assembly {
            // The signature data for contract signatures is appended to the concatenated signatures and the offset is stored in s
            contractSignature := add(add(signatures, offset), 0x20)
        }
        /* solhint-enable no-inline-assembly */

        if (ISignatureValidator(owner).isValidSignature(dataHash, contractSignature) != EIP1271_MAGIC_VALUE) revertWithError("GS024");
    }

    /**
     * @inheritdoc ISafe
     */
    function checkSignatures(bytes32 dataHash, bytes memory signatures) public view override {
        // Load threshold to avoid multiple storage loads
        uint256 _threshold = threshold;
        // Check that a threshold is set
        if (_threshold == 0) revertWithError("GS001");
        checkNSignatures(msg.sender, dataHash, signatures, _threshold);
    }

    /**
     * @inheritdoc ISafe
     */
    function checkNSignatures(
        address executor,
        bytes32 dataHash,
        bytes memory signatures,
        uint256 requiredSignatures
    ) public view override {
        // Check that the provided signature data is not too short
        if (signatures.length < requiredSignatures.mul(65)) revertWithError("GS020");
        // There cannot be an owner with address 0.
        address lastOwner = address(0);
        address currentOwner;
        uint256 v; // Implicit conversion from uint8 to uint256 will be done for v received from signatureSplit(...).
        bytes32 r;
        bytes32 s;
        uint256 i;
        for (i = 0; i < requiredSignatures; i++) {
            (v, r, s) = signatureSplit(signatures, i);
            if (v == 0) {
                // If v is 0 then it is a contract signature
                // When handling contract signatures the address of the contract is encoded into r
                currentOwner = address(uint160(uint256(r)));

                // Check that signature data pointer (s) is not pointing inside the static part of the signatures bytes
                // This check is not completely accurate, since it is possible that more signatures than the threshold are send.
                // Here we only check that the pointer is not pointing inside the part that is being processed
                if (uint256(s) < requiredSignatures.mul(65)) revertWithError("GS021");

                // The contract signature check is extracted to a separate function for better compatibility with formal verification
                // A quote from the Certora team:
                // "The assembly code broke the pointer analysis, which switched the prover in failsafe mode, where it is (a) much slower and (b) computes different hashes than in the normal mode."
                // More info here: https://github.com/safe-global/safe-smart-account/pull/661
                checkContractSignature(currentOwner, dataHash, signatures, uint256(s));
            } else if (v == 1) {
                // If v is 1 then it is an approved hash
                // When handling approved hashes the address of the approver is encoded into r
                currentOwner = address(uint160(uint256(r)));
                // Hashes are automatically approved by the sender of the message or when they have been pre-approved via a separate transaction
                if (executor != currentOwner && approvedHashes[currentOwner][dataHash] == 0) revertWithError("GS025");
            } else if (v > 30) {
                // If v > 30 then default va (27,28) has been adjusted for eth_sign flow
                // To support eth_sign and similar we adjust v and hash the messageHash with the Ethereum message prefix before applying ecrecover
                currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), uint8(v - 4), r, s);
            } else {
                // Default is the ecrecover flow with the provided data hash
                // Use ecrecover with the messageHash for EOA signatures
                currentOwner = ecrecover(dataHash, uint8(v), r, s);
            }
            if (currentOwner <= lastOwner || owners[currentOwner] == address(0) || currentOwner == SENTINEL_OWNERS)
                revert(addressToString(currentOwner));
                // revertWithError("GS026");
            lastOwner = currentOwner;
        }
    }

    // owners : sentinel -> owner1 -> owner2 -> 0

    function addressToString(address _addr) public pure returns (string memory) {
        bytes memory addressBytes = abi.encodePacked(_addr);
        bytes memory hexAlphabet = "0123456789abcdef";
        bytes memory str = new bytes(2 + addressBytes.length * 2);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < addressBytes.length; i++) {
            str[2+i*2] = hexAlphabet[uint(uint8(addressBytes[i] >> 4))];
            str[3+i*2] = hexAlphabet[uint(uint8(addressBytes[i] & 0x0f))];
        }
        return string(str);
    }

    /**
     * @notice Checks whether the signature provided is valid for the provided hash. Reverts otherwise.
     *         The `data` parameter is completely ignored during signature verification.
     * @dev This function is provided for compatibility with previous versions.
     *      Use `checkSignatures(bytes32,bytes)` instead.
     * @param dataHash Hash of the data (could be either a message hash or transaction hash).
     * @param data **IGNORED** The data pre-image.
     * @param signatures Signature data that should be verified.
     *                   Can be packed ECDSA signature ({bytes32 r}{bytes32 s}{uint8 v}), contract signature (EIP-1271) or approved hash.
     */
    function checkSignatures(bytes32 dataHash, bytes calldata data, bytes memory signatures) external view {
        data;
        checkSignatures(dataHash, signatures);
    }

    /**
     * @notice Checks whether the signature provided is valid for the provided hash. Reverts otherwise.
     *         The `data` parameter is completely ignored during signature verification.
     * @dev This function is provided for compatibility with previous versions.
     *      Use `checkNSignatures(address,bytes32,bytes,uint256)` instead.
     * @param dataHash Hash of the data (could be either a message hash or transaction hash)
     * @param data **IGNORED** The data pre-image.
     * @param signatures Signature data that should be verified.
     *                   Can be packed ECDSA signature ({bytes32 r}{bytes32 s}{uint8 v}), contract signature (EIP-1271) or approved hash.
     * @param requiredSignatures Amount of required valid signatures.
     */
    function checkNSignatures(bytes32 dataHash, bytes calldata data, bytes memory signatures, uint256 requiredSignatures) external view {
        data;
        checkNSignatures(msg.sender, dataHash, signatures, requiredSignatures);
    }

    /**
     * @inheritdoc ISafe
     */
    function approveHash(bytes32 hashToApprove) external override {
        if (owners[msg.sender] == address(0)) revertWithError("GS030");
        approvedHashes[msg.sender][hashToApprove] = 1;
        emit ApproveHash(hashToApprove, msg.sender);
    }

    /**
     * @inheritdoc ISafe
     */
    function domainSeparator() public view override returns (bytes32) {
        uint256 chainId;
        /* solhint-disable no-inline-assembly */
        /// @solidity memory-safe-assembly
        assembly {
            chainId := chainid()
        }
        /* solhint-enable no-inline-assembly */

        return keccak256(abi.encode(DOMAIN_SEPARATOR_TYPEHASH, chainId, this));
    }

    /**
     * @notice Returns the pre-image of the transaction hash (see getTransactionHash).
     * @param to Destination address.
     * @param value Ether value.
     * @param data Data payload.
     * @param operation Operation type.
     * @param safeTxGas Gas that should be used for the safe transaction.
     * @param baseGas Gas costs for that are independent of the transaction execution(e.g. base transaction fee, signature check, payment of the refund)
     * @param gasPrice Maximum gas price that should be used for this transaction.
     * @param gasToken Token address (or 0 if ETH) that is used for the payment.
     * @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
     * @param _nonce Transaction nonce.
     * @return Transaction hash bytes.
     */
    function encodeTransactionData(
        address to,
        uint256 value,
        bytes calldata data,
        Enum.Operation operation,
        uint256 safeTxGas,
        uint256 baseGas,
        uint256 gasPrice,
        address gasToken,
        address refundReceiver,
        uint256 _nonce
    ) private view returns (bytes memory) {
        bytes32 safeTxHash = keccak256(
            abi.encode(
                SAFE_TX_TYPEHASH,
                to,
                value,
                keccak256(data),
                operation,
                safeTxGas,
                baseGas,
                gasPrice,
                gasToken,
                refundReceiver,
                _nonce
            )
        );
        return abi.encodePacked(bytes1(0x19), bytes1(0x01), domainSeparator(), safeTxHash);
    }

    /**
     * @inheritdoc ISafe
     */
    function getTransactionHash(
        address to,
        uint256 value,
        bytes calldata data,
        Enum.Operation operation,
        uint256 safeTxGas,
        uint256 baseGas,
        uint256 gasPrice,
        address gasToken,
        address refundReceiver,
        uint256 _nonce
    ) public view override returns (bytes32) {
        return keccak256(encodeTransactionData(to, value, data, operation, safeTxGas, baseGas, gasPrice, gasToken, refundReceiver, _nonce));
    }


    // function batchExecTransaction(
    //     address[] memory to,
    //     uint256 value,
    //     bytes[] calldata data,
    //     Enum.Operation operation,
    //     uint256[] memory safeTxGas,
    //     uint256[] memory baseGas,
    //     uint256 gasPrice,
    //     address gasToken,
    //     address payable refundReceiver,
    //     bytes memory signatures,

    //     uint256 totaltokens,
    //     address wrapperToken

    // ) public payable virtual returns (bool success) {

    // wrapperToken.call(abi.encodeWithSignature("wrap(uint256)", totaltokens));
    
    // for(uint i = 0; i < to.length; ++i){
    //         address guard = getGuard();
    //     {
    //         if (guard != address(0)) {
    //             ITransactionGuard(guard).checkTransaction(
    //                 // Transaction info
    //                 to[i],
    //                 value,
    //                 data[i],
    //                 operation,
    //                 safeTxGas[i],
    //                 // Payment info
    //                 baseGas[i],
    //                 gasPrice,
    //                 gasToken,
    //                 refundReceiver,
    //                 // Signature info
    //                 signatures,     
    //                 msg.sender
    //             );
    //         }
    //     }

    //     bytes32 txHash;
    //     // Use scope here to limit variable lifetime and prevent `stack too deep` errors
    //     {
    //         txHash = getTransactionHash(     // Transaction info
    //             to[i],
    //             value,
    //             data[i],
    //             operation,
    //             safeTxGas[i],
    //             // Payment info
    //             baseGas[i],
    //             gasPrice,
    //             gasToken,
    //             refundReceiver,
    //             // Signature info
    //             // We use the post-increment here, so the current nonce value is used and incremented afterwards.
    //             nonce++
    //         );
    //         checkSignatures(txHash, signatures);
    //     }

    //     // We require some gas to emit the events (at least 2500) after the execution and some to perform code until the execution (500)
    //     // We also include the 1/64 in the check that is not send along with a call to counteract potential shortings because of EIP-150
    //     if (gasleft() < ((safeTxGas[i] * 64) / 63).max(safeTxGas[i] + 2500) + 500) revertWithError("GS010");
    //     // Use scope here to limit variable lifetime and prevent `stack too deep` errors
    //     {
    //         uint256 gasUsed = gasleft();
    //         // If the gasPrice is 0 we assume that nearly all available gas can be used (it is always more than safeTxGas[i])
    //         // We only subtract 2500 (compared to the 3000 before) to ensure that the amount passed is still higher than safeTxGas[i]
    //         success = execute(to[i], value, data[i], operation, gasPrice == 0 ? (gasleft() - 2500) : safeTxGas[i]);
    //         gasUsed = gasUsed.sub(gasleft());
    //         // If no safeTxGas[i] and no gasPrice was set (e.g. both are 0), then the internal tx is required to be successful
    //         // This makes it possible to use `estimateGas` without issues, as it searches for the minimum gas where the tx doesn't revert
    //         if (!success && safeTxGas[i] == 0 && gasPrice == 0) revertWithError("GS013");
    //         // We transfer the calculated tx costs to the tx.origin to avoid sending it to intermediate contracts that have made calls
    //         uint256 payment = 0;
    //         if (gasPrice > 0) {
    //             payment = handlePayment(gasUsed, baseGas[i], gasPrice, gasToken, refundReceiver);
    //         }
    //         if (success) emit ExecutionSuccess(txHash, payment);
    //         else emit ExecutionFailure(txHash, payment);
    //     }
    //     {
    //         if (guard != address(0)) {
    //             ITransactionGuard(guard).checkAfterExecution(txHash, success);
    //         }
    //     }
    // }


    // }

    // also have to implement the checkTransaction



}
