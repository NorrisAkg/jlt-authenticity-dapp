// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./../abstract/Types.sol";

interface IProductRegistrationContract {
    function addProduct(
        string memory _serialNumber,
        string memory _name,
        string memory _description,
        string memory _picture,
        uint256 _price
    ) external;

    function showProductInfos(
        string memory _serialNumber
    )
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            uint256,
            uint256,
            address,
            address,
            ProductStatus,
            address[] memory
        );

    function updateProduct(
        string memory _serialNumber,
        string memory _name,
        string memory _description,
        uint256 _price
    ) external;

    function approveOrRejectProduct(
        address _creator,
        string memory _serialNumber,
        ProductStatus _status
    ) external;

    function transferProduct(
        string memory _serialNumber,
        address _currentOwner,
        address _newOwner
    ) external;

    function reportProduct(
        string memory _serialNumber,
        string memory _details
    ) external;

    function getReports(
        string memory _serialNumber
    ) external view returns (Report[] memory);
}
