// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.7.0 <0.9.0;
abstract contract StorageAccessible {
    /**
     * @notice Reads `length` bytes of storage in the currents contract
     * @param offset - the offset in the current contract's storage in words to start reading from
     * @param length - the number of words (32 bytes) of data to read
     * @return the bytes that were read.
     */
    function getStorageAt(uint256 offset, uint256 length) public view returns (bytes memory) {
        bytes memory result = new bytes(length * 32);
        for (uint256 index = 0; index < length; index++) {
            /* solhint-disable no-inline-assembly */
            /// @solidity memory-safe-assembly
            assembly {
                let word := sload(add(offset, index))
                mstore(add(add(result, 0x20), mul(index, 0x20)), word)
            }
            /* solhint-enable no-inline-assembly */
        }
        return result;
    }

    /**
     * @dev Performs a delegatecall on a targetContract in the context of self.
     * Internally reverts execution to avoid side effects (making it static).
     *
     * This method reverts with data equal to `abi.encode(bool(success), bytes(response))`.
     * Specifically, the `returndata` after a call to this method will be:
     * `success:bool || response.length:uint256 || response:bytes`.
     *
     * @param targetContract Address of the contract containing the code to execute.
     * @param calldataPayload Calldata that should be sent to the target contract (encoded method name and arguments).
     */
    function simulateAndRevert(address targetContract, bytes memory calldataPayload) external {
        /* solhint-disable no-inline-assembly */
        /// @solidity memory-safe-assembly
        assembly {
            let success := delegatecall(gas(), targetContract, add(calldataPayload, 0x20), mload(calldataPayload), 0, 0)
            // Load free memory location
            let ptr := mload(0x40)
            mstore(ptr, success)
            mstore(add(ptr, 0x20), returndatasize())
            returndatacopy(add(ptr, 0x40), 0, returndatasize())
            revert(ptr, add(returndatasize(), 0x40))
        }
        /* solhint-enable no-inline-assembly */
    }
}
