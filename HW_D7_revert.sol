pragma solidity >=0.4.22 <0.6.0;

contract login {
    address public _ownerAddr;
    string public _name;
    
    constructor() public {
        _ownerAddr = msg.sender;
        _name = "";
    }
    
    function setNameRevert(string memory name) public  {
        _name = name;
        if (msg.sender != _ownerAddr)
            revert("Revert.");
    }
    
    function setNameRequire(string memory name) public  {
        _name = name;
        require(msg.sender == _ownerAddr, "Require.");
    }
    
    function setNameAssert(string memory name) public  {
        _name = name;
        assert(msg.sender == _ownerAddr);
    }
    
    function getName() public view returns (string memory) {
        return _name;
    }
}
