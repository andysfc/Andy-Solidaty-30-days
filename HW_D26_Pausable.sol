pragma solidity ^0.6.0;

// ERC20 Mintable

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol';
import "HW_D20.sol";

// ERC20 Optional
//  name
//  decimals
//  symbol
//
// https://etherscan.io/token/0xB8c77482e45F1F44dE1745F52C74426C631bDD52#readContract

contract HET is NewToken {
    string public constant name = "Himo Evil Token";
    uint8 constant decimals = 18;
    string public constant symbol = "HET";
    
    address _owner;
    mapping (address => uint256) _minterQuota;
    mapping (address => uint256) _burnerQuota;
    uint256 public _totalMintable = 0;
    uint256 public _totalBurnable = 0;
    bool private _isPaused = false;
    
    constructor() public {
        _owner = msg.sender;
    }
    modifier onlyOwner() {
        require(_owner == msg.sender, "Permission denied.");
        _;
    }
    modifier onlyMinter() {
        require(_minterQuota[msg.sender] > 0, "Permission denied.");
        _;        
    }
    modifier onlyBurner() {
        require(_burnerQuota[msg.sender] > 0, "Permission denied.");
        _;
    }
    
    modifier onlyPaused() {
        require(_isPaused, "Contract is not paused.");
        _;
    }
    
    modifier onlyNotPaused() {
        require(!_isPaused, "Contract is paused.");
        _;
    }
    
    
    function pause() public onlyOwner onlyNotPaused returns (bool) {
        _isPaused = true;
    }
    function unpause() public onlyOwner onlyPaused returns (bool) {
        _isPaused = false;
    }
    
    // ERC20 Optional
    
    // Use SafeMath to implement ERC20
    //function totalSupply() external view returns (uint256);
    //function balanceOf(address tokenOwner) external view returns (uint256 balance);
    //function transfer(address to, uint256 tokens) external returns (bool success);
    //function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
    //function approve(address spender, uint256 tokens) external returns (bool success);
    //function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
    
    // Implement mint
    function mint(address account, uint256 tokens) public onlyMinter onlyNotPaused returns (bool) {
        require(account != address(0) && account != address(this), "Invalid address");
        require(_minterQuota[msg.sender] >= tokens, "Insufficient approvals to mint.");
        
        _totalSupply = _totalSupply.add(tokens);
        _usedSupply = _usedSupply.add(tokens);
        _balance[account] = _balance[account].add(tokens);
        _minterQuota[msg.sender] = _minterQuota[msg.sender].sub(tokens);
        _totalMintable = _totalMintable.sub(tokens);
        
        emit Transfer(address(0), account, tokens);
    }
    
    function approveMinter(address minter, uint256 tokens) public onlyOwner onlyNotPaused returns (bool) {
        _totalMintable = _totalMintable.add(tokens);
        _minterQuota[minter] = _minterQuota[minter].add(tokens);
        return true;
    }

    function mintableOf(address minter) external view returns (uint256 mintable)
    {
        return _minterQuota[minter];
    }

    // Implement burn
    function burn(address account, uint256 tokens) public onlyBurner onlyNotPaused returns (bool) {
        require(account != address(0) && account != address(this), "Invalid address");
        require(_burnerQuota[msg.sender] >= tokens, "Insufficient approvals to burn");
        require(_balance[account] >= tokens, "Insufficient balance to burn");
        
        _totalSupply = _totalSupply.sub(tokens);
        _usedSupply = _usedSupply.sub(tokens);
        _balance[account] = _balance[account].sub(tokens);
        _burnerQuota[msg.sender] = _burnerQuota[msg.sender].sub(tokens);
        _totalBurnable = _totalBurnable.sub(tokens);
        
        emit Transfer(account, address(0), tokens);
    }
    
    function approveBurner(address burner, uint256 tokens) public onlyOwner onlyNotPaused returns (bool) {
        uint256 newBurnable = _totalBurnable.add(tokens);
        require(_totalSupply >= newBurnable, "Insufficient supply to burn.");
        _totalBurnable = newBurnable;
        _burnerQuota[burner] = _burnerQuota[burner].add(tokens);
        return true;
    }
    
    function burnableOf(address burner) external view returns (uint256 burnable)
    {
        return _burnerQuota[burner];
    }
}
