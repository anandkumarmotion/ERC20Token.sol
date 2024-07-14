// Your task is to create a ERC20 token and deploy it on the Avalanche network for Degen Gaming. The smart contract should have the following functionality:

// Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
// Transferring tokens: Players should be able to transfer their tokens to others.
// Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
// Checking token balance: Players should be able to check their token balance at any time.
// Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    struct PlayerItems {
        uint tshirt;
        uint knife;
        uint bat;
        uint gun;
    }

    mapping(address => PlayerItems) public playerItems;

    // Numerical identifiers for items
    uint constant TSHIRT = 1;
    uint constant KNIFE = 2;
    uint constant BAT = 3;
    uint constant GUN = 4;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {

    function mint(address _to, uint256 _amount) external onlyOwner {
        _mint(_to, _amount);
    }

    function transferTokens(address _to, uint256 _amount) public {
        require(_amount <= balanceOf(msg.sender), "Low degen");
        _transfer(msg.sender, _to, _amount);
    }

    function redeemItem(uint _itemId, uint256 _price) public {
        require(_itemId >= TSHIRT && _itemId <= GUN, "Invalid item ID");
        require(balanceOf(msg.sender) >= _price, "Insufficient balance");

        if (_itemId == TSHIRT) {
            playerItems[msg.sender].tshirt += 1;
        } else if (_itemId == KNIFE) {
            playerItems[msg.sender].knife += 1;
        } else if (_itemId == BAT) {
            playerItems[msg.sender].bat += 1;
        } else if (_itemId ==GUN) {
            playerItems[msg.sender].gun += 1;
        } else {
            revert("Invalid item ID");
        }

        _burn(msg.sender, _price);
    }

    function burn(address _of, uint256 _amount) public {
        _burn(_of, _amount);
    }

    function checkBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }
}
