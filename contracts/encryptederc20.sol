// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity >=0.8.9 <0.9.0;

import "fhevm/lib/TFHE.sol";
import "fhevm/abstracts/EIP712WithModifier.sol";
import {ERC20} from "./ERC20.sol";

contract EncryptedERC20 is EIP712WithModifier {
    euint32 private totalSupply;
    string public constant name = "CUSD";
    uint8 public constant decimals = 18;
    ERC20 public originalToken;

    struct depositstruct{
        address to;
        bytes encryptedAmount;
    }

    // used for output authorization
    bytes32 private DOMAIN_SEPARATOR;

    // A mapping from address to an encrypted balance.
    mapping(address => euint32) internal balances;

    // A mapping of the form mapping(owner => mapping(spender => allowance)).
    mapping(address => mapping(address => euint32)) internal allowances;

    // The owner of the contract.
    address internal contractOwner;

    constructor(address _erc20) EIP712WithModifier("Authorization token", "1") {
        contractOwner = msg.sender;
        originalToken = ERC20(_erc20);
    }

    function make() public pure {}

    function wrapAndDistribute(uint256 amount, bytes memory depositData) public {
        originalToken.transferFrom(msg.sender, address(this), amount);
        depositstruct[] memory data = abi.decode(depositData, (depositstruct[]));
        euint32 totalamount;
        for(uint i; i < data.length; i++) {
            mintTo(data[i].to, data[i].encryptedAmount);
            totalamount = TFHE.add(totalamount, TFHE.asEuint32(data[i].encryptedAmount));
        }
        require(TFHE.decrypt(TFHE.ge(TFHE.asEuint32(amount), totalamount)));
        // return (TFHE.decrypt(TFHE.asEuint32(data[0].encryptedAmount)), TFHE.decrypt(TFHE.asEuint32(data[1].encryptedAmount)), TFHE.decrypt(TFHE.asEuint32(data[2].encryptedAmount)));
    }

    function claim() public{
        uint256 bal = uint256(TFHE.decrypt(balances[msg.sender]));
        originalToken.transfer(msg.sender, bal);
        balances[msg.sender] = TFHE.asEuint32(0);
    }

    function getAddress() public view returns (address) {
        return address(this);
    }

    // Sets the balance of the owner to the given encrypted balance.
    function mint(bytes memory encryptedAmount) public {
        euint32 amount = TFHE.asEuint32(encryptedAmount);
        balances[msg.sender] = TFHE.add(balances[msg.sender], amount);
        totalSupply = TFHE.add(totalSupply, amount);
    }

    function mintTo(address to , bytes memory encryptedAmount) public {
        euint32 amount = TFHE.asEuint32(encryptedAmount);
        balances[to] = TFHE.add(balances[to], amount);
        totalSupply = TFHE.add(totalSupply, amount);
    }

    // Transfers an encrypted amount from the message sender address to the `to` address.
    function transfer(address to, bytes calldata encryptedAmount) public {
        transfer(to, TFHE.asEuint32(encryptedAmount));
    }

    // Transfers an amount from the message sender address to the `to` address.
    function transfer(address to, euint32 amount) public {
        _transfer(msg.sender, to, amount);
    }

    function getTotalSupply(
        bytes32 publicKey,
        bytes calldata signature
    )
        public
        view
        onlyContractOwner
        onlySignedPublicKey(publicKey, signature)
        returns (bytes memory)
    {
        return TFHE.reencrypt(totalSupply, publicKey);
    }


    // Returns the balance of the caller under their public FHE key.
    // The FHE public key is automatically determined based on the origin of the call.
    function balanceOf(
        bytes32 publicKey,
        address user
    )
        public
        view
        returns (bytes memory)
    {
        return TFHE.reencrypt(balances[user], publicKey, 0);
    }

    // Sets the `encryptedAmount` as the allowance of `spender` over the caller's tokens.
    function approve(address spender, bytes calldata encryptedAmount) public {
        address owner = msg.sender;
        _approve(owner, spender, TFHE.asEuint32(encryptedAmount));
    }

    // Returns the remaining number of tokens that `spender` is allowed to spend
    // on behalf of the caller. The returned ciphertext is under the caller public FHE key.
    function allowance(
        address spender,
        bytes32 publicKey,
        bytes calldata signature
    )
        public
        view
        onlySignedPublicKey(publicKey, signature)
        returns (bytes memory)
    {
        address owner = msg.sender;

        return TFHE.reencrypt(_allowance(owner, spender), publicKey);
    }

    // Transfers `encryptedAmount` tokens using the caller's allowance.
    function transferFrom(
        address from,
        address to,
        bytes calldata encryptedAmount
    ) public {
        transferFrom(from, to, TFHE.asEuint32(encryptedAmount));
    }

    // Transfers `amount` tokens using the caller's allowance.
    function transferFrom(address from, address to, euint32 amount) public {
        address spender = msg.sender;
        _updateAllowance(from, spender, amount);
        _transfer(from, to, amount);
    }

    function _approve(address owner, address spender, euint32 amount) internal {
        allowances[owner][spender] = amount;
    }

    function _allowance(
        address owner,
        address spender
    ) internal view returns (euint32) {
        return allowances[owner][spender];
    }

    function _updateAllowance(
        address owner,
        address spender,
        euint32 amount
    ) internal {
        euint32 currentAllowance = _allowance(owner, spender);
        TFHE.optReq(TFHE.le(amount, currentAllowance));
        _approve(owner, spender, TFHE.sub(currentAllowance, amount));
    }

    // Transfers an encrypted amount.
    function _transfer(address from, address to, euint32 amount) internal {
        // Make sure the sender has enough tokens.
        TFHE.optReq(TFHE.le(amount, balances[from]));

        // Add to the balance of `to` and subract from the balance of `from`.
        balances[to] = TFHE.add(balances[to], amount);
        balances[from] = TFHE.sub(balances[from], amount);
    }

    modifier onlyContractOwner() {
        require(msg.sender == contractOwner);
        _;
    }
}
