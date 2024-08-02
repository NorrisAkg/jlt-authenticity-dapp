// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./../abstract/Types.sol";

contract UserManagement {
    error userAlreadyExists();
    error invalidUserRole();
    error onlyAdmin();

    event NewRegistrationEvent(address _address,UserRole _role);
    uint256 s_peopleIdCounter = 0;
    address s_admin;

    mapping(address => User) s_users;

    constructor() {
        s_admin = msg.sender;
    }

    function addValidator(address _address)
        public
    {
        if(msg.sender != s_admin) {
            revert onlyAdmin();
        }
        if (s_users[_address].role != UserRole.Undefined) {
            revert userAlreadyExists();
        }

        s_users[_address] = User(s_peopleIdCounter, UserRole.Validator);
        s_peopleIdCounter++;
        emit NewRegistrationEvent(_address, UserRole.Validator);
    }

    function createUser(UserRole _role)
        public
        checkRoleExists(_role)
    {
        if (s_users[msg.sender].role != UserRole.Undefined) {
            revert userAlreadyExists();
        }

        if (_role == UserRole.Undefined) {
            revert invalidUserRole();
        }

        s_users[msg.sender] = User(s_peopleIdCounter, _role);
        s_peopleIdCounter++;
        emit NewRegistrationEvent(msg.sender, _role);
    }

    function getUser(address _address)
        public
        view
        returns ( UserRole)
    {

        require(
            s_users[_address].role != UserRole.Undefined,
            "User does not exists"
        );

        User storage user = s_users[_address];

        return user.role;
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
