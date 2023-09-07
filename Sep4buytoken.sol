// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./blacklisting.sol";

contract Token is ERC20, Ownable, BlackList{

    uint public tokenPrice;

   constructor() ERC20("MY_TOKEN", "T_K") BlackList(msg.sender){
      _mint(msg.sender, 10000 * (10**18));
    
   }
   
   function addMoreTokens(uint _numberOfTokens) public onlyOwner{
      _mint(msg.sender, _numberOfTokens * (10**18));
   }

    function burnFromOwner(uint256 _numberOfTokens) public onlyOwner {
      _burn(owner(), _numberOfTokens);
   }

    function burnFromUser(address burnTokenFrom, uint256 _numberOfToken) public onlyOwner {
      _burn(burnTokenFrom, _numberOfToken);
   }

   function buyToken(uint noOfToken) public payable {

       require(!isBlackList(msg.sender), "You are blacklisted");
         
        uint256 requiredAmount = noOfToken * tokenPrice;
        require(msg.value == requiredAmount, "Amount is less");

        _transfer(admin, msg.sender, noOfToken);
    }
    
     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        require(isBlackList(from) && !isBlackList(to), "You are blacklisted");
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }


    function transfer(address to, uint256 amount) public virtual override returns (bool) {

        require(!isBlackList(msg.sender) && !isBlackList(to) , "You are blacklisted");
        address owne = _msgSender();
        _transfer(owne, to, amount);
        return true;
    }

   
    function withdrawAmount() public onlyOwner {
        
        payable(admin).transfer(address(this).balance);
    }
    
}

