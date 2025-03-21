// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IClaimableToken.sol";
import "./interfaces/IExerciseSolution.sol";
import "./interfaces/IERC20Mintable.sol";
import "./ExerciseSolutionToken.sol";

contract ExerciseSolution is IExerciseSolution {
    IClaimableToken public claimableToken;
    IERC20Mintable public depositToken;
    
    // Mapping to track addresses that claimed tokens and their amounts
    mapping(address => uint256) public tokensInCustody;
    
    constructor(address _claimableTokenAddress) {
        claimableToken = IClaimableToken(_claimableTokenAddress);
        
        // Deploy the ExerciseSolutionToken
        ExerciseSolutionToken newToken = new ExerciseSolutionToken();
        depositToken = IERC20Mintable(address(newToken));
        
        // Grant this contract the minter role
        newToken.grantRole(newToken.MINTER_ROLE(), address(this));
    }
    
    // Ex2: Function to claim tokens on behalf of the caller
    function claimTokensOnBehalf() external override {
        uint256 initialBalance = claimableToken.balanceOf(address(this));
        claimableToken.claimTokens();
        uint256 finalBalance = claimableToken.balanceOf(address(this));
        uint256 claimedAmount = finalBalance - initialBalance;
        
        // Update the caller's custody balance
        tokensInCustody[msg.sender] += claimedAmount;
    }
    
    // Ex9: Updated withdraw function to use transferFrom, burn tokens, and return claimable tokens
    function withdrawTokens(uint256 amount) external override returns (uint256) {
        // Use transferFrom to get the ExerciseSolutionToken from the user
        bool success = depositToken.transferFrom(msg.sender, address(this), amount);
        require(success, "Token transfer failed");
        
        // Burn the ExerciseSolutionToken
        depositToken.burn(address(this), amount);
        
        // Transfer the original tokens back to the user
        claimableToken.transfer(msg.sender, amount);
        
        // Return the amount withdrawn
        return amount;
    }
    
    // Additional function to withdraw all tokens (not used by evaluator)
    function withdrawTokens() external {
        uint256 amount = tokensInCustody[msg.sender];
        require(amount > 0, "No tokens to withdraw");
        
        tokensInCustody[msg.sender] = 0;
        claimableToken.transfer(msg.sender, amount);
    }
    
    // Ex8: Function to deposit tokens and mint equivalent amount
    function depositTokens(uint256 amountToDeposit) external override returns (uint256) {
        // Verify transferFrom was successful
        bool success = claimableToken.transferFrom(msg.sender, address(this), amountToDeposit);
        require(success, "Token transfer failed");
        
        // Update the caller's custody balance
        tokensInCustody[msg.sender] += amountToDeposit;
        
        // Mint equivalent amount of deposit tokens and send to user
        depositToken.mint(msg.sender, amountToDeposit);
        
        return amountToDeposit;
    }
    
    // Ex7: Get the ERC20 deposit token address
    function getERC20DepositAddress() external view override returns (address) {
        return address(depositToken);
    }
}