// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;


contract StateTransaction {


    //Epoc Time Format
    uint starteTime;
    uint currentTime;
    State state;

    enum State {
        Register,
        Vote,
        Count
    }

    function start() public {
        starteTime = block.timestamp;
        currentTime = block.timestamp;
        state = State.Register;
    }

    function changeState(uint input) public {
        if (input == 0) state = State.Register;
        else if (input == 1) state = State.Vote;
        else if (input == 2) state = State.Count;
    }

    function updateState() public {
        currentTime = block.timestamp;

        if (currentTime <= (starteTime + 10 seconds)) state = State.Register;
        else if (currentTime <= (starteTime + 20 seconds)) state = State.Vote;
        else state = State.Count;
    }

    function getAllStates() public pure returns (string memory) {
        string memory result = "'Register':'0','Vote':'1','Count':'2'";
        return result;
    }

    function getCurrentState() public view returns (string memory) {
        if (state == State.Register) return "'Register':'0'";
        else if (state == State.Vote) return "'Vote':'1'";
        else return "'Count':'2'";
    }

    function getStartTime() public view returns (uint) {
        return starteTime;
    }

    function getCurrentTime() public view returns (uint) {
        return currentTime;
    }

    function getLastUpdateTime() public view returns (uint) {
        return currentTime;
    }
}
