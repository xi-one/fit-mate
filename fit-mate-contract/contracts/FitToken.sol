pragma solidity ^0.8.4;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract FitToken is ERC20, Ownable {
    constructor() ERC20("Fitmate",  "fit") {
        
    }

    function mint(address to, uint256 amount) public onlyOwner{
        _mint(to, amount);
    }
}