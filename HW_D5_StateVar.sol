pragma solidity >=0.4.22 <0.6.0;

contract State {
    string  _name;
    address _owner;
    
    constructor() public {
        _name = "???";
        _owner= msg.sender;
    }
    
    function setName(string memory name) public returns (string memory) {
        if (msg.sender == _owner) {
            _name = name;
        }else {
            revert("Permission Denied.");
        }
        return _name;
    }
    function getName() public view returns (string memory) {
        return _name;
    }
}
