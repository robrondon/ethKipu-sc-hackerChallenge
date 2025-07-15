// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IGrader5 {
    function retrieve() external payable;

    function gradeMe(string calldata name) external;
}

contract EthKipuHacker {}
