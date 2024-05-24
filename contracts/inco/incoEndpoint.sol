pragma solidity 0.8.20;

import {IMailbox} from "@hyperlane-xyz/core/contracts/interfaces/IMailbox.sol";
// import {IPostDispatchHook} from ".deps/npm/@hyperlane-xyz/core/contracts/interfaces/hooks/IPostDispatchHook.sol";
import {IInterchainSecurityModule} from "@hyperlane-xyz/core/contracts/interfaces/IInterchainSecurityModule.sol";

import "fhevm/lib/TFHE.sol";

import {Proposal} from "./types.sol";
import { IExecutionStrategy } from "./interfaces/IExecutionStrategy.sol";

@title Endpoint contract in Inco during bridging of data
contract IncoContract {
    address public mailbox = 0x18a2B6a086EE7d4070Cf675BDf27717d03258FcF;
    address public lastSender;
    bytes public lastData;
    uint32 public domainId = 17001;
    address public destinationContract;
    event ReceivedMessage(uint32, bytes32, uint256, string);

    struct choiceData {
        uint256 proposalId;
        uint32 votingPower;
    }

    struct executeData {
        uint256 proposalId;
        bytes executionPayload;
    }

    mapping(uint256 proposalId => mapping(uint8 choice => euint32 votePower)) public votePower;

    // contains the status of choice being updated
    mapping(bytes => bool[2]) public collectChoiceHashStatus;   // [true, false] if updated first time(by hyperlane), and [true, true] if updated send time(by offchain-server)
    // contains the data(proposalId, votePower) related to the choice during voting
    mapping(bytes => choiceData) public collectChoiceData;

    // contains the status of execution being done
    mapping(bytes32 => bool[2]) public collectExecuteHashStatus;   // [true, false] if updated first time(by hyperlane), and [true, true] if updated send time(by offchain-server)
    
    // contains the data(proposalId, executionPayload) related to the choice during voting
    mapping(bytes32 => executeData) public collectExecuteData;

    // mapping whether the execution of a proposalId is done or not
    mapping(uint256 proposalId => bool) public isExecuted;

    /// @dev getter function for isExecuted mapping
    function getIsExecuted(uint256 proposalId) public view returns(bool){
        return isExecuted[proposalId];
    }


    // IPostDispatchHook public hook;
    IInterchainSecurityModule public interchainSecurityModule = IInterchainSecurityModule(0x79411A19a8722Dd3D4DbcB0def6d10783237adad);

    /// @dev getter function for collectChoiceHashStatus mapping
    function getCollectChoiceHashStatus(bytes memory choiceHash) public view returns(bool[2] memory){
        return collectChoiceHashStatus[choiceHash];
    }

    /// @dev getter function for collectChoiceData mapping
    function getCollectChoiceData(bytes memory choiceHash) public view returns(choiceData memory){
        return collectChoiceData[choiceHash];
    }
    
    function setHook(address _hook) public {
        // hook = IPostDispatchHook(_hook);
    }

    /// @notice initialize the contract with the destination contract to send data to using hyperlane
    function initialize(address _destinationContract) public {
        destinationContract = _destinationContract;
    }

    function setInterchainSecurityModule(address _module) public {
        interchainSecurityModule = IInterchainSecurityModule(_module);
    }

    /// @dev Modifier so that only mailbox can call particular functions
    modifier onlyMailbox() {
        require(
            msg.sender == mailbox,
            "Only mailbox can call this function !!!"
        );
        _;
    }

    /// @notice handle function which is called by the mailbox to bridge votes from other chains
    /// @param _origin The domain of the origin chain
    /// @param _sender The address of the sender on the origin chain
    /// @param _data The data sent by the _sender
    function handle(
        uint32 _origin,
        bytes32 _sender,
        bytes calldata _data
    ) external payable {
        emit ReceivedMessage(_origin, _sender, msg.value, string(_data));
        lastSender = bytes32ToAddress(_sender);
        lastData = _data;
        uint8 selector = abi.decode(_data, (uint8));
        if (selector == 1) {
            (,uint256 proposalId, uint32 votingPower, bytes memory choiceHash) = abi.decode(_data, (uint8, uint256, uint32, bytes));
            require(collectChoiceHashStatus[choiceHash][0]!= true);
            collectChoiceHashStatus[choiceHash] = [true, false];
            collectChoiceData[choiceHash] = choiceData(proposalId, votingPower);
        } else if (selector == 2) {
            (, uint256 proposalId, bytes32 proposalhash, bytes memory executionPayload) = abi.decode(_data, (uint8, uint256, bytes32, bytes));
            require(collectExecuteHashStatus[proposalhash][0]!= true);
            collectExecuteHashStatus[proposalhash] = [true, false];
            collectExecuteData[proposalhash] = executeData(proposalId, executionPayload);
        }
    }

    function bytes32ToAddress(bytes32 _buf) internal pure returns (address) {
        return address(uint160(uint256(_buf)));
    }

    /// @notice Function to send the data through hyperlane to destination chain and address
    /// @param data data to send
    function sendMessage(bytes calldata data) payable public {
        // uint256 quote = IMailbox(mailbox).quoteDispatch(domainId, addressToBytes32(destinationContract), abi.encode(body));
        IMailbox(mailbox).dispatch(domainId, addressToBytes32(destinationContract), data);
    }

    // converts address to bytes32
    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }

    /// @notice aggregated votes corresponding to choice and proposalId in form of bytes
    /// @param proposalId proposal Id
    /// @param choice type of vote
    /// @param publicKey publicKey of fhevmInstance which was used to encrypt the choice
    function getVotePower(uint256 proposalId, uint8 choice, bytes32 publicKey) public view returns (bytes memory) {             // @inco
        return TFHE.reencrypt(votePower[proposalId][choice], publicKey, 0);
    }

    /// @dev cast the vote by updating the `votePower` mapping after validating the choice with the choiceHash
    /// @param choiceHash has of the choice
    function vote(bytes memory choiceHash, bytes memory choice) public {
        require(keccxak256(choice) == bytes32(choiceHash));
        bool[2] memory status = collectChoiceHashStatus[choiceHash];
        require(status[0] == true && status[1] == false);
        uint256 proposalId = collectChoiceData[choiceHash].proposalId;
        uint32 votingPower = collectChoiceData[choiceHash].votingPower;
        votePower[proposalId][TFHE.decrypt(TFHE.asEuint8(choice))] = TFHE.add(votePower[proposalId][TFHE.decrypt(TFHE.asEuint8(choice))], votingPower);
        collectChoiceHashStatus[choiceHash] = [true, true];
    }

    /// @dev execute the proposal 
    /// @param proposalhash has of the proposal struct corresponding to the proposalId
    /// @param proposal proposal related to the proposalId
    /// @param blockNumber Blocknumber of the target chain
    function execute(bytes32 proposalhash, bytes memory proposal, uint32 blocknumber) public {
        require(keccak256(proposal) == proposalhash, "hash not matched");
        bool[2] memory status = collectExecuteHashStatus[proposalhash];
        require(status[0] == true && status[1] == false, "status not matched");
        uint256 proposalId = collectExecuteData[proposalhash].proposalId;
        bytes memory executionPayload = collectExecuteData[proposalhash].executionPayload;
        Proposal memory _proposal = abi.decode(proposal, (Proposal));

        IExecutionStrategy(_proposal.executionStrategy).execute(
            collectExecuteData[proposalhash].proposalId,
            _proposal,
            votePower[proposalId][1],
            votePower[proposalId][0],
            votePower[proposalId][2],
            executionPayload,
            blocknumber
        );

        collectExecuteHashStatus[proposalhash] = [true, true];
        
        isExecuted[proposalId] = true;
    }
}
