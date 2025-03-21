// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ExerciseSolutionToken is ERC20, AccessControl {
    // Create a minter role
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() ERC20("Exercise Solution Token", "EST") {
        // Grant the contract deployer the admin role: it can grant and revoke roles
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // Function to mint new tokens (only callable by addresses with MINTER_ROLE)
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) returns (bool) {
        _mint(to, amount);
        return true;
    }

    // Function to burn tokens (only callable by addresses with MINTER_ROLE or token owner)
    function burn(address from, uint256 amount) public returns (bool) {
        require(
            hasRole(MINTER_ROLE, msg.sender) || from == msg.sender,
            "Must have minter role or be token owner"
        );
        _burn(from, amount);
        return true;
    }

    // Function to check if an address is a minter
    function isMinter(address account) public view returns (bool) {
        return hasRole(MINTER_ROLE, account);
    }
}