// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./../abstract/Types.sol";

interface IUserManagement {
    function createUser(
        address _address,
        string memory _username,
        UserRole _role
    ) external;

    function getUser(address _address) external view returns (UserRole);
}
