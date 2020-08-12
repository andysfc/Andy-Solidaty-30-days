pragma solidity ^0.6.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol';

contract MiningShare {
    using SafeMath for uint;
    
    // 召集人
    address private owner = address(0);
    
    // 投資者:
    // 1. 投資金額
    mapping (address => uint) investor;
    // 2. 提領金額
    mapping (address => uint) withdrawn;
    
    
    // 紀錄參數:
    // 1. 總投資金額
    uint private totalNTD = 0;
    // 2. 總提領金額
    uint private totalWithdraw = 0;
    // 3. 設定結束募資時間
    uint private closeBlock = 0;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    modifier onlyShareholders() {
        require(investor[msg.sender] > 0, "Not investor");
        _;
    }
    modifier beforeCloseBlock() {
        require(block.number <= closeBlock, "Capital closed.");
        _;
    }
    modifier afterCloseBlock() {
        require(block.number > closeBlock, "Capital not closed.");
        _;
    }
    
    constructor() public {
        owner = msg.sender;
        closeBlock = block.number + 5;
    }
    // 召集人功能
    // 增資紀錄
    function CapitalIncrease(address account, uint NTD) public onlyOwner beforeCloseBlock {
        investor[account] = investor[account].add(NTD);
        totalNTD = totalNTD.add(NTD);
    }
    // 撤資紀錄
    function CapitalDecrease(address account, uint NTD) public onlyOwner beforeCloseBlock {
        require(investor[account] >= NTD, "Insufficient balance");
        require(totalNTD >= NTD, "Internal error");
        investor[account] = investor[account].sub(NTD);
        totalNTD = totalNTD.sub(NTD);
    }
    
    function AddGain() public payable onlyOwner afterCloseBlock {
    }
    
    // 投資者
    // 資金
    function MyTotalNTD() public view onlyShareholders returns (uint) {
        return investor[msg.sender];
    }
    // 分紅
    function MyTotalWithdraw() public view afterCloseBlock onlyShareholders returns (uint) {
        return withdrawn[msg.sender];
    }
    
    function TotalMined() public view afterCloseBlock returns (uint) {
        return address(this).balance.add(totalWithdraw);
    }
    
    function Withdraw() public afterCloseBlock onlyShareholders {
        uint totalGain = TotalMined().mul(investor[msg.sender]).div(totalNTD);
        uint avail = totalGain.sub(withdrawn[msg.sender]);
        require(avail <= address(this).balance, "Insufficient balance");
        msg.sender.transfer(avail);
        withdrawn[msg.sender] = totalGain;
        totalWithdraw = totalWithdraw.add(avail);
    }
    
    // for testing
    function block_num() public view onlyOwner returns (uint) {
        return block.number;
    }
    function close_block() public view onlyOwner returns (uint) {
        return closeBlock;
    }
}
