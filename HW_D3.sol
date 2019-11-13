pragma solidity >=0.4.22 <0.6.0;

contract Donation {
  event LogDonate(
    address streamer, address donor, string nickname, uint value, string message);
    
  function donate(address payable _streamer, string memory _nickname, string memory _message) public payable returns (string memory) {
    _streamer.transfer(msg.value);
    emit LogDonate(_streamer, msg.sender, _nickname, msg.value, _message);
    return 'Thanks for Donation.';
  }
}
