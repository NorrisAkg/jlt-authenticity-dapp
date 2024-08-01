// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./../abstract/Types.sol";

interface IUserManagement {
    function createUser(
        address _address,
        string _username,
        UserRole _role
    ) external;

    function getUser(address _address) external view returns (string, UserRole);
}
