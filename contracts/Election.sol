// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Election {
    address public manager;

    struct Candidate {
        uint id;
        string firstName;
        string lastName;
        string idNumber;
        uint voteCount;
    }

    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;

    event VotedEvent (
        uint indexed candidateId
    );

    event UserRegistered(
        address indexed userAddress
    );

    constructor() public {
        manager = msg.sender;
    }

    function addCandidate(string memory _firstName, string memory _lastName, string memory _idNumber) public onlyAdmin {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _firstName, _lastName, _idNumber, 0);
    }

    modifier onlyAdmin() {
        require(msg.sender == manager, "Only the manager can perform this action.");
        _;
    }

    function vote(uint _candidateId) public {
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit VotedEvent(_candidateId);
    }

    // Users registration
    struct User {
        string firstName;
        string lastName;
        string idNumber;
        string email;
        bytes32 passwordHash;
        address userAddress;
    }

    mapping(uint => User) public users;
    uint public usersCount;
    mapping(address => bool) public registeredUsers;

    function addUser(string memory _firstName, string memory _lastName, string memory _idNumber, string memory _email, string memory _password) public {
        require(!registeredUsers[msg.sender], "User already registered.");

        usersCount++;
        users[usersCount] = User(_firstName, _lastName, _idNumber, _email, keccak256(abi.encodePacked(_password)), msg.sender);
        registeredUsers[msg.sender] = true;

        emit UserRegistered(msg.sender);
    }
}
