// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract GlobalVariables {
    constructor() {}

    function getBlockInfo()
        public
        view
        returns (uint, uint, uint, address payable, uint, bytes32)
    {
        return (
            block.number, //شماره آخرین بلاک ماین شده در شبکه
            block.timestamp, //تایم ماین شدن آخرین بلاک شبکه
            block.difficulty, //میزان سختی ماین شدن آخرین بلاک شبکه
            block.coinbase, //آدرس ماین بلاک
            block.chainid, //شناسه زنجیره ای که بلاک درآن ماین و درج شده
            blockhash(block.number) //هش بلاک
        );
    }

    function getGasInfo() public view returns (uint, uint, uint) {
        uint gas = gasleft(); // remainedGas ~ gatleft = GasLimit - GasUsed

        uint gasLimit = block.gaslimit; // محدودیت گس بلاک

        uint basefee = block.basefee; // قیمت پایه هر گس در بلاک

        return (gasLimit, basefee, gas);
    }

    function getMsgInfo()
        public
        payable
        returns (address, uint, bytes calldata, bytes4)
    {
        address caller = msg.sender;

        uint sentValue = msg.value;

        bytes calldata funcMsgData = msg.data;

        bytes4 functionID = msg.sig;

        return (caller, sentValue, funcMsgData, functionID);
    }

    function getContractAddress() public view returns (address, uint) {
        address contractAddress = address(this);

        uint contractBalance = address(this).balance;

        return (contractAddress, contractBalance);
    }

    function encode(uint num) public pure returns (bytes memory) {
        //decimal/base10 : 0,1,2,3,...
        //binary/base2: 0,1
        //Hex/base16 : 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F

        return abi.encodePacked(num);
    }

    function CompareStrings(
        string memory s1,
        string memory s2
    ) public pure returns (bool) {
        bytes memory enc1 = abi.encodePacked(s1);
        bytes memory enc2 = abi.encodePacked(s2);

        bytes32 hash1 = keccak256(enc1);
        bytes32 hash2 = keccak256(enc2);

        bool result = hash1 == hash2;

        return result;
    }

    function getHash(bytes memory input) public pure returns (bytes32) {
        return keccak256(input);
    }

    function getRandom(uint max) public view returns (uint) {
        bytes memory enc = abi.encodePacked(block.difficulty, block.timestamp);

        bytes32 hash = keccak256(enc);

        uint rnadom = uint(hash);
        return rnadom % max;
    }
}
