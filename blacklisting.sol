

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract BlackList{

    address public admin;
    mapping(address=>bool) internal blackListed;

    modifier onlyAdmin(){
        require(msg.sender==admin,"You can do this");
        _;
    }

    constructor(address too){
        admin = too;
    }

    function addBlackList(address user) public onlyAdmin{
        blackListed[user] = true;
    }

    function removeBlackList(address user) public {
        blackListed[user] = false;
    }

    function isBlackList(address user) public view returns(bool){

       return blackListed[user];
    }
}
