// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

library LFigli {

    function isContained(uint256 z, uint256 [] memory y) pure internal returns (bool) {
        
        for(uint x = 0 ; x < y.length; x++){
            if(y[x] == z){
                return true; 
            }
        }
        return false; 
    }

    function remove(uint256 a, uint256[] memory b) pure internal returns (uint256 [] memory){
        uint256 [] memory c = new uint256[](b.length-1);
        uint256 y = 0; 
        for(uint256 x = 0; x < b.length; x++) {
            uint256 d = b[x];
            if( a != d){    
                if(y == c.length){ // i.e. element not found
                    return b; 
                } 
                c[y] = d; 
                y++;
            }
        }
        return c; 
    }

}