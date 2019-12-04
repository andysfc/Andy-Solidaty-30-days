pragma solidity >=0.4.22 <0.6.0;

contract login {
    address _name;
    string _password;
    
    constructor() public {
        _name = msg.sender;
        _password = "";
    }
    
    modifier onwerCheck() {
        // require(msg.sender == _name, "Permission Denied");
        // _;
        if (msg.sender == _name) {
            _;
        }
        else {
            return;
        }
    }
    
    function setPassword(string memory password) public onwerCheck {
        _password = password;
    }
    
    function getPassword() public view returns (string memory) {
        return _password;
    }
}
