pragma solidity ^0.6.0;

import "HW_D20_IECR20.sol";
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol';

contract NewToken is IERC20 {
    using SafeMath for uint256;
    
    uint256 _totalSupply;
    uint256 _usedSupply;
    mapping (address => uint256) _balance;
    mapping (address => mapping (address => uint256)) _allowance;
    

    constructor() public
    {
        _usedSupply = 0;
        _totalSupply = 50000;
    }

    function totalSupply() external view override returns (uint256)
    {
        return _totalSupply;
    }
    
    function balanceOf(address tokenOwner) external view override returns (uint256 balance)
    {
        return _balance[tokenOwner];
    }
    
    function buyTokens(uint256 tokens) external returns (bool success)
    {   
        uint256 availSupply = _totalSupply.sub(_usedSupply);
        if (availSupply < tokens)
            return false;
        _totalSupply = _totalSupply.sub(tokens);
        _balance[msg.sender] = _balance[msg.sender].add(tokens);
    }

    function transfer(address to, uint256 tokens) external override returns (bool success)
    {   emit Transfer(msg.sender, to, tokens);
        if (_balance[msg.sender] < tokens)
            return false;
        _balance[msg.sender] = _balance[msg.sender].sub(tokens);
        _balance[to] = _balance[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    
    function allowance(address tokenOwner, address spender) external view override returns (uint256 remaining)
    {
        return _allowance[tokenOwner][spender];
    }
    
    function approve(address spender, uint256 tokens) external override returns (bool success)
    {
        if (_balance[msg.sender] < tokens) 
            return false;
        uint256 allow = _allowance[msg.sender][spender];
        _allowance[msg.sender][spender] = allow.add(tokens);
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 tokens) external override returns (bool success)
    {
        uint256 allow = _allowance[from][msg.sender];
        if (allow < tokens)
            return false;
        if (_balance[from] < tokens)
            return false;
        _balance[from] = _balance[from].sub(tokens);
        _balance[to] = _balance[to].add(tokens);
        _allowance[from][msg.sender] = allow.sub(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
    
}
