pragma solidity ^0.6.0;

import 'HW_D17_set.sol';

contract Main {
    using Set for Set.Data;
    using Set for Set.IterState;
    
    Set.Data set;
    Set.IterState iter;
    
    function insert(int key) public returns (bool) {
        return set.Insert(key);
    }
    
    function remove(int key) public returns (bool) {
        return set.Remove(key);
    }
    
    function contain(int key) public view returns (bool) {
        return set.Contain(key);
    }
    
    event LogKey(int key);
    function iterate() public {
        //Set.IterState memory iter;
    
        iter.IterBegin();
        bool exist;
        int key;
        (exist, key) = iter.IterNext(set);
        while (exist) {
            emit LogKey(key);
            (exist, key) = iter.IterNext(set);
        }
    }
    
}
