// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./../abstract/Types.sol";

interface IProductRegistrationContract {
    function addProduct(
        string memory _designation,
        uint256 _value,
        string memory _picture
    ) external;

    function showProductInfos(
        uint8 _id
    )
        external
        view
        returns (
            uint8,
            string memory,
            uint256,
            string memory,
            address,
            ProductStatus,
            address[] memory
        );

    function updateProduct(
        uint8 _id,
        string memory _designation,
        uint256 _value,
        string memory _picture
    ) external;

    function approveOrRejectProduct(
        uint8 _productId,
        ProductStatus _status
    ) external;

    function transferProduct(uint8 _productId, address _newOwner) external;
}
