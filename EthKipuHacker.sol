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

    function hack() external payable {
        require(msg.sender == i_owner, "You're not the owner");
        require(msg.value > 3, "Must send more than 4 wei");

        i_grader.retrieve{value: msg.value}();
    }

    function doGradeMe(string calldata name) external {
        require(msg.sender == i_owner, "You're not the owner");
        i_grader.gradeMe(name);
    }
}
