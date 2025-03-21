// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ExerciseSolution.sol";

contract DeployExerciseSolution is Script {
    // Adresse du token ClaimableToken sur Holesky
    address constant CLAIMABLE_TOKEN_HOLESKY = 0x25eAAb6F813137fC9BE0b4ada462aA535e2ea37a;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        ExerciseSolution exerciseSolution = new ExerciseSolution(CLAIMABLE_TOKEN_HOLESKY);
        
        vm.stopBroadcast();
        
        console.log("ExerciseSolution deployed at: ", address(exerciseSolution));
    }
}