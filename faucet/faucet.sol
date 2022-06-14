pragma solidity ^0.8.14;

contract owned {
    address owner;

    constructor () {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }
}

contract mortal is owned {
    function destroy() public onlyOwner {
        selfdestruct(payable(owner));
    }
}

contract Faucet is mortal {
    event Withdrawal(address indexed to, uint amount); 
    event Deposit(address indexed from, uint amount);

    function withdraw(uint withdraw_amount) public {
        require(withdraw_amount < 0.1 ether, "Withdraw amount must be less than 0.1 eth");
        require(withdraw_amount <= address(this).balance, "Insufficient balance in faucet for withdrawal request");

        payable(msg.sender).transfer(withdraw_amount);
        emit Withdrawal(msg.sender, withdraw_amount);
    }

    fallback () external payable {}

    receive () external payable {
        emit Deposit(msg.sender, msg.value);
    }
    
}