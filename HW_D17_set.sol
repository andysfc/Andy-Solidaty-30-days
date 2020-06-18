pragma solidity ^0.6.0;

library Set {
    struct _setState {
        bool isInserted;
        bool isExisted;
    }
    struct Data {
        mapping (int => _setState) data;
        int [] dataAry;
    }
    
    function Insert(Data storage d, int key) public returns (bool) {
        if (d.data[key].isExisted) return false;

        if (!d.data[key].isInserted) {
            d.dataAry.push(key);
            d.data[key].isInserted = true;
        }
        d.data[key].isExisted = true;
        return true;
    }
    
    function Remove(Data storage d, int key) public returns (bool) {
        if (!d.data[key].isExisted) return false; // key doesn't exist
        
        d.data[key].isExisted = false;
        return true;
    }
    
    function Contain(Data storage d, int key) public view returns (bool) {
        return d.data[key].isExisted;
    }
    
    struct IterState {
        uint256 idx;
    }
    
    function IterBegin(IterState storage s) public {
        s.idx = 0;
    }
    
    function IterNext(IterState storage s, Data storage d) public returns (bool, int) {
        for(; s.idx < d.dataAry.length; ++s.idx) {
            int key = d.dataAry[s.idx];
            if (d.data[key].isExisted) {
                ++s.idx;
                return (true, key);
            }
        }
        return (false, 0);
    }
    
}
