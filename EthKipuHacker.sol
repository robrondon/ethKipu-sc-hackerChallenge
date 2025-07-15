// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IGrader5 {
    function retrieve() external payable;

    function gradeMe(string calldata name) external;
}

contract EthKipuHacker {
    IGrader5 private immutable i_grader;
    address private immutable i_owner;

    constructor(address graderAddress) {
        i_grader = IGrader5(graderAddress);
        i_owner = msg.sender;
    }
}
