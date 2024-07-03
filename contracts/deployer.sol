import { Safe } from "./Safe.sol";
import { ERC20 } from "./ERC20.sol";
import { EncryptedERC20 } from "./EncryptedERC20.sol";

contract deployer {
    function deployPOC(
        address[] memory ownerSafeOwners,
        address[] memory recipient1SafeOwners,
        address[] memory recipient2SafeOwners,
        address[] memory recipient3SafeOwners
    ) public returns (address, address, address, address, address, address) {
        Safe ownerSafe = new Safe(ownerSafeOwners, 1);
        Safe recipient1Safe = new Safe(recipient1SafeOwners, 1);
        Safe recipient2Safe = new Safe(recipient2SafeOwners, 1);
        Safe recipient3Safe = new Safe(recipient3SafeOwners, 1);
        ERC20 erc20 = new ERC20();
        EncryptedERC20 encryptedERC20 = new EncryptedERC20(address(erc20));

        erc20.mint(address(ownerSafe), 1000000);

        return (
            address(ownerSafe),
            address(recipient1Safe),
            address(recipient2Safe),
            address(recipient3Safe),
            address(erc20),
            address(encryptedERC20)
        );
    }
}
