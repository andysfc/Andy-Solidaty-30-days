pragma solidity ^0.5.0;

contract Address {
    function() external payable {}
    
    function Balance() public view returns(uint256) {
        return address(this).balance;
    }
    function TransferToMe(uint256 amount) public returns(bool) {
        msg.sender.transfer(amount * 1 ether);
        return true;
    }
    function SendToMeWoChk(uint256 amount) public returns(bool) {
        return msg.sender.send(amount * 1 ether);
        //msg.sender.send(amount * 1 ether);
        //return true;
    }
    function SendToMeWithChk(uint256 amount) public returns(bool) {
        require(msg.sender.send(amount * 1 ether), "Send fail");
        return true;
    }
    
}
