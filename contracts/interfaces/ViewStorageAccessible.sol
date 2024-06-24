// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.5.0 <0.9.0;
interface ViewStorageAccessible {
    /**
     * @dev Same as `simulate` on StorageAccessible. Marked as view so that it can be called from external contracts
     * that want to run simulations from within view functions. Will revert if the invoked simulation attempts to change state.
     */
    function simulate(address targetContract, bytes calldata calldataPayload) external view returns (bytes memory);
}
