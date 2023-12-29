// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract MappingAndStruct {
    //پیشنهاد دهنده
    struct Bid {
        address bider;
        uint bidPrice;
    }

    //array of struct
    Bid[] public bidsAray;

    function setBidArray(address bider, uint bidPrice) public {
        Bid memory item = Bid(bider, bidPrice);
        bidsAray.push(item);
    }

    function getBidArray(uint index) public view returns (address, uint) {
        return (bidsAray[index].bider, bidsAray[index].bidPrice);
    }

    function getBidArray(address bider) public view returns (uint bid) {
        for (uint256 i = 0; i < bidsAray.length; i++) {
            if (bidsAray[i].bider == bider) {
                bid = bidsAray[i].bidPrice;
            }
        }
    }

    //mapping of struct
    mapping(address => uint) public bidsMap;

    function setBidMap(address bider, uint bidPrice) public {
        bidsMap[bider] = bidPrice;
    }

    function getBidMap(address bider) public view returns (uint) {
        return bidsMap[bider];
    }

    function updateBidMap(address bider, uint newPrice) public returns (uint) {
        bidsMap[bider] = newPrice;
        return bidsMap[bider];
    }

    function deleteBidMap(address bider) public {
        delete bidsMap[bider];
    }

    //nested mapping
    mapping(address => mapping(address => uint)) public approvals;

    function getApprovalBid(
        address owner,
        address spender
    ) public view returns (uint) {
        return approvals[owner][spender];
    }

    function setApprovalBid(
        address owner,
        address spender,
        uint amount
    ) public {
        approvals[owner][spender] = amount;
    }
}
