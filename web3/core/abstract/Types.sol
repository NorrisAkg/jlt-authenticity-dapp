// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

enum UserRole {
    Maker,
    FinalUser,
    Validator
}

enum ProductStatus {
    Undefined
    Pending,
    Validated,
    Refused
}

struct User {
    uint id;
    string username;
    UserRole role;
}

struct Product {
    uint8 id;
    string designation;
    uint value;
    string picture;
    address owmer;
    ProductStatus status;
    address[] owners;
}
