// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract SimpleContract {
    address public creator;

    constructor(address _creator) payable {
        creator = _creator;
    }

    receive() external payable {}
}

contract Factory {
    SimpleContract[] public SimpleContractList;

    constructor() payable {}

    // Create a new contract with SimpleContract's code
    // Execute its constructor
    // send address of Factory as its constructor input parameter
    function create() public returns (SimpleContract newContract) {
        newContract = new SimpleContract(address(this));
        SimpleContractList.push(newContract);
        return newContract;
    }

    // send ether to a created contract
    function charge(address contractAddress, uint amount) public payable {
        (bool result, ) = contractAddress.call{value: amount}("");
        require(result, "charge failed");
    }

    /* 
        same as the previous version, but 
        charges the new contract by the current contract balance, 
        Instance of get value from the caller
        contract have to be charged already
    */
    function createAndCharge(uint amount) public {
        SimpleContract sc = new SimpleContract{value: amount}(address(this));
        SimpleContractList.push(sc);
    }

    function getInstanceInfo(
        uint index
    ) public view returns (address creator, address instance, uint balance) {
        SimpleContract ins = SimpleContractList[index];

        creator = ins.creator();
        instance = address(ins);
        balance = instance.balance;
    }
}
