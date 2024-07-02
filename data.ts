erc20abi = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "src",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "guy",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "wad",
				"type": "uint256"
			}
		],
		"name": "Approval",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "dst",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "wad",
				"type": "uint256"
			}
		],
		"name": "Deposit",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "src",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "dst",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "wad",
				"type": "uint256"
			}
		],
		"name": "Transfer",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "src",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "wad",
				"type": "uint256"
			}
		],
		"name": "Withdrawal",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "guy",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "wad",
				"type": "uint256"
			}
		],
		"name": "approve",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "wad",
				"type": "uint256"
			}
		],
		"name": "burn",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "decimals",
		"outputs": [
			{
				"internalType": "uint8",
				"name": "",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAddress",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			}
		],
		"name": "getallowance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "mint",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "name",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "symbol",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "dst",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "wad",
				"type": "uint256"
			}
		],
		"name": "transfer",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "src",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "dst",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "wad",
				"type": "uint256"
			}
		],
		"name": "transferFrom",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];

erc20bytecode = 60806040526040518060400160405280600581526020017f4552433230000000000000000000000000000000000000000000000000000000815250600090816200004a91906200033c565b506040518060400160405280600581526020017f4552433230000000000000000000000000000000000000000000000000000000815250600190816200009191906200033c565b506004600260006101000a81548160ff021916908360ff160217905550348015620000bb57600080fd5b5062000423565b600081519050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b600060028204905060018216806200014457607f821691505b6020821081036200015a5762000159620000fc565b5b50919050565b60008190508160005260206000209050919050565b60006020601f8301049050919050565b600082821b905092915050565b600060088302620001c47fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8262000185565b620001d0868362000185565b95508019841693508086168417925050509392505050565b6000819050919050565b6000819050919050565b60006200021d620002176200021184620001e8565b620001f2565b620001e8565b9050919050565b6000819050919050565b6200023983620001fc565b62000251620002488262000224565b84845462000192565b825550505050565b600090565b6200026862000259565b620002758184846200022e565b505050565b5b818110156200029d57620002916000826200025e565b6001810190506200027b565b5050565b601f821115620002ec57620002b68162000160565b620002c18462000175565b81016020851015620002d1578190505b620002e9620002e08562000175565b8301826200027a565b50505b505050565b600082821c905092915050565b60006200031160001984600802620002f1565b1980831691505092915050565b60006200032c8383620002fe565b9150826002028217905092915050565b6200034782620000c2565b67ffffffffffffffff811115620003635762000362620000cd565b5b6200036f82546200012b565b6200037c828285620002a1565b600060209050601f831160018114620003b457600084156200039f578287015190505b620003ab85826200031e565b8655506200041b565b601f198416620003c48662000160565b60005b82811015620003ee57848901518255600182019150602085019450602081019050620003c7565b868310156200040e57848901516200040a601f891682620002fe565b8355505b6001600288020188555050505b505050505050565b610d8380620004336000396000f3fe608060405234801561001057600080fd5b50600436106100b45760003560e01c806338cc48311161007157806338cc4831146101a357806340c10f19146101c157806342966c68146101dd57806370a08231146101f957806395d89b4114610229578063a9059cbb14610247576100b4565b806306fdde03146100b9578063095ea7b3146100d757806318160ddd1461010757806321c4f09f1461012557806323b872dd14610155578063313ce56714610185575b600080fd5b6100c1610277565b6040516100ce91906109ad565b60405180910390f35b6100f160048036038101906100ec9190610a68565b610305565b6040516100fe9190610ac3565b60405180910390f35b61010f6103f7565b60405161011c9190610aed565b60405180910390f35b61013f600480360381019061013a9190610b08565b6103ff565b60405161014c9190610aed565b60405180910390f35b61016f600480360381019061016a9190610b48565b610486565b60405161017c9190610ac3565b60405180910390f35b61018d610748565b60405161019a9190610bb7565b60405180910390f35b6101ab61075b565b6040516101b89190610be1565b60405180910390f35b6101db60048036038101906101d69190610a68565b610763565b005b6101f760048036038101906101f29190610bfc565b6107bd565b005b610213600480360381019061020e9190610c29565b610862565b6040516102209190610aed565b60405180910390f35b61023161087a565b60405161023e91906109ad565b60405180910390f35b610261600480360381019061025c9190610a68565b610908565b60405161026e9190610ac3565b60405180910390f35b6000805461028490610c85565b80601f01602080910402602001604051908101604052809291908181526020018280546102b090610c85565b80156102fd5780601f106102d2576101008083540402835291602001916102fd565b820191906000526020600020905b8154815290600101906020018083116102e057829003601f168201915b505050505081565b600081600460003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055508273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040516103e59190610aed565b60405180910390a36001905092915050565b600047905090565b6000600460008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054905092915050565b60003373ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff161415801561056057507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff600460008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205414155b156106825781600460008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410156105ee57600080fd5b81600460008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825461067a9190610ce5565b925050819055505b81600360008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546106d19190610d19565b925050819055508273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040516107359190610aed565b60405180910390a3600190509392505050565b600260009054906101000a900460ff1681565b600030905090565b80600360008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546107b29190610d19565b925050819055505050565b80600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054101561080957600080fd5b80600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546108589190610ce5565b9250508190555050565b60036020528060005260406000206000915090505481565b6001805461088790610c85565b80601f01602080910402602001604051908101604052809291908181526020018280546108b390610c85565b80156109005780601f106108d557610100808354040283529160200191610900565b820191906000526020600020905b8154815290600101906020018083116108e357829003601f168201915b505050505081565b6000610915338484610486565b905092915050565b600081519050919050565b600082825260208201905092915050565b60005b8381101561095757808201518184015260208101905061093c565b60008484015250505050565b6000601f19601f8301169050919050565b600061097f8261091d565b6109898185610928565b9350610999818560208601610939565b6109a281610963565b840191505092915050565b600060208201905081810360008301526109c78184610974565b905092915050565b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b60006109ff826109d4565b9050919050565b610a0f816109f4565b8114610a1a57600080fd5b50565b600081359050610a2c81610a06565b92915050565b6000819050919050565b610a4581610a32565b8114610a5057600080fd5b50565b600081359050610a6281610a3c565b92915050565b60008060408385031215610a7f57610a7e6109cf565b5b6000610a8d85828601610a1d565b9250506020610a9e85828601610a53565b9150509250929050565b60008115159050919050565b610abd81610aa8565b82525050565b6000602082019050610ad86000830184610ab4565b92915050565b610ae781610a32565b82525050565b6000602082019050610b026000830184610ade565b92915050565b60008060408385031215610b1f57610b1e6109cf565b5b6000610b2d85828601610a1d565b9250506020610b3e85828601610a1d565b9150509250929050565b600080600060608486031215610b6157610b606109cf565b5b6000610b6f86828701610a1d565b9350506020610b8086828701610a1d565b9250506040610b9186828701610a53565b9150509250925092565b600060ff82169050919050565b610bb181610b9b565b82525050565b6000602082019050610bcc6000830184610ba8565b92915050565b610bdb816109f4565b82525050565b6000602082019050610bf66000830184610bd2565b92915050565b600060208284031215610c1257610c116109cf565b5b6000610c2084828501610a53565b91505092915050565b600060208284031215610c3f57610c3e6109cf565b5b6000610c4d84828501610a1d565b91505092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b60006002820490506001821680610c9d57607f821691505b602082108103610cb057610caf610c56565b5b50919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b6000610cf082610a32565b9150610cfb83610a32565b9250828203905081811115610d1357610d12610cb6565b5b92915050565b6000610d2482610a32565b9150610d2f83610a32565b9250828201905080821115610d4757610d46610cb6565b5b9291505056fea2646970667358221220e1669bdb12b0a68715f676145c396012d736ab38fa4af2b6b363ea274851b64964736f6c63430008120033;

safeabi = [
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "owner",
				"type": "address"
			}
		],
		"name": "AddedOwner",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "bytes32",
				"name": "approvedHash",
				"type": "bytes32"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "owner",
				"type": "address"
			}
		],
		"name": "ApproveHash",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "handler",
				"type": "address"
			}
		],
		"name": "ChangedFallbackHandler",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "guard",
				"type": "address"
			}
		],
		"name": "ChangedGuard",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "moduleGuard",
				"type": "address"
			}
		],
		"name": "ChangedModuleGuard",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "threshold",
				"type": "uint256"
			}
		],
		"name": "ChangedThreshold",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "module",
				"type": "address"
			}
		],
		"name": "DisabledModule",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "module",
				"type": "address"
			}
		],
		"name": "EnabledModule",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "bytes32",
				"name": "txHash",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "payment",
				"type": "uint256"
			}
		],
		"name": "ExecutionFailure",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "module",
				"type": "address"
			}
		],
		"name": "ExecutionFromModuleFailure",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "module",
				"type": "address"
			}
		],
		"name": "ExecutionFromModuleSuccess",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "bytes32",
				"name": "txHash",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "payment",
				"type": "uint256"
			}
		],
		"name": "ExecutionSuccess",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "owner",
				"type": "address"
			}
		],
		"name": "RemovedOwner",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "sender",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			}
		],
		"name": "SafeReceived",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "initiator",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "address[]",
				"name": "owners",
				"type": "address[]"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "threshold",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "initializer",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "fallbackHandler",
				"type": "address"
			}
		],
		"name": "SafeSetup",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "bytes32",
				"name": "msgHash",
				"type": "bytes32"
			}
		],
		"name": "SignMsg",
		"type": "event"
	},
	{
		"stateMutability": "nonpayable",
		"type": "fallback"
	},
	{
		"inputs": [],
		"name": "VERSION",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_threshold",
				"type": "uint256"
			}
		],
		"name": "addOwnerWithThreshold",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_addr",
				"type": "address"
			}
		],
		"name": "addressToString",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "hashToApprove",
				"type": "bytes32"
			}
		],
		"name": "approveHash",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			}
		],
		"name": "approvedHashes",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_threshold",
				"type": "uint256"
			}
		],
		"name": "changeThreshold",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "dataHash",
				"type": "bytes32"
			},
			{
				"internalType": "bytes",
				"name": "data",
				"type": "bytes"
			},
			{
				"internalType": "bytes",
				"name": "signatures",
				"type": "bytes"
			},
			{
				"internalType": "uint256",
				"name": "requiredSignatures",
				"type": "uint256"
			}
		],
		"name": "checkNSignatures",
		"outputs": [],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "executor",
				"type": "address"
			},
			{
				"internalType": "bytes32",
				"name": "dataHash",
				"type": "bytes32"
			},
			{
				"internalType": "bytes",
				"name": "signatures",
				"type": "bytes"
			},
			{
				"internalType": "uint256",
				"name": "requiredSignatures",
				"type": "uint256"
			}
		],
		"name": "checkNSignatures",
		"outputs": [],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "dataHash",
				"type": "bytes32"
			},
			{
				"internalType": "bytes",
				"name": "data",
				"type": "bytes"
			},
			{
				"internalType": "bytes",
				"name": "signatures",
				"type": "bytes"
			}
		],
		"name": "checkSignatures",
		"outputs": [],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "dataHash",
				"type": "bytes32"
			},
			{
				"internalType": "bytes",
				"name": "signatures",
				"type": "bytes"
			}
		],
		"name": "checkSignatures",
		"outputs": [],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "prevModule",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "module",
				"type": "address"
			}
		],
		"name": "disableModule",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "domainSeparator",
		"outputs": [
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "module",
				"type": "address"
			}
		],
		"name": "enableModule",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			},
			{
				"internalType": "bytes",
				"name": "data",
				"type": "bytes"
			},
			{
				"internalType": "enum Enum.Operation",
				"name": "operation",
				"type": "uint8"
			},
			{
				"internalType": "uint256",
				"name": "safeTxGas",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "baseGas",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "gasPrice",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "gasToken",
				"type": "address"
			},
			{
				"internalType": "address payable",
				"name": "refundReceiver",
				"type": "address"
			},
			{
				"internalType": "bytes",
				"name": "signatures",
				"type": "bytes"
			}
		],
		"name": "execTransaction",
		"outputs": [
			{
				"internalType": "bool",
				"name": "success",
				"type": "bool"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			},
			{
				"internalType": "bytes",
				"name": "data",
				"type": "bytes"
			},
			{
				"internalType": "enum Enum.Operation",
				"name": "operation",
				"type": "uint8"
			}
		],
		"name": "execTransactionFromModule",
		"outputs": [
			{
				"internalType": "bool",
				"name": "success",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			},
			{
				"internalType": "bytes",
				"name": "data",
				"type": "bytes"
			},
			{
				"internalType": "enum Enum.Operation",
				"name": "operation",
				"type": "uint8"
			}
		],
		"name": "execTransactionFromModuleReturnData",
		"outputs": [
			{
				"internalType": "bool",
				"name": "success",
				"type": "bool"
			},
			{
				"internalType": "bytes",
				"name": "returnData",
				"type": "bytes"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAddress",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "start",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "pageSize",
				"type": "uint256"
			}
		],
		"name": "getModulesPaginated",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "array",
				"type": "address[]"
			},
			{
				"internalType": "address",
				"name": "next",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getOwners",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "offset",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "length",
				"type": "uint256"
			}
		],
		"name": "getStorageAt",
		"outputs": [
			{
				"internalType": "bytes",
				"name": "",
				"type": "bytes"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getThreshold",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			},
			{
				"internalType": "bytes",
				"name": "data",
				"type": "bytes"
			},
			{
				"internalType": "enum Enum.Operation",
				"name": "operation",
				"type": "uint8"
			},
			{
				"internalType": "uint256",
				"name": "safeTxGas",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "baseGas",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "gasPrice",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "gasToken",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "refundReceiver",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_nonce",
				"type": "uint256"
			}
		],
		"name": "getTransactionHash",
		"outputs": [
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "module",
				"type": "address"
			}
		],
		"name": "isModuleEnabled",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			}
		],
		"name": "isOwner",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "latestOwner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "nonce",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "ownerCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "prevOwner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_threshold",
				"type": "uint256"
			}
		],
		"name": "removeOwner",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "handler",
				"type": "address"
			}
		],
		"name": "setFallbackHandler",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "guard",
				"type": "address"
			}
		],
		"name": "setGuard",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "moduleGuard",
				"type": "address"
			}
		],
		"name": "setModuleGuard",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address[]",
				"name": "_owners",
				"type": "address[]"
			},
			{
				"internalType": "uint256",
				"name": "_threshold",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "bytes",
				"name": "data",
				"type": "bytes"
			},
			{
				"internalType": "address",
				"name": "fallbackHandler",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "paymentToken",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "payment",
				"type": "uint256"
			},
			{
				"internalType": "address payable",
				"name": "paymentReceiver",
				"type": "address"
			}
		],
		"name": "setup",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			}
		],
		"name": "signedMessages",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "targetContract",
				"type": "address"
			},
			{
				"internalType": "bytes",
				"name": "calldataPayload",
				"type": "bytes"
			}
		],
		"name": "simulateAndRevert",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "prevOwner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "oldOwner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "swapOwner",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"stateMutability": "payable",
		"type": "receive"
	}
];

safebytecode = 608060405234801561001057600080fd5b506001600481905550615ff280620000296000396000f3fe6080604052600436106102085760003560e01c8063934f3a1111610118578063e068df37116100a0578063ed516d511161006f578063ed516d5114610870578063f08a032314610899578063f698da25146108c2578063f8dc5dd9146108ed578063ffa1ad74146109165761025d565b8063e068df37146107ca578063e19a9dd9146107f3578063e318b52b1461081c578063e75235b8146108455761025d565b8063b63e800d116100e7578063b63e800d146106d4578063cc2f8452146106fd578063d4d9bdcd1461073b578063d8d11f7814610764578063e009cfde146107a15761025d565b8063934f3a111461062c578063a0e67e2b14610655578063affed0e014610680578063b4faba09146106ab5761025d565b8063468721a71161019b5780635e57966d1161016a5780635e57966d14610530578063610b59251461056d578063694e80c3146105965780636a761202146105bf5780637d832974146105ef5761025d565b8063468721a71461043b5780635229073f146104785780635624b25b146104b65780635ae6bd37146104f35761025d565b80631fcac7f3116101d75780631fcac7f31461036d5780632d9ad53d146103965780632f54bf6e146103d357806338cc4831146104105761025d565b80630d582f13146102c55780630db02622146102ee57806312fb68e01461031957806319c4b593146103425761025d565b3661025d573373ffffffffffffffffffffffffffffffffffffffff167f3d0ce9bfc3ed7d6862dbb28b2dea94561fe714a1b4d019aa8af39730d1ad7c3d3460405161025391906146e6565b60405180910390a2005b34801561026957600080fd5b507f6c9a6c4a39284e37ed1cf53d337577d14212a4870fb976a4366c693b939918d5548061029657600080f35b60405136600082373360601b3682015260008060143601836000865af13d6000833e806102c1573d82fd5b3d82f35b3480156102d157600080fd5b506102ec60048036038101906102e7919061479f565b610941565b005b3480156102fa57600080fd5b50610303610ce2565b60405161031091906146e6565b60405180910390f35b34801561032557600080fd5b50610340600480360381019061033b91906149bb565b610ce8565b005b34801561034e57600080fd5b50610357610cfb565b6040516103649190614a6e565b60405180910390f35b34801561037957600080fd5b50610394600480360381019061038f9190614a89565b610d21565b005b3480156103a257600080fd5b506103bd60048036038101906103b89190614b0c565b61111b565b6040516103ca9190614b54565b60405180910390f35b3480156103df57600080fd5b506103fa60048036038101906103f59190614b0c565b6111ed565b6040516104079190614b54565b60405180910390f35b34801561041c57600080fd5b506104256112bd565b6040516104329190614a6e565b60405180910390f35b34801561044757600080fd5b50610462600480360381019061045d9190614b94565b6112c5565b60405161046f9190614b54565b60405180910390f35b34801561048457600080fd5b5061049f600480360381019061049a9190614b94565b61131e565b6040516104ad929190614c96565b60405180910390f35b3480156104c257600080fd5b506104dd60048036038101906104d89190614cc6565b611393565b6040516104ea9190614d06565b60405180910390f35b3480156104ff57600080fd5b5061051a60048036038101906105159190614d28565b61142b565b60405161052791906146e6565b60405180910390f35b34801561053c57600080fd5b5061055760048036038101906105529190614b0c565b611443565b6040516105649190614daa565b60405180910390f35b34801561057957600080fd5b50610594600480360381019061058f9190614b0c565b611762565b005b3480156105a257600080fd5b506105bd60048036038101906105b89190614dcc565b611a60565b005b6105d960048036038101906105d49190614e37565b611b11565b6040516105e69190614b54565b60405180910390f35b3480156105fb57600080fd5b5061061660048036038101906106119190614f53565b611e9e565b60405161062391906146e6565b60405180910390f35b34801561063857600080fd5b50610653600480360381019061064e9190614f93565b611ec3565b005b34801561066157600080fd5b5061066a611ed3565b60405161067791906150e1565b60405180910390f35b34801561068c57600080fd5b5061069561208b565b6040516106a291906146e6565b60405180910390f35b3480156106b757600080fd5b506106d260048036038101906106cd9190615103565b612091565b005b3480156106e057600080fd5b506106fb60048036038101906106f691906151b5565b6120b8565b005b34801561070957600080fd5b50610724600480360381019061071f919061479f565b61220b565b6040516107329291906152ac565b60405180910390f35b34801561074757600080fd5b50610762600480360381019061075d9190614d28565b612509565b005b34801561077057600080fd5b5061078b600480360381019061078691906152dc565b612663565b60405161079891906153eb565b60405180910390f35b3480156107ad57600080fd5b506107c860048036038101906107c39190615406565b612690565b005b3480156107d657600080fd5b506107f160048036038101906107ec9190614b0c565b61298d565b005b3480156107ff57600080fd5b5061081a60048036038101906108159190614b0c565b612b0a565b005b34801561082857600080fd5b50610843600480360381019061083e9190615446565b612c7e565b005b34801561085157600080fd5b5061085a6131c6565b60405161086791906146e6565b60405180910390f35b34801561087c57600080fd5b5061089760048036038101906108929190615499565b6131d0565b005b3480156108a557600080fd5b506108c060048036038101906108bb9190614b0c565b61321a565b005b3480156108ce57600080fd5b506108d7613271565b6040516108e491906153eb565b60405180910390f35b3480156108f957600080fd5b50610914600480360381019061090f91906154f5565b6132cb565b005b34801561092257600080fd5b5061092b613634565b6040516109389190614daa565b60405180910390f35b61094961366d565b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1614806109b05750600173ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16145b806109e657503073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16145b15610a1557610a147f47533230330000000000000000000000000000000000000000000000000000006136cc565b5b600073ffffffffffffffffffffffffffffffffffffffff16600260008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614610ad257610ad17f47533230340000000000000000000000000000000000000000000000000000006136cc565b5b60026000600173ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16600260008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508160026000600173ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555060036000815480929190610c4290615577565b919050555081600560006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff167f9465fa0c962cc76958e6373a993326400c1c94f8be2fe3a952adfa7f60b2ea2660405160405180910390a28060045414610cde57610cdd81611a60565b5b5050565b60035481565b610cf433868484610d21565b5050505050565b600560009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b610d3560418261370b90919063ffffffff16565b82511015610d6757610d667f47533032300000000000000000000000000000000000000000000000000000006136cc565b5b6000808060008060005b8681101561110f57610d83888261374f565b8260ff16925080945081955082965050505060008403610dff578260001c9450610db760418861370b90919063ffffffff16565b8260001c1015610deb57610dea7f47533032310000000000000000000000000000000000000000000000000000006136cc565b5b610dfa858a8a8560001c61377e565b610fb2565b60018403610ecd578260001c94508473ffffffffffffffffffffffffffffffffffffffff168a73ffffffffffffffffffffffffffffffffffffffff1614158015610e9957506000600960008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008b815260200190815260200160002054145b15610ec857610ec77f47533032350000000000000000000000000000000000000000000000000000006136cc565b5b610fb1565b601e841115610f5e57600189604051602001610ee99190615637565b60405160208183030381529060405280519060200120600486610f0c919061565d565b858560405160008152602001604052604051610f2b94939291906156ad565b6020604051602081039080840390855afa158015610f4d573d6000803e3d6000fd5b505050602060405103519450610fb0565b60018985858560405160008152602001604052604051610f8194939291906156ad565b6020604051602081039080840390855afa158015610fa3573d6000803e3d6000fd5b5050506020604051035194505b5b5b8573ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff161115806110785750600073ffffffffffffffffffffffffffffffffffffffff16600260008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16145b806110af5750600173ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff16145b156110f9576110bd85611443565b6040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016110f09190614daa565b60405180910390fd5b849550808061110790615577565b915050610d71565b50505050505050505050565b60008173ffffffffffffffffffffffffffffffffffffffff16600173ffffffffffffffffffffffffffffffffffffffff16141580156111e65750600073ffffffffffffffffffffffffffffffffffffffff16600160008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614155b9050919050565b6000600173ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1614806112b55750600073ffffffffffffffffffffffffffffffffffffffff16600260008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16145b159050919050565b600030905090565b60008060006112d68787878761392a565b91509150611307878787877fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff613b03565b9250611314828285613b5c565b5050949350505050565b600060606000806113318888888861392a565b91509150611362888888887fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff613b03565b9350604051925060203d0183016040523d83523d6000602085013e611388828286613b5c565b505094509492505050565b606060006020836113a491906156f2565b67ffffffffffffffff8111156113bd576113bc614890565b5b6040519080825280601f01601f1916602001820160405280156113ef5781602001600182028036833780820191505090505b50905060005b838110156114205780850154806020830260208501015250808061141890615577565b9150506113f5565b508091505092915050565b60086020528060005260406000206000915090505481565b6060600082604051602001611458919061577c565b604051602081830303815290604052905060006040518060400160405280601081526020017f303132333435363738396162636465660000000000000000000000000000000081525090506000600283516114b391906156f2565b60026114bf9190615797565b67ffffffffffffffff8111156114d8576114d7614890565b5b6040519080825280601f01601f19166020018201604052801561150a5781602001600182028036833780820191505090505b5090507f300000000000000000000000000000000000000000000000000000000000000081600081518110611542576115416157cb565b5b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a9053507f7800000000000000000000000000000000000000000000000000000000000000816001815181106115a6576115a56157cb565b5b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a90535060005b8351811015611756578260048583815181106115f7576115f66157cb565b5b602001015160f81c60f81b7effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916901c60f81c60ff168151811061163d5761163c6157cb565b5b602001015160f81c60f81b8260028361165691906156f2565b60026116629190615797565b81518110611673576116726157cb565b5b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a90535082600f60f81b8583815181106116bb576116ba6157cb565b5b602001015160f81c60f81b1660f81c60ff16815181106116de576116dd6157cb565b5b602001015160f81c60f81b826002836116f791906156f2565b60036117039190615797565b81518110611714576117136157cb565b5b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a905350808061174e90615577565b9150506115d8565b50809350505050919050565b61176a61366d565b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614806117d15750600173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16145b15611800576117ff7f47533130310000000000000000000000000000000000000000000000000000006136cc565b5b600073ffffffffffffffffffffffffffffffffffffffff16600160008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16146118bd576118bc7f47533130320000000000000000000000000000000000000000000000000000006136cc565b5b60016000600173ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16600160008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508060016000600173ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508073ffffffffffffffffffffffffffffffffffffffff167fecdf3a3effea5783a3c4c2140e677577666428d44ed9d474a0b3a4c9943f844060405160405180910390a250565b611a6861366d565b600354811115611a9c57611a9b7f47533230310000000000000000000000000000000000000000000000000000006136cc565b5b60008103611ace57611acd7f47533230320000000000000000000000000000000000000000000000000000006136cc565b5b806004819055507f610f7ff2b304ae8903c3de74c60c6ab1f7d6226b3f52c5161905bb5ad4039c93600454604051611b0691906146e6565b60405180910390a150565b600080611b3d8d8d8d8d8d8d8d8d8d8d60066000815480929190611b3490615577565b91905055612663565b90506000611b49613c95565b9050600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614611c01578073ffffffffffffffffffffffffffffffffffffffff166375f0bb528f8f8f8f8f8f8f8f8f8f8f336040518d63ffffffff1660e01b8152600401611bce9c9b9a999897969594939291906158ad565b600060405180830381600087803b158015611be857600080fd5b505af1158015611bfc573d6000803e3d6000fd5b505050505b6101f4611c3c6109c48b611c159190615797565b603f60408d611c2491906156f2565b611c2e9190615997565b613cbe90919063ffffffff16565b611c469190615797565b5a1015611c7757611c767f47533031300000000000000000000000000000000000000000000000000000006136cc565b5b60005a9050611ce98f8f8f8f8080601f016020809104026020016040519081016040528093929190818152602001838380828437600081840152601f19601f820116905080830192505050505050508e60008d14611cd5578e611ce4565b6109c45a611ce3919061565d565b5b613b03565b935083611cf557600080fd5b611d085a82613cd890919063ffffffff16565b905083158015611d18575060008a145b8015611d245750600088145b15611d5357611d527f47533031330000000000000000000000000000000000000000000000000000006136cc565b5b600080891115611d6d57611d6a828b8b8b8b613d01565b90505b8415611db057837f442e715f626346e8c54381002da614f62bee8d27386535b2521ec8540898556e82604051611da391906146e6565b60405180910390a2611de9565b837f23428b18acfb3ea64b08dc0c1d296ea9c09702c09083ca5272e64d115b687d2382604051611de091906146e6565b60405180910390a25b5050600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614611e8d578073ffffffffffffffffffffffffffffffffffffffff16639327136883856040518363ffffffff1660e01b8152600401611e5a9291906159c8565b600060405180830381600087803b158015611e7457600080fd5b505af1158015611e88573d6000803e3d6000fd5b505050505b50509b9a5050505050505050505050565b6009602052816000526040600020602052806000526040600020600091509150505481565b611ecd84826131d0565b50505050565b6060600060035467ffffffffffffffff811115611ef357611ef2614890565b5b604051908082528060200260200182016040528015611f215781602001602082028036833780820191505090505b50905060008060026000600173ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1690505b600173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16146120825780838381518110611fd357611fd26157cb565b5b602002602001019073ffffffffffffffffffffffffffffffffffffffff16908173ffffffffffffffffffffffffffffffffffffffff1681525050600260008273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050818061207a90615577565b925050611f8b565b82935050505090565b60065481565b600080825160208401855af46040518181523d60208201523d6000604083013e60403d0181fd5b6121038a8a80806020026020016040519081016040528093929190818152602001838360200280828437600081840152601f19601f8201169050808301925050505050505089613eb7565b600073ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff1614612141576121408461426a565b5b61218f8787878080601f016020809104026020016040519081016040528093929190818152602001838380828437600081840152601f19601f820116905080830192505050505050506142ed565b60008211156121a9576121a782600060018685613d01565b505b3373ffffffffffffffffffffffffffffffffffffffff167f141df868a6331af528e38c83b7aa03edc19be66e37ae67f9285bf4f8e3c6a1a88b8b8b8b896040516121f7959493929190615a7c565b60405180910390a250505050505050505050565b60606000600173ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff161415801561225257506122508461111b565b155b15612281576122807f47533130350000000000000000000000000000000000000000000000000000006136cc565b5b600083036122b3576122b27f47533130360000000000000000000000000000000000000000000000000000006136cc565b5b8267ffffffffffffffff8111156122cd576122cc614890565b5b6040519080825280602002602001820160405280156122fb5781602001602082028036833780820191505090505b5091506000600160008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1691505b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16141580156123cd5750600173ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1614155b80156123d857508381105b156124a057818382815181106123f1576123f06157cb565b5b602002602001019073ffffffffffffffffffffffffffffffffffffffff16908173ffffffffffffffffffffffffffffffffffffffff1681525050600160008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169150808061249890615577565b915050612363565b600173ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16146124fe57826001826124e2919061565d565b815181106124f3576124f26157cb565b5b602002602001015191505b808352509250929050565b600073ffffffffffffffffffffffffffffffffffffffff16600260003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16036125c6576125c57f47533033300000000000000000000000000000000000000000000000000000006136cc565b5b6001600960003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000838152602001908152602001600020819055503373ffffffffffffffffffffffffffffffffffffffff16817ff2a0eb156472d1440255b0d7c1e19cc07115d1051fe605b0dce69acfec884d9c60405160405180910390a350565b60006126788c8c8c8c8c8c8c8c8c8c8c6144f7565b8051906020012090509b9a5050505050505050505050565b61269861366d565b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614806126ff5750600173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16145b1561272e5761272d7f47533130310000000000000000000000000000000000000000000000000000006136cc565b5b8073ffffffffffffffffffffffffffffffffffffffff16600160008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16146127ea576127e97f47533130330000000000000000000000000000000000000000000000000000006136cc565b5b600160008273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16600160008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506000600160008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508073ffffffffffffffffffffffffffffffffffffffff167faab4fa2b463f581b2b32cb3b7e3b704b9ce37cc209b5fb4d77e593ace405427660405160405180910390a25050565b61299561366d565b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614158015612a6957508073ffffffffffffffffffffffffffffffffffffffff166301ffc9a77f58401ed8000000000000000000000000000000000000000000000000000000006040518263ffffffff1660e01b8152600401612a269190615b05565b602060405180830381865afa158015612a43573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190612a679190615b4c565b155b15612a9857612a977f47533330310000000000000000000000000000000000000000000000000000006136cc565b5b60007fb104e0b93118902c651344349b610029d694cfdec91c589c91ebafbcd028994760001b90508181558173ffffffffffffffffffffffffffffffffffffffff167fcd1966d6be16bc0c030cc741a06c6e0efaf8d00de2c8b6a9e11827e125de8bb860405160405180910390a25050565b612b1261366d565b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614158015612be657508073ffffffffffffffffffffffffffffffffffffffff166301ffc9a77fe6d7a83a000000000000000000000000000000000000000000000000000000006040518263ffffffff1660e01b8152600401612ba39190615b05565b602060405180830381865afa158015612bc0573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190612be49190615b4c565b155b15612c1557612c147f47533330300000000000000000000000000000000000000000000000000000006136cc565b5b807f4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8558073ffffffffffffffffffffffffffffffffffffffff167f1151116914515bc0891ff9047a6cb32cf902546f83066499bcf8ba33d2353fa260405160405180910390a250565b612c8661366d565b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff161480612ced5750600173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16145b80612d2357503073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16145b15612d5257612d517f47533230330000000000000000000000000000000000000000000000000000006136cc565b5b600073ffffffffffffffffffffffffffffffffffffffff16600260008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614612e0f57612e0e7f47533230340000000000000000000000000000000000000000000000000000006136cc565b5b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff161480612e765750600173ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16145b15612ea557612ea47f47533230330000000000000000000000000000000000000000000000000000006136cc565b5b8173ffffffffffffffffffffffffffffffffffffffff16600260008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614612f6157612f607f47533230350000000000000000000000000000000000000000000000000000006136cc565b5b600260008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16600260008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555080600260008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506000600260008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff167ff8d49fc529812e9a7c5c50e69c20f0dccc0db8fa95c98bc58cc9a4f1c1299eaf60405160405180910390a28073ffffffffffffffffffffffffffffffffffffffff167f9465fa0c962cc76958e6373a993326400c1c94f8be2fe3a952adfa7f60b2ea2660405160405180910390a2505050565b6000600454905090565b6000600454905060008103613209576132087f47533030310000000000000000000000000000000000000000000000000000006136cc565b5b61321533848484610d21565b505050565b61322261366d565b61322b8161426a565b8073ffffffffffffffffffffffffffffffffffffffff167f5ac6c46c93c8d0e53714ba3b53db3e7c046da994313d7ed0d192028bc7c228b060405160405180910390a250565b6000804690507f47e79534a245952e8b16893a336b85a3d9ea9fa8c573f3d803afb92a7946921860001b81306040516020016132af93929190615bd8565b6040516020818303038152906040528051906020012091505090565b6132d361366d565b8060016003546132e3919061565d565b1015613313576133127f47533230310000000000000000000000000000000000000000000000000000006136cc565b5b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16148061337a5750600173ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16145b156133a9576133a87f47533230330000000000000000000000000000000000000000000000000000006136cc565b5b8173ffffffffffffffffffffffffffffffffffffffff16600260008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614613465576134647f47533230350000000000000000000000000000000000000000000000000000006136cc565b5b600260008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16600260008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506000600260008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600360008154809291906135d490615c0f565b91905055508173ffffffffffffffffffffffffffffffffffffffff167ff8d49fc529812e9a7c5c50e69c20f0dccc0db8fa95c98bc58cc9a4f1c1299eaf60405160405180910390a2806004541461362f5761362e81611a60565b5b505050565b6040518060400160405280600581526020017f312e342e3100000000000000000000000000000000000000000000000000000081525081565b3073ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146136ca576136c97f47533033310000000000000000000000000000000000000000000000000000006136cc565b5b565b6040517f08c379a00000000000000000000000000000000000000000000000000000000081526020600482015260056024820152816044820152606481fd5b600080830361371d5760009050613749565b6000828461372b91906156f2565b905082848261373a9190615997565b1461374457600080fd5b809150505b92915050565b6000806000836041026020810186015192506040810186015191506060810186015160001a9350509250925092565b81516137946020836145b990919063ffffffff16565b11156137c4576137c37f47533032320000000000000000000000000000000000000000000000000000006136cc565b5b600060208284010151905082516137f7826137e96020866145b990919063ffffffff16565b6145b990919063ffffffff16565b1115613827576138267f47533032330000000000000000000000000000000000000000000000000000006136cc565b5b60606020838501019050631626ba7e60e01b7bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19168673ffffffffffffffffffffffffffffffffffffffff16631626ba7e87846040518363ffffffff1660e01b8152600401613893929190615c38565b602060405180830381865afa1580156138b0573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906138d49190615c94565b7bffffffffffffffffffffffffffffffffffffffffffffffffffffffff191614613922576139217f47533032340000000000000000000000000000000000000000000000000000006136cc565b5b505050505050565b6000806139356145e1565b9150600173ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614158015613a005750600073ffffffffffffffffffffffffffffffffffffffff16600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614155b613a3f576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401613a3690615d0d565b60405180910390fd5b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1614613afa578173ffffffffffffffffffffffffffffffffffffffff1663728c297287878787336040518663ffffffff1660e01b8152600401613ab4959493929190615d2d565b6020604051808303816000875af1158015613ad3573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190613af79190615d9c565b90505b94509492505050565b6000600180811115613b1857613b17615827565b5b836001811115613b2b57613b2a615827565b5b03613b43576000808551602087018986f49050613b53565b600080855160208701888a87f190505b95945050505050565b600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614613bfe578273ffffffffffffffffffffffffffffffffffffffff16632acc37aa83836040518363ffffffff1660e01b8152600401613bcb9291906159c8565b600060405180830381600087803b158015613be557600080fd5b505af1158015613bf9573d6000803e3d6000fd5b505050505b8015613c4c573373ffffffffffffffffffffffffffffffffffffffff167f6895c13664aa4f67288b25d7a21d7aaa34916e355fb9b6fae0a139a9085becb860405160405180910390a2613c90565b3373ffffffffffffffffffffffffffffffffffffffff167facd2c8702804128fdb0db2bb49f6d127dd0181c13fd45dbfe16de0930e2bd37560405160405180910390a25b505050565b60007f4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c854905090565b600081831015613cce5781613cd0565b825b905092915050565b600082821115613ce757600080fd5b60008284613cf5919061565d565b90508091505092915050565b600080600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614613d3e5782613d40565b325b9050600073ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff1603613e4c57613da93a8610613d86573a613d88565b855b613d9b888a6145b990919063ffffffff16565b61370b90919063ffffffff16565b915060008173ffffffffffffffffffffffffffffffffffffffff1683604051613dd190615dfa565b60006040518083038185875af1925050503d8060008114613e0e576040519150601f19603f3d011682016040523d82523d6000602084013e613e13565b606091505b5050905080613e4657613e457f47533031310000000000000000000000000000000000000000000000000000006136cc565b5b50613ead565b613e7185613e63888a6145b990919063ffffffff16565b61370b90919063ffffffff16565b9150613e7e848284614612565b613eac57613eab7f47533031320000000000000000000000000000000000000000000000000000006136cc565b5b5b5095945050505050565b60006004541115613eec57613eeb7f47533230300000000000000000000000000000000000000000000000000000006136cc565b5b8151811115613f1f57613f1e7f47533230310000000000000000000000000000000000000000000000000000006136cc565b5b60008103613f5157613f507f47533230320000000000000000000000000000000000000000000000000000006136cc565b5b60006001905060005b83518110156141d6576000848281518110613f7857613f776157cb565b5b60200260200101519050600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff161480613fe95750600173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16145b8061401f57503073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16145b8061405557508073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff16145b15614084576140837f47533230330000000000000000000000000000000000000000000000000000006136cc565b5b600073ffffffffffffffffffffffffffffffffffffffff16600260008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614614141576141407f47533230340000000000000000000000000000000000000000000000000000006136cc565b5b80600260008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508092505080806141ce90615577565b915050613f5a565b506001600260008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550825160038190555081600481905550505050565b3073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16036142c7576142c67f47533430300000000000000000000000000000000000000000000000000000006136cc565b5b807f6c9a6c4a39284e37ed1cf53d337577d14212a4870fb976a4366c693b939918d55550565b600073ffffffffffffffffffffffffffffffffffffffff1660016000600173ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16146143ab576143aa7f47533130300000000000000000000000000000000000000000000000000000006136cc565b5b6001806000600173ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16146144f357614467826146ba565b614495576144947f47533030320000000000000000000000000000000000000000000000000000006136cc565b5b6144c48260008360017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff613b03565b6144f2576144f17f47533030300000000000000000000000000000000000000000000000000000006136cc565b5b5b5050565b606060007fbb8310d486368db6bd6f849402fdd73ad53d316b5a4b2644ad6efe0f941286d860001b8d8d8d8d604051614531929190615e34565b60405180910390208c8c8c8c8c8c8c60405160200161455a9b9a99989796959493929190615e4d565b604051602081830303815290604052805190602001209050601960f81b600160f81b614584613271565b836040516020016145989493929190615f45565b6040516020818303038152906040529150509b9a5050505050505050505050565b60008082846145c89190615797565b9050838110156145d757600080fd5b8091505092915050565b6000807fb104e0b93118902c651344349b610029d694cfdec91c589c91ebafbcd028994760001b9050805491505090565b60008063a9059cbb848460405160240161462d929190615f93565b6040516020818303038152906040529060e01b6020820180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff83818316178352505050509050602060008251602084016000896127105a03f13d6000811461469d57602081146146a557600093506146b0565b8193506146b0565b600051158215171593505b5050509392505050565b600080823b905060008111915050919050565b6000819050919050565b6146e0816146cd565b82525050565b60006020820190506146fb60008301846146d7565b92915050565b6000604051905090565b600080fd5b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b600061474082614715565b9050919050565b61475081614735565b811461475b57600080fd5b50565b60008135905061476d81614747565b92915050565b61477c816146cd565b811461478757600080fd5b50565b60008135905061479981614773565b92915050565b600080604083850312156147b6576147b561470b565b5b60006147c48582860161475e565b92505060206147d58582860161478a565b9150509250929050565b6000819050919050565b6147f2816147df565b81146147fd57600080fd5b50565b60008135905061480f816147e9565b92915050565b600080fd5b600080fd5b600080fd5b60008083601f84011261483a57614839614815565b5b8235905067ffffffffffffffff8111156148575761485661481a565b5b6020830191508360018202830111156148735761487261481f565b5b9250929050565b600080fd5b6000601f19601f8301169050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6148c88261487f565b810181811067ffffffffffffffff821117156148e7576148e6614890565b5b80604052505050565b60006148fa614701565b905061490682826148bf565b919050565b600067ffffffffffffffff82111561492657614925614890565b5b61492f8261487f565b9050602081019050919050565b82818337600083830152505050565b600061495e6149598461490b565b6148f0565b90508281526020810184848401111561497a5761497961487a565b5b61498584828561493c565b509392505050565b600082601f8301126149a2576149a1614815565b5b81356149b284826020860161494b565b91505092915050565b6000806000806000608086880312156149d7576149d661470b565b5b60006149e588828901614800565b955050602086013567ffffffffffffffff811115614a0657614a05614710565b5b614a1288828901614824565b9450945050604086013567ffffffffffffffff811115614a3557614a34614710565b5b614a418882890161498d565b9250506060614a528882890161478a565b9150509295509295909350565b614a6881614735565b82525050565b6000602082019050614a836000830184614a5f565b92915050565b60008060008060808587031215614aa357614aa261470b565b5b6000614ab18782880161475e565b9450506020614ac287828801614800565b935050604085013567ffffffffffffffff811115614ae357614ae2614710565b5b614aef8782880161498d565b9250506060614b008782880161478a565b91505092959194509250565b600060208284031215614b2257614b2161470b565b5b6000614b308482850161475e565b91505092915050565b60008115159050919050565b614b4e81614b39565b82525050565b6000602082019050614b696000830184614b45565b92915050565b60028110614b7c57600080fd5b50565b600081359050614b8e81614b6f565b92915050565b60008060008060808587031215614bae57614bad61470b565b5b6000614bbc8782880161475e565b9450506020614bcd8782880161478a565b935050604085013567ffffffffffffffff811115614bee57614bed614710565b5b614bfa8782880161498d565b9250506060614c0b87828801614b7f565b91505092959194509250565b600081519050919050565b600082825260208201905092915050565b60005b83811015614c51578082015181840152602081019050614c36565b60008484015250505050565b6000614c6882614c17565b614c728185614c22565b9350614c82818560208601614c33565b614c8b8161487f565b840191505092915050565b6000604082019050614cab6000830185614b45565b8181036020830152614cbd8184614c5d565b90509392505050565b60008060408385031215614cdd57614cdc61470b565b5b6000614ceb8582860161478a565b9250506020614cfc8582860161478a565b9150509250929050565b60006020820190508181036000830152614d208184614c5d565b905092915050565b600060208284031215614d3e57614d3d61470b565b5b6000614d4c84828501614800565b91505092915050565b600081519050919050565b600082825260208201905092915050565b6000614d7c82614d55565b614d868185614d60565b9350614d96818560208601614c33565b614d9f8161487f565b840191505092915050565b60006020820190508181036000830152614dc48184614d71565b905092915050565b600060208284031215614de257614de161470b565b5b6000614df08482850161478a565b91505092915050565b6000614e0482614715565b9050919050565b614e1481614df9565b8114614e1f57600080fd5b50565b600081359050614e3181614e0b565b92915050565b60008060008060008060008060008060006101408c8e031215614e5d57614e5c61470b565b5b6000614e6b8e828f0161475e565b9b50506020614e7c8e828f0161478a565b9a505060408c013567ffffffffffffffff811115614e9d57614e9c614710565b5b614ea98e828f01614824565b99509950506060614ebc8e828f01614b7f565b9750506080614ecd8e828f0161478a565b96505060a0614ede8e828f0161478a565b95505060c0614eef8e828f0161478a565b94505060e0614f008e828f0161475e565b935050610100614f128e828f01614e22565b9250506101208c013567ffffffffffffffff811115614f3457614f33614710565b5b614f408e828f0161498d565b9150509295989b509295989b9093969950565b60008060408385031215614f6a57614f6961470b565b5b6000614f788582860161475e565b9250506020614f8985828601614800565b9150509250929050565b60008060008060608587031215614fad57614fac61470b565b5b6000614fbb87828801614800565b945050602085013567ffffffffffffffff811115614fdc57614fdb614710565b5b614fe887828801614824565b9350935050604085013567ffffffffffffffff81111561500b5761500a614710565b5b6150178782880161498d565b91505092959194509250565b600081519050919050565b600082825260208201905092915050565b6000819050602082019050919050565b61505881614735565b82525050565b600061506a838361504f565b60208301905092915050565b6000602082019050919050565b600061508e82615023565b615098818561502e565b93506150a38361503f565b8060005b838110156150d45781516150bb888261505e565b97506150c683615076565b9250506001810190506150a7565b5085935050505092915050565b600060208201905081810360008301526150fb8184615083565b905092915050565b6000806040838503121561511a5761511961470b565b5b60006151288582860161475e565b925050602083013567ffffffffffffffff81111561514957615148614710565b5b6151558582860161498d565b9150509250929050565b60008083601f84011261517557615174614815565b5b8235905067ffffffffffffffff8111156151925761519161481a565b5b6020830191508360208202830111156151ae576151ad61481f565b5b9250929050565b6000806000806000806000806000806101008b8d0312156151d9576151d861470b565b5b60008b013567ffffffffffffffff8111156151f7576151f6614710565b5b6152038d828e0161515f565b9a509a505060206152168d828e0161478a565b98505060406152278d828e0161475e565b97505060608b013567ffffffffffffffff81111561524857615247614710565b5b6152548d828e01614824565b965096505060806152678d828e0161475e565b94505060a06152788d828e0161475e565b93505060c06152898d828e0161478a565b92505060e061529a8d828e01614e22565b9150509295989b9194979a5092959850565b600060408201905081810360008301526152c68185615083565b90506152d56020830184614a5f565b9392505050565b60008060008060008060008060008060006101408c8e0312156153025761530161470b565b5b60006153108e828f0161475e565b9b505060206153218e828f0161478a565b9a505060408c013567ffffffffffffffff81111561534257615341614710565b5b61534e8e828f01614824565b995099505060606153618e828f01614b7f565b97505060806153728e828f0161478a565b96505060a06153838e828f0161478a565b95505060c06153948e828f0161478a565b94505060e06153a58e828f0161475e565b9350506101006153b78e828f0161475e565b9250506101206153c98e828f0161478a565b9150509295989b509295989b9093969950565b6153e5816147df565b82525050565b600060208201905061540060008301846153dc565b92915050565b6000806040838503121561541d5761541c61470b565b5b600061542b8582860161475e565b925050602061543c8582860161475e565b9150509250929050565b60008060006060848603121561545f5761545e61470b565b5b600061546d8682870161475e565b935050602061547e8682870161475e565b925050604061548f8682870161475e565b9150509250925092565b600080604083850312156154b0576154af61470b565b5b60006154be85828601614800565b925050602083013567ffffffffffffffff8111156154df576154de614710565b5b6154eb8582860161498d565b9150509250929050565b60008060006060848603121561550e5761550d61470b565b5b600061551c8682870161475e565b935050602061552d8682870161475e565b925050604061553e8682870161478a565b9150509250925092565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b6000615582826146cd565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff82036155b4576155b3615548565b5b600182019050919050565b600081905092915050565b7f19457468657265756d205369676e6564204d6573736167653a0a333200000000600082015250565b6000615600601c836155bf565b915061560b826155ca565b601c82019050919050565b6000819050919050565b61563161562c826147df565b615616565b82525050565b6000615642826155f3565b915061564e8284615620565b60208201915081905092915050565b6000615668826146cd565b9150615673836146cd565b925082820390508181111561568b5761568a615548565b5b92915050565b600060ff82169050919050565b6156a781615691565b82525050565b60006080820190506156c260008301876153dc565b6156cf602083018661569e565b6156dc60408301856153dc565b6156e960608301846153dc565b95945050505050565b60006156fd826146cd565b9150615708836146cd565b9250828202615716816146cd565b9150828204841483151761572d5761572c615548565b5b5092915050565b60008160601b9050919050565b600061574c82615734565b9050919050565b600061575e82615741565b9050919050565b61577661577182614735565b615753565b82525050565b60006157888284615765565b60148201915081905092915050565b60006157a2826146cd565b91506157ad836146cd565b92508282019050808211156157c5576157c4615548565b5b92915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b60006158068385614c22565b935061581383858461493c565b61581c8361487f565b840190509392505050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602160045260246000fd5b6002811061586757615866615827565b5b50565b600081905061587882615856565b919050565b60006158888261586a565b9050919050565b6158988161587d565b82525050565b6158a781614df9565b82525050565b6000610160820190506158c3600083018f614a5f565b6158d0602083018e6146d7565b81810360408301526158e3818c8e6157fa565b90506158f2606083018b61588f565b6158ff608083018a6146d7565b61590c60a08301896146d7565b61591960c08301886146d7565b61592660e0830187614a5f565b61593461010083018661589e565b8181036101208301526159478185614c5d565b9050615957610140830184614a5f565b9d9c50505050505050505050505050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fd5b60006159a2826146cd565b91506159ad836146cd565b9250826159bd576159bc615968565b5b828204905092915050565b60006040820190506159dd60008301856153dc565b6159ea6020830184614b45565b9392505050565b6000819050919050565b6000615a0a602084018461475e565b905092915050565b6000602082019050919050565b6000615a2b838561502e565b9350615a36826159f1565b8060005b85811015615a6f57615a4c82846159fb565b615a56888261505e565b9750615a6183615a12565b925050600181019050615a3a565b5085925050509392505050565b60006080820190508181036000830152615a97818789615a1f565b9050615aa660208301866146d7565b615ab36040830185614a5f565b615ac06060830184614a5f565b9695505050505050565b60007fffffffff0000000000000000000000000000000000000000000000000000000082169050919050565b615aff81615aca565b82525050565b6000602082019050615b1a6000830184615af6565b92915050565b615b2981614b39565b8114615b3457600080fd5b50565b600081519050615b4681615b20565b92915050565b600060208284031215615b6257615b6161470b565b5b6000615b7084828501615b37565b91505092915050565b6000819050919050565b6000615b9e615b99615b9484614715565b615b79565b614715565b9050919050565b6000615bb082615b83565b9050919050565b6000615bc282615ba5565b9050919050565b615bd281615bb7565b82525050565b6000606082019050615bed60008301866153dc565b615bfa60208301856146d7565b615c076040830184615bc9565b949350505050565b6000615c1a826146cd565b915060008203615c2d57615c2c615548565b5b600182039050919050565b6000604082019050615c4d60008301856153dc565b8181036020830152615c5f8184614c5d565b90509392505050565b615c7181615aca565b8114615c7c57600080fd5b50565b600081519050615c8e81615c68565b92915050565b600060208284031215615caa57615ca961470b565b5b6000615cb884828501615c7f565b91505092915050565b7f4753313034000000000000000000000000000000000000000000000000000000600082015250565b6000615cf7600583614d60565b9150615d0282615cc1565b602082019050919050565b60006020820190508181036000830152615d2681615cea565b9050919050565b600060a082019050615d426000830188614a5f565b615d4f60208301876146d7565b8181036040830152615d618186614c5d565b9050615d70606083018561588f565b615d7d6080830184614a5f565b9695505050505050565b600081519050615d96816147e9565b92915050565b600060208284031215615db257615db161470b565b5b6000615dc084828501615d87565b91505092915050565b600081905092915050565b50565b6000615de4600083615dc9565b9150615def82615dd4565b600082019050919050565b6000615e0582615dd7565b9150819050919050565b6000615e1b8385615dc9565b9350615e2883858461493c565b82840190509392505050565b6000615e41828486615e0f565b91508190509392505050565b600061016082019050615e63600083018e6153dc565b615e70602083018d614a5f565b615e7d604083018c6146d7565b615e8a606083018b6153dc565b615e97608083018a61588f565b615ea460a08301896146d7565b615eb160c08301886146d7565b615ebe60e08301876146d7565b615ecc610100830186614a5f565b615eda610120830185614a5f565b615ee86101408301846146d7565b9c9b505050505050505050505050565b60007fff0000000000000000000000000000000000000000000000000000000000000082169050919050565b6000819050919050565b615f3f615f3a82615ef8565b615f24565b82525050565b6000615f518287615f2e565b600182019150615f618286615f2e565b600182019150615f718285615620565b602082019150615f818284615620565b60208201915081905095945050505050565b6000604082019050615fa86000830185614a5f565b615fb560208301846146d7565b939250505056fea2646970667358221220a924508c95e612035eb978571827298703a236b79ed2d0a7a90d925cb35bca6064736f6c63430008120033;

encryptederc20abi = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_erc20",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"internalType": "bytes32",
				"name": "publicKey",
				"type": "bytes32"
			},
			{
				"internalType": "bytes",
				"name": "signature",
				"type": "bytes"
			}
		],
		"name": "allowance",
		"outputs": [
			{
				"internalType": "bytes",
				"name": "",
				"type": "bytes"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"internalType": "bytes",
				"name": "encryptedAmount",
				"type": "bytes"
			}
		],
		"name": "approve",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "publicKey",
				"type": "bytes32"
			},
			{
				"internalType": "address",
				"name": "user",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "bytes",
				"name": "",
				"type": "bytes"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "claim",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "decimals",
		"outputs": [
			{
				"internalType": "uint8",
				"name": "",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAddress",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "publicKey",
				"type": "bytes32"
			},
			{
				"internalType": "bytes",
				"name": "signature",
				"type": "bytes"
			}
		],
		"name": "getTotalSupply",
		"outputs": [
			{
				"internalType": "bytes",
				"name": "",
				"type": "bytes"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "make",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes",
				"name": "encryptedAmount",
				"type": "bytes"
			}
		],
		"name": "mint",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "bytes",
				"name": "encryptedAmount",
				"type": "bytes"
			}
		],
		"name": "mintTo",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "name",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "originalToken",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "bytes",
				"name": "encryptedAmount",
				"type": "bytes"
			}
		],
		"name": "transfer",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "bytes",
				"name": "encryptedAmount",
				"type": "bytes"
			}
		],
		"name": "transferFrom",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			},
			{
				"internalType": "bytes",
				"name": "depositData",
				"type": "bytes"
			}
		],
		"name": "wrapAndDistribute",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];



encryptederc20bytecode = 0x608060405234801561001057600080fd5b50600436106101165760003560e01c80634e71d92d116100a2578063a9059cbb11610071578063a9059cbb14610249578063b6ce514b1461025c578063c20382361461026f578063c6dad0821461012e578063f98aa0851461028257600080fd5b80634e71d92d146102005780637b7c65c9146102085780637ba0e2e71461021b57806384b0196e1461022e57600080fd5b806329723511116100e957806329723511146101a7578063313ce567146101ba57806338cc4831146101d45780633d3503d9146101da57806349972663146101ed57600080fd5b8063014647f41461011b57806306fdde03146101305780630e7c1cb51461016957806323b872dd14610194575b600080fd5b61012e61012936600461149b565b610295565b005b6101536040518060400160405280600481526020016310d554d160e21b81525081565b6040516101609190611540565b60405180910390f35b60035461017c906001600160a01b031681565b6040516001600160a01b039091168152602001610160565b61012e6101a2366004611553565b610310565b61012e6101b536600461149b565b610327565b6101c2601281565b60405160ff9091168152602001610160565b3061017c565b61012e6101e8366004611682565b61036f565b61012e6101fb3660046116d2565b6103ce565b61012e610412565b610153610216366004611737565b6104c7565b61012e61022936600461176a565b6105c6565b610236610612565b604051610160979695949392919061179f565b61012e610257366004611835565b61069a565b61015361026a366004611861565b6106a9565b61015361027d3660046118a5565b610794565b61012e6102903660046118d5565b6107c5565b600033905061030a81856102de86868080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525061091192505050565b6001600160a01b0392831660009081526006602090815260408083209490951682529290925291902055565b50505050565b3361031c84828461091e565b61030a848484610965565b61036a8361025784848080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525061091192505050565b505050565b600061037a82610911565b6001600160a01b0384166000908152600560205260409020549091506103a09082610a00565b6001600160a01b0384166000908152600560205260409020556002546103c69082610a00565b600255505050565b61030a84846101a285858080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525061091192505050565b3360009081526005602052604081205461042b90610a32565b60035460405163a9059cbb60e01b815233600482015263ffffffff929092166024830181905292506001600160a01b03169063a9059cbb906044016020604051808303816000875af1158015610485573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906104a99190611906565b506104b46000610a3d565b3360009081526005602052604090205550565b6007546060906001600160a01b031633146104e157600080fd5b8383838080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920182905250604080517f051d137ae0e1fae6e3b6559fed4442b35a85a9a39789838ad5c9ea05e7da2dce602082015290810187905290935061056d925060600190505b60405160208183030381529060405280519060200120610a4a565b9050600061057b8284610a77565b90506001600160a01b03811633146105ae5760405162461bcd60e51b81526004016105a590611928565b60405180910390fd5b6105ba60025489610a9b565b98975050505050505050565b60006105d182610911565b336000908152600560205260409020549091506105ee9082610a00565b3360009081526005602052604090205560025461060b9082610a00565b6002555050565b6000606080828080836106457f417574686f72697a6174696f6e20746f6b656e0000000000000000000000001383610aa7565b6106707f31000000000000000000000000000000000000000000000000000000000000016001610aa7565b60408051600080825260208201909252600f60f81b9b939a50919850469750309650945092509050565b6106a5338383610965565b5050565b60608383838080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920182905250604080517f051d137ae0e1fae6e3b6559fed4442b35a85a9a39789838ad5c9ea05e7da2dce602082015290810187905290935061072092506060019050610552565b9050600061072e8284610a77565b90506001600160a01b03811633146107585760405162461bcd60e51b81526004016105a590611928565b3360008181526006602090815260408083206001600160a01b038e168452909152902054610786908a610a9b565b9a9950505050505050505050565b6001600160a01b0381166000908152600560205260408120546060916107bc91908590610b52565b90505b92915050565b6003546040516323b872dd60e01b8152336004820152306024820152604481018490526001600160a01b03909116906323b872dd906064016020604051808303816000875af115801561081c573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906108409190611906565b5060008180602001905181019061085791906119be565b90506000805b82518110156108ed576108aa83828151811061087b5761087b611ac8565b60200260200101516000015184838151811061089957610899611ac8565b60200260200101516020015161036f565b6108d9826108d48584815181106108c3576108c3611ac8565b602002602001015160200151610911565b610a00565b9150806108e581611ade565b91505061085d565b506109086109036108fd86610a3d565b83610b8a565b610bc6565b61030a57600080fd5b60006107bf826002610bd9565b6001600160a01b038381166000908152600660209081526040808320938616835292905220546109566109518383610c6f565b610ca4565b61030a84846102de8486610cb0565b6001600160a01b03831660009081526005602052604090205461098d90610951908390610c6f565b6001600160a01b0382166000908152600560205260409020546109b09082610a00565b6001600160a01b0380841660009081526005602052604080822093909355908516815220546109df9082610cb0565b6001600160a01b039093166000908152600560205260409020929092555050565b600082610a1457610a116000610a3d565b92505b81610a2657610a236000610a3d565b91505b6107bc83836000610ce2565b60006107bf82610d7c565b60006107bf826002610de0565b60006107bf610a57610e59565b8360405161190160f01b8152600281019290925260228201526042902090565b6000806000610a868585610f89565b91509150610a9381610fce565b509392505050565b60606107bc8383611118565b606060ff8314610ac157610aba83611187565b90506107bf565b818054610acd90611b05565b80601f0160208091040260200160405190810160405280929190818152602001828054610af990611b05565b8015610b465780601f10610b1b57610100808354040283529160200191610b46565b820191906000526020600020905b815481529060010190602001808311610b2957829003601f168201915b505050505090506107bf565b60608315610b6b57610b648484611118565b9050610b83565b610b64610b7d8363ffffffff16610a3d565b84611118565b9392505050565b600082610b9e57610b9b6000610a3d565b92505b81610bb057610bad6000610a3d565b91505b6107bc610bbf848460006111c6565b600061121a565b6000610bd182610d7c565b151592915050565b600080838360f81b604051602001610bf2929190611b3f565b60408051601f1981840301815290829052630964a5d960e31b82529150605d90634b252ec890610c26908490600401611540565b602060405180830381865afa158015610c43573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610c679190611b6e565b949350505050565b600082610c8357610c806000610a3d565b92505b81610c9557610c926000610a3d565b91505b6107bc610bbf84846000611256565b610cad816112aa565b50565b600082610cc457610cc16000610a3d565b92505b81610cd657610cd36000610a3d565b91505b6107bc83836000611304565b6000808215610cf65750600160f81b610cfa565b5060005b60405163f953e42760e01b815260048101869052602481018590526001600160f81b031982166044820152605d9063f953e427906064015b602060405180830381865afa158015610d4f573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610d739190611b6e565b95945050505050565b6040516301693b9160e61b815260048101829052600090605d90635a4ee44090602401602060405180830381865afa158015610dbc573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906107bf9190611b6e565b604051631ce2e8d760e31b8152600481018390526001600160f81b031960f883901b166024820152600090605d9063e71746b8906044015b602060405180830381865afa158015610e35573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906107bc9190611b6e565b6000306001600160a01b037f0000000000000000000000001957175e82b796c3fa9728b78480a7b0873f91d816148015610eb257507f000000000000000000000000000000000000000000000000000000000000238246145b15610edc57507f59c4fd213aca35124416d7856d3d526856cff9e2439c04256dbeddd8ccce8f3590565b610f84604080517f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f60208201527f5500f54e5ea2f303f8f25b99ddb6c00279547d2d10cd0a07e724974c777097ab918101919091527fc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc660608201524660808201523060a082015260009060c00160405160208183030381529060405280519060200120905090565b905090565b6000808251604103610fbf5760208301516040840151606085015160001a610fb387828585611358565b94509450505050610fc7565b506000905060025b9250929050565b6000816004811115610fe257610fe2611b87565b03610fea5750565b6001816004811115610ffe57610ffe611b87565b0361104b5760405162461bcd60e51b815260206004820152601860248201527f45434453413a20696e76616c6964207369676e6174757265000000000000000060448201526064016105a5565b600281600481111561105f5761105f611b87565b036110ac5760405162461bcd60e51b815260206004820152601f60248201527f45434453413a20696e76616c6964207369676e6174757265206c656e6774680060448201526064016105a5565b60038160048111156110c0576110c0611b87565b03610cad5760405162461bcd60e51b815260206004820152602260248201527f45434453413a20696e76616c6964207369676e6174757265202773272076616c604482015261756560f01b60648201526084016105a5565b60405163d6ad57cd60e01b81526004810183905260248101829052606090605d9063d6ad57cd90604401600060405180830381865afa15801561115f573d6000803e3d6000fd5b505050506040513d6000823e601f3d908101601f191682016040526107bc9190810190611b9d565b606060006111948361141c565b604080516020808252818301909252919250600091906020820181803683375050509182525060208101929092525090565b60008082156111da5750600160f81b6111de565b5060005b60405163052896f160e01b815260048101869052602481018590526001600160f81b031982166044820152605d9063052896f190606401610d32565b60405163025f346960e51b8152600481018390526001600160f81b031960f883901b166024820152600090605d90634be68d2090604401610e18565b600080821561126a5750600160f81b61126e565b5060005b6040516334a6d7b960e11b815260048101869052602481018590526001600160f81b031982166044820152605d9063694daf7290606401610d32565b6000816040516024016112bf91815260200190565b60408051601f198184030181529190526020810180516001600160e01b0316634ee071a160e01b1781528151919250605d9060009081908490845afa61030a57600080fd5b60008082156113185750600160f81b61131c565b5060005b604051638c14cc2160e01b815260048101869052602481018590526001600160f81b031982166044820152605d90638c14cc2190606401610d32565b6000807f7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a083111561138f5750600090506003611413565b6040805160008082526020820180845289905260ff881692820192909252606081018690526080810185905260019060a0016020604051602081039080840390855afa1580156113e3573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b03811661140c57600060019250925050611413565b9150600090505b94509492505050565b600060ff8216601f8111156107bf57604051632cd44ac360e21b815260040160405180910390fd5b6001600160a01b0381168114610cad57600080fd5b60008083601f84011261146b57600080fd5b50813567ffffffffffffffff81111561148357600080fd5b602083019150836020828501011115610fc757600080fd5b6000806000604084860312156114b057600080fd5b83356114bb81611444565b9250602084013567ffffffffffffffff8111156114d757600080fd5b6114e386828701611459565b9497909650939450505050565b60005b8381101561150b5781810151838201526020016114f3565b50506000910152565b6000815180845261152c8160208601602086016114f0565b601f01601f19169290920160200192915050565b6020815260006107bc6020830184611514565b60008060006060848603121561156857600080fd5b833561157381611444565b9250602084013561158381611444565b929592945050506040919091013590565b634e487b7160e01b600052604160045260246000fd5b6040805190810167ffffffffffffffff811182821017156115cd576115cd611594565b60405290565b604051601f8201601f1916810167ffffffffffffffff811182821017156115fc576115fc611594565b604052919050565b600067ffffffffffffffff82111561161e5761161e611594565b50601f01601f191660200190565b600082601f83011261163d57600080fd5b813561165061164b82611604565b6115d3565b81815284602083860101111561166557600080fd5b816020850160208301376000918101602001919091529392505050565b6000806040838503121561169557600080fd5b82356116a081611444565b9150602083013567ffffffffffffffff8111156116bc57600080fd5b6116c88582860161162c565b9150509250929050565b600080600080606085870312156116e857600080fd5b84356116f381611444565b9350602085013561170381611444565b9250604085013567ffffffffffffffff81111561171f57600080fd5b61172b87828801611459565b95989497509550505050565b60008060006040848603121561174c57600080fd5b83359250602084013567ffffffffffffffff8111156114d757600080fd5b60006020828403121561177c57600080fd5b813567ffffffffffffffff81111561179357600080fd5b610c678482850161162c565b60ff60f81b881681526000602060e0818401526117bf60e084018a611514565b83810360408501526117d1818a611514565b606085018990526001600160a01b038816608086015260a0850187905284810360c0860152855180825283870192509083019060005b8181101561182357835183529284019291840191600101611807565b50909c9b505050505050505050505050565b6000806040838503121561184857600080fd5b823561185381611444565b946020939093013593505050565b6000806000806060858703121561187757600080fd5b843561188281611444565b935060208501359250604085013567ffffffffffffffff81111561171f57600080fd5b600080604083850312156118b857600080fd5b8235915060208301356118ca81611444565b809150509250929050565b600080604083850312156118e857600080fd5b82359150602083013567ffffffffffffffff8111156116bc57600080fd5b60006020828403121561191857600080fd5b81518015158114610b8357600080fd5b60208082526031908201527f454950373132207369676e657220616e64207472616e73616374696f6e2073696040820152700cedccae440c8de40dcdee840dac2e8c6d607b1b606082015260800190565b600082601f83011261198a57600080fd5b815161199861164b82611604565b8181528460208386010111156119ad57600080fd5b610c678260208301602087016114f0565b600060208083850312156119d157600080fd5b825167ffffffffffffffff808211156119e957600080fd5b818501915085601f8301126119fd57600080fd5b815181811115611a0f57611a0f611594565b8060051b611a1e8582016115d3565b9182528381018501918581019089841115611a3857600080fd5b86860192505b83831015611abb57825185811115611a565760008081fd5b86016040818c03601f1901811315611a6e5760008081fd5b611a766115aa565b89830151611a8381611444565b8152908201519087821115611a985760008081fd5b611aa68d8b84860101611979565b818b0152845250509186019190860190611a3e565b9998505050505050505050565b634e487b7160e01b600052603260045260246000fd5b600060018201611afe57634e487b7160e01b600052601160045260246000fd5b5060010190565b600181811c90821680611b1957607f821691505b602082108103611b3957634e487b7160e01b600052602260045260246000fd5b50919050565b60008351611b518184602088016114f0565b6001600160f81b0319939093169190920190815260010192915050565b600060208284031215611b8057600080fd5b5051919050565b634e487b7160e01b600052602160045260246000fd5b600060208284031215611baf57600080fd5b815167ffffffffffffffff811115611bc657600080fd5b610c678482850161197956fea164736f6c6343000814000a;