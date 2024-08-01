// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./../abstract/Types.sol";
import "./../interfaces/IUserManagement.sol";

contract ProductRegistrationContract {
    IUserManagement userManagement;

    constructor(address userManagementContractAddress) {
        userManagement = IUserManagement(userManagementContractAddress);
    }

    uint8 productIdCounter = 0;

    // struct Product {
    //     uint8 id;
    //     string designation;
    //     uint value;
    //     string picture;
    //     address owmer;
    //     ProductStatus status;
    // }

    // Mappings
    mapping(uint8 => Product) products;

    // Events
    event NewProductAdded(
        uint8 _id,
        string _designation,
        uint256 _value,
        string _picture,
        address _owner,
        ProductStatus status
    );
    event ProductUpdated(
        uint8 _id,
        string _designation,
        uint256 _value,
        string _picture,
        address _owner,
        ProductStatus status
    );

    function addProduct(
        string memory _designation,
        uint256 _value,
        string memory _picture
    ) public {
        (, UserRole role) = userManagement.getUser(msg.sender);

        // Check weather msg.sender role is Maker
        require(
            role == UserRole.Maker,
            "Must be a maker to perform this action"
        );

        // Proceed to adding product
        products[productIdCounter] = Product(
            productIdCounter,
            _designation,
            _value,
            _picture,
            msg.sender,
            ProductStatus.Pending
        );

        emit NewProductAdded(
            productIdCounter,
            _designation,
            _value,
            _picture,
            msg.sender,
            ProductStatus.Pending
        );
    }

    function showProductInfos(
        uint8 _id
    )
        public
        view
        checkWeatherProductExists(_id)
        returns (
            uint8,
            string memory,
            uint256,
            string memory,
            address,
            ProductStatus
        )
    {
        Product memory product = products[_id];

        return (
            product.id,
            product.designation,
            product.value,
            product.picture,
            product.owner,
            product.status
        );
    }

    function updateProduct(
        uint8 _id,
        string memory _designation,
        uint256 _value,
        string memory _picture
    ) public checkWeatherProductExists(_id) {
        (, UserRole role) = userManagement.getUser(msg.sender);

        // Check weather msg.sender role is Maker
        require(
            role == UserRole.Maker,
            "Must be a maker to perform this action"
        );

        (, , , , address owner, ) = showProductInfos(_id);

        // Check weather msg.sender is the owner of the product
        require(
            owner == msg.sender,
            "Must be the product owner to perform this action"
        );

        // Check weather msg.sender is the owner of the product
        // require(status != ProductStatus.Validated, "Must be product owner to perform this action");

        // Proceed to updating product
        products[_id] = Product(
            _id,
            _designation,
            _value,
            _picture,
            msg.sender,
            ProductStatus.Pending // On reset le statut
        );

        emit ProductUpdated(
            _id,
            _designation,
            _value,
            _picture,
            msg.sender,
            ProductStatus.Pending
        );
    }

    modifier checkWeatherProductExists(uint8 _id) {
        require(
            uint8(products[_id].status) != uint8(ProductStatus.Undefined),
            "Product does not exists"
        );
        _;
    }
}
