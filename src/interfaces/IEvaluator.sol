// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IEvaluator {
    function submitExercise(address _exerciseAddress) external;
    function ex1_claimedPoints() external;
    function ex2_claimedFromContract() external;
    function ex3_withdrawFromContract() external;
    function ex4_approvedExerciseSolution() external;
    function ex5_revokedExerciseSolution() external;
    function ex6_depositTokens() external;
    function ex7_createERC20() external;
    function ex8_depositAndMint() external;
    function ex9_withdrawAndBurn() external;
}