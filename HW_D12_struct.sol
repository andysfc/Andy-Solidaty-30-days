pragma solidity >=0.4.22 <0.6.0;

contract WHO {
    struct Status {
        uint    nPositive;
        uint    nDeath;
        bool    registered;
    }
    
    mapping (string => Status) countryStatus;
    address owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier onwerCheck() {
        require(msg.sender == owner, "Permission Denied");
        _;
    }
    modifier registeredCountry(string memory country) {
        require(countryStatus[country].registered, "No data");
        _;
    }
    
    function addStatus(string memory country, uint nPositive, uint nDeath) public onwerCheck  {
        if (! countryStatus[country].registered ) {
            // TypeError: Wrong argument count for struct constructor: 2 arguments given but expected 4.
            countryStatus[country] = Status({nPositive:0, nDeath:0, registered:true});
        }
        countryStatus[country].nPositive += nPositive;
        countryStatus[country].nDeath += nDeath;
    }

    function reportStatus(string memory country) public view registeredCountry(country) returns (string memory, uint, uint) {
        return (country, countryStatus[country].nPositive, countryStatus[country].nDeath);
    }
}
