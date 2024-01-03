// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Ballot {
    struct Proposal {
        string name;
        uint voteCount;
    }

    struct Voter {
        uint vote;
        uint8 weight;
        bool voted;
    }

    Proposal[] public proposalList;

    mapping(address => Voter) public voterList;

    address public chairPerson;
    uint public voterCount = 0;

    constructor(uint8 proposalCount) {
        chairPerson = msg.sender;
        voterList[chairPerson].weight = 2;
        for (uint i = 0; i < proposalCount; i++) {
            proposalList.push(Proposal("", 0));
        }
    }

    function register(address voterAddress) public {
        require(
            msg.sender == chairPerson,
            "Only chair person can call register"
        );

        require(
            voterAddress != chairPerson,
            "chair paeson has already registered"
        );

        voterList[voterAddress].weight = 1;
    }

    function vote(uint8 proposalId) public {




        voterList[msg.sender].vote = proposalId;
        voterList[msg.sender].voted = true;
        voterCount++;
    }

    function count() public view returns (uint) {
        return voterCount;
    }
}
