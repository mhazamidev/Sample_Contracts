// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Awake {
    uint sahre;
    uint awakeCount;
    uint memberCount;
    address public owner;
    uint public immutable tourCost;

    struct Member {
        bool isOwner;
        bool isAwake;
        bool isCancled;
        bool isPaid;
        bool isMwmber;
    }

    mapping(address => Member) memberList;

    constructor(uint cost) {
        owner = msg.sender;
        tourCost = cost;
    }

    function register() public payable {
        require(
            msg.value == tourCost,
            "your sent value is less than tour cost!"
        );

        require(!memberList[msg.sender].isMwmber, "Already registered!");

        memberList[msg.sender].isMwmber = true;
        memberCount++;
    }

    //قطعی کردن ثبت نام
    function awake() public {
        require(
            memberList[msg.sender].isMwmber,
            "you have not registered yet!"
        );
        memberList[msg.sender].isAwake = true;

        if (memberList[msg.sender].isCancled) {
            memberList[msg.sender].isCancled = false;
        }
        awakeCount++;
    }

    function cancle() public {
        require(
            memberList[msg.sender].isMwmber,
            "you have not registered yet!"
        );

        if (memberList[msg.sender].isAwake) {
            memberList[msg.sender].isAwake = false;
            awakeCount--;
        }
        memberList[msg.sender].isCancled = true;

        require(!memberList[msg.sender].isPaid, "you are already paid!");

        if (paySend(msg.sender, tourCost)) {
            memberList[msg.sender].isPaid = true;
        }
    }

    function payShare(address to) public {
        require(memberList[msg.sender].isMwmber, "you are not member");
        require(!memberList[msg.sender].isCancled, "you have canceled before");
        require(!memberList[msg.sender].isPaid, "you are already paid");

        if (sahre == 0) {
            sahre = getContractBalance() / awakeCount;
        }

        if (paySend(to, sahre)) {
            memberList[to].isPaid = true;
        }
    }

    function paySend(address to, uint amount) public returns (bool) {
        require(address(this).balance >= amount, "Not enough balance!");

        bool result = payable(to).send(amount);

        require(result, "failure in pament via send!");
        return result;
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance / 10 ** 18;
    }

    function getOwnerBalance() public view returns (uint) {
        return owner.balance / 10 ** 18;
    }

    function getAccountBalance(address adr) public view returns (uint) {
        return adr.balance / 10 ** 18;
    }
}
