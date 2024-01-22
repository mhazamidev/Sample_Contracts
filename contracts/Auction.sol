// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Auction {
    address public beneficirary;
    address public owner;
    uint public auctionStartTime;
    uint public auctionEndTime;
    bool public edned;
    uint public heighestBid;
    address public heighestBider;

    struct Bid {
        address bider;
        uint bidPrice;
    }

    mapping(address => uint) pendingRefunds;

    Bid[] internal BidsArray; //for searching on pendingRefunds

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier notEnded() {
        require(
            block.timestamp >= auctionEndTime,
            "The auction is in life time";
        );
        _;
    }

     modifier isValidTime() {
        require(
            block.timestamp < auctionEndTime,
            "The auction is ended";
        );
        _;
    }

    modifier isHeighestBid(){
        require(msg.value>hieghestBid,"your bid is less than the Heighest Bid");
_       ;
    }

    function startAuction(
        address _beneficirary,
        uint uintPrice,
        uint _deadlineDurationBySecond
    ) public onlyOwner {
        require(auctionStartTime == 0, "The Auction has been already started");
        beneficirary = _beneficirary;
        auctionStartTime = block.timestamp;
        heighestBid = uintPrice;
        heighestBider = _beneficirary;
        auctionEndTime = block.timestamp + _deadlineDurationBySecond;
    }

    function bid() public payable isValidTime isHeighestBid{
        if(hirghstBider!=beneficirary){
        hieghestBid=msg.value;
        hirghstBider=msg.sender;
        pendingRefunds[msg.sender]=msg.value;
        Bid bid={msg.sender,msg.value};
        BidsArray.push(bid);
        }   
    }

    function refund() public returns (bool) {
       uint amount= pendingRefunds[msg.sender];
       require(amount>0,"you are refunded already");

       if(paySend(msg.sender,amount)){
        pendingRefunds[msg.sender]=0;
       }
       return false;
    }

    function payToBeneficirary() public onlyOwner returns (bool) {

    }

    function endAuction() public onlyOwner notEnded {
       edned = true;
    }

    function getBids() public view returns (Bid[] memory) {}

    function getWinner() public view returns (address, uint) {
        return (heighestBider,heighestBid);
    }

    function paySend(address to, uint amount) private returns (bool) {
        require(address(this).balance >= amount, "Not enough balance!");

        bool result = payable(to).send(amount);

        require(result, "failure in pament via send!");
        return result;
    }
}
