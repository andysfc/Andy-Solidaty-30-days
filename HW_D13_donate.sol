pragma solidity >=0.4.22 <0.6.0;

contract Donation {
    struct DonorInfo {
        address [] donors;
        mapping(address=>uint256) value;
    }
    mapping(address=>DonorInfo) streamDonors;
    
    event LogDonation(address streamer, address donor, string nickName, string message, uint256 value);
    function donate(address payable streamer, string memory nickName, string memory message) public payable {
        require(msg.sender != streamer);
        require(msg.value > 0);

        streamer.transfer(msg.value);
        emit LogDonation(streamer, msg.sender, nickName, message, msg.value);
        
        address donor = msg.sender;
        if (streamDonors[streamer].value[donor] == 0) {
            streamDonors[streamer].donors.push(donor);
        }
        streamDonors[streamer].value[donor] += msg.value;
    }
    
    function getDonorList() view public returns (address [] memory) {
        address streamer = msg.sender;
        return streamDonors[streamer].donors;
    }

    event LogDonorInfo(address streamer, address donor, uint256 value);
    function listDonorInfo() public {
        address streamer = msg.sender;
        for (uint256 i=0; i < streamDonors[streamer].donors.length; i++) {
            address donor = streamDonors[streamer].donors[i];
            uint256 value = streamDonors[streamer].value[donor];
            emit LogDonorInfo(streamer, donor, value);
        }
    }
}
