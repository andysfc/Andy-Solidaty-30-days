pragma solidity >=0.4.22 <0.6.0;

interface BankIntf {
    // TODO: define interface of Deposit(), Withdraw(), GetBalance()
    function Deposit() external payable returns (uint256 balance);
    function Withdraw(uint256 valueInWei) external returns (uint256 balance);
    function GetBalance() external view returns (uint256);
}

contract AbstractBank is BankIntf{
    mapping (address => uint256) _depositors;
    
    constructor() internal { }
    
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
    
    function GetBankBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract SimpleBank is AbstractBank {
    function Deposit() public payable returns (uint256 balance) {
        // TODO
        _Deposit(msg.value);
        return GetBalance();
    }
    
    function Withdraw(uint256 valueInWei) public returns (uint256 balance) {
        // TODO
        require(address(this).balance >= valueInWei);
        _Withdraw(valueInWei);
        msg.sender.transfer(valueInWei);
        return GetBalance();
    }
}

contract HimoBank is AbstractBank {
    // TODO: Charge 1% fee from value paid to Deposit() 
    //       Charge additional 1% fee of value to Withdraw()
    function Deposit() public payable returns (uint256 balance) {
        _Deposit(msg.value*99/100);
        return GetBalance();
    }
    
    function Withdraw(uint256 valueInWei) public returns (uint256 balance) {
        uint256 totalWithdraw = valueInWei * 101/100;
        require(address(this).balance >= valueInWei);
        _Withdraw(totalWithdraw);
        msg.sender.transfer(valueInWei);
        return GetBalance();
    }
}
