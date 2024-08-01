// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./../abstract/Types.sol";

contract UserManagement {
    constructor() {}

    uint peopleIdCounter = 0;

    mapping(address => User) users;

    event NewRegistrationEvent(string _username, UserRole _role);

    function createUser(
        string memory _username,
        UserRole _role
    ) public checkRoleExists(_role) {
        require(
            uint8(users[msg.sender].role) == uint8(UserRole.Undefined),
            "User with this address already exists"
        );
        require(uint8(_role) != uint8(UserRole.Undefined), "Invalid role");

        users[msg.sender] = User(peopleIdCounter, _username, _role);
        peopleIdCounter++;
        emit NewRegistrationEvent(_username, _role);
    }

    function getUser(
        address _address
    ) public view returns (string memory, UserRole) {
        require(
            uint8(users[_address].role) != uint8(UserRole.Undefined),
            "User does not exists"
        );

        User storage user = users[_address];

        return (user.username, user.role);
    }

    function updateUser(
        string memory _username,
        UserRole _role
    ) public checkRoleExists(_role) {
        //TODO To im plement later
    }

    modifier checkRoleExists(UserRole _role) {
        require(
            uint8(_role) >= uint8(UserRole.Maker) &&
                uint8(_role) <= uint8(UserRole.Validator),
            "Invalid role"
        );
        _;
    }
}
