// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

enum ProductStatus {
    Undefined,
    Pending,
    Validated,
    Refused
}

struct User {
    uint256 id;
}

struct Product {
    string serialNumber;
    string name;
    string description;
    string picture;
    uint256 price;
    uint256 registrationDate;
    address manufacter;
    address owner;
    ProductStatus status;
    address[] owners;
}

struct Report {
    string serialNumber;
    address reporter;
    string details;
    uint256 reportDate;
}
