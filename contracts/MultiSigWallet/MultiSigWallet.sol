// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract MultiSigWallet {
    /*

    --------------------
      Multi-Sig Wallet
    --------------------

    It's a wallet with more than one owner.

    The wallet owners can:
        1. 'submit' a transaction
        2. 'confirm' or 'revokeConfirmation' of pending transactions.
        3. anyone can 'execute' a transaction after enough owners has confirmed it

*/
    address[] public owners;
    uint public numberConfirmationRequired;
    mapping(address => bool) public isOwner;
    mapping(uint => mapping(address => bool)) public isConfirmed;
    Transaction[] transactions;
    uint _txIndex;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint numberOfConfirmation;
    }

    constructor(uint _numberConfirmationRequired, address[] memory _owners) {
        require(
            _numberConfirmationRequired > 0,
            "Number of confirmations are required"
        );
        require(_owners.length > 0, "Owners are requied");
        numberConfirmationRequired = _numberConfirmationRequired;
        for (uint i; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }
    }

    event Deposit(address indexed sender, uint amount, uint balance);
    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value,
        bytes data
    );
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeTransaction(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);

    modifier txExist(uint txIndex) {
        require(txIndex < transactions.length, "tx does not exist");
        _;
    }

    modifier notConfirmed(uint txIndex) {
        require(
            !isConfirmed[txIndex][msg.sender],
            "tx already comfired by you"
        );
        _;
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier notExecued(uint txIndex) {
        require(!transactions[txIndex].executed, "tx already executed");
        _;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submitTransaction(
        address _to,
        uint _value,
        bytes memory _data
    ) public onlyOwner {
        _txIndex = transactions.length;
        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                numberOfConfirmation: 0
            })
        );
        emit SubmitTransaction(msg.sender, _txIndex, _to, _value, _data);
    }

    function confirmTransaction()
        public
        onlyOwner
        txExist(_txIndex)
        notConfirmed(_txIndex)
        notExecued(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        transaction.numberOfConfirmation++;
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    function revokeConfirm()
        public
        onlyOwner
        txExist(_txIndex)
        notExecued(_txIndex)
    {
        require(isConfirmed[_txIndex][msg.sender], "tx not confirmed");
        Transaction storage transaction = transactions[_txIndex];
        transaction.numberOfConfirmation--;
        isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeTransaction(msg.sender, _txIndex);
    }

    function executeTransaction(
        uint txIndex
    ) public onlyOwner txExist(txIndex) notExecued(txIndex) returns (bool) {
        Transaction storage transaction = transactions[txIndex];
        require(
            transaction.numberOfConfirmation >= numberConfirmationRequired,
            "cannot execute"
        );
        transaction.executed = true;

        (bool result, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(result, "tx execution failed");

        emit ExecuteTransaction(msg.sender, txIndex);
        return result;
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTxCount() public view returns (uint) {
        return transactions.length;
    }

    function getTx(
        uint index
    )
        public
        view
        returns (
            address to,
            uint value,
            bytes memory data,
            bool executed,
            uint numberOfConfirmation
        )
    {
        Transaction storage transaction = transactions[index];
        to = transaction.to;
        value = transaction.value;
        data = transaction.data;
        executed = transaction.executed;
        numberOfConfirmation = transaction.numberOfConfirmation;
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
