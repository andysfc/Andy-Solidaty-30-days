pragma solidity >=0.4.22 <0.6.0;

contract FallbackExample {
    event LogFallback(string msg);
    event LogBalance(uint balance);

    function() external {
        emit LogFallback("Fallback");
        emit LogBalance(address(this).balance);
    }
}
