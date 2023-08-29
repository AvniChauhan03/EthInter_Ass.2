// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Assessment {
    address public owner;
    uint256 public balance;

    event Deposit(address indexed account, uint256 amount);
    event Withdraw(address indexed account, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(uint256 initBalance) payable {
        owner = msg.sender;
        balance = initBalance;
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }

    function deposit() public payable {
        uint256 _amount = msg.value;
        uint256 _previousBalance = balance;

        balance += _amount;

        assert(balance == _previousBalance + _amount);

        emit Deposit(msg.sender, _amount);
    }

    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public onlyOwner {
        uint256 _previousBalance = balance;

        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        balance -= _withdrawAmount;

        assert(balance == (_previousBalance - _withdrawAmount));

        payable(msg.sender).transfer(_withdrawAmount);

        emit Withdraw(msg.sender, _withdrawAmount);
    }

    fallback() external payable {
        deposit();
    }

    receive() external payable {
        deposit();
    }
}
