pragma solidity >=0.4.22 <0.6.0;

contract Bank {
    mapping (address => uint256) _depositors;
    constructor() internal {
    }
    
    function Deposit(uint256 count) public {
        _Deposit(count);
    }
    
    function Withdraw(uint256 count) public {
        _Withdraw(count);
    }
    
    function _Deposit(uint256 count) internal {
        _depositors[msg.sender] += count;
    }
    
    function _Withdraw(uint256 count) internal {
        require(count <= _depositors[msg.sender], "Insufficient balance.");
        _depositors[msg.sender] -= count;
    }
    
    function GetBalance() public view returns (uint256) {
        return _depositors[msg.sender];
    }
}

contract SimpleBank is Bank {
}

contract HimoBank is Bank {
    function Deposit(uint256 count) public {
        _Deposit(count*11/10);
    }
    
    function Withdraw(uint256 count) public {
        _Withdraw(count+10);
    }
}
