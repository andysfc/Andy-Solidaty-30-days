pragma solidity >=0.4.22 <0.6.0;

contract login {
    address _name;
    string _password;
    
    event LogCaller(address name);
    event LogPwd(address name, string password);
    event LogPwdIdx(address indexed name, string indexed password);
    
    constructor() public {
        _name = msg.sender;
        _password = "";
    }
    
    modifier onwerCheck() {
        emit LogCaller(msg.sender);
        require(msg.sender == _name, "Permission Denied");
        _;
        
    }
    
    function setPassword(string memory password) public onwerCheck {
        _password = password;
        emit LogPwd(_name, _password);
        emit LogPwdIdx(_name, _password);
    }
    
    function getPassword() public view returns (string memory) {
        return _password;
    }
}
