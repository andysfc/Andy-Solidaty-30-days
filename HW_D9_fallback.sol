pragma solidity >=0.4.22 <0.6.0;

contract login {
    address _name;

    constructor() public {
        _name = msg.sender;
    }
    
    event LogBalance(uint balance);
    
    modifier ownerCheck() {
        emit LogBalance(address(this).balance);
        if (msg.sender == _name) {
            _;
        }
        else {
            return;
        }
    }

    function () external payable ownerCheck {
        msg.sender.transfer(address(this).balance);
        
    }
}
