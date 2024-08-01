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
    //     address[] owners;
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
        ProductStatus status,
        address[] owners
    );
    event ProductUpdated(
        uint8 _id,
        string _designation,
        uint256 _value,
        string _picture,
        address _owner,
        ProductStatus status,
        address[] owners
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
            ProductStatus.Pending,
            new address[](0)
        );

        // Push owner to product owners array
        appendOwnerToProductOwners(productIdCounter, msg.sender);

        // Incremement Products id counter
        productIdCounter++;

        emit NewProductAdded(
            productIdCounter,
            _designation,
            _value,
            _picture,
            msg.sender,
            ProductStatus.Pending,
            new address[](0)
        );
    }

    function appendOwnerToProductOwners(
        uint8 _productId,
        address _owner
    ) public checkWeatherProductExists(_productId) {
        Product storage product = products[_productId];

        product.owners.push(_owner);
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
            ProductStatus,
            address[] memory
        )
    {
        Product memory product = products[_id];

        return (
            product.id,
            product.designation,
            product.value,
            product.picture,
            product.owner,
            product.status,
            product.owners
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

        (, , , , address owner, , address[] memory owners) = showProductInfos(
            _id
        );

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
            ProductStatus.Pending, // Reset status
            owners
        );

        emit ProductUpdated(
            _id,
            _designation,
            _value,
            _picture,
            msg.sender,
            ProductStatus.Pending,
            owners
        );
    }

    function approveOrRejectProduct(
        uint8 _productId,
        ProductStatus _status
    ) public checkWeatherProductExists(_productId) {
        (, UserRole role) = userManagement.getUser(msg.sender);

        // Check weather msg.sender role is Validator
        require(
            role == UserRole.Validator,
            "Must be a validator to perform this action"
        );

        require(
            _status == ProductStatus.Validated ||
                _status == ProductStatus.Refused,
            "Incorrect status"
        );

        (
            uint8 id,
            string memory designation,
            uint value,
            string memory picture,
            address owner,
            ProductStatus status,
            address[] memory owners
        ) = showProductInfos(_productId);

        require(
            uint8(status) == uint8(ProductStatus.Pending),
            "Product already treated"
        );

        // Proceed to updating of product
        products[_productId] = Product(
            id,
            designation,
            value,
            picture,
            owner,
            status,
            owners
        );

        emit ProductUpdated(
            id,
            designation,
            value,
            picture,
            owner,
            status,
            owners
        );
    }

    function transferProduct(
        uint8 _productId,
        address _newOwner
    ) public checkWeatherProductExists(_productId) {
        Product storage product = products[_productId];

        // Check if msg sender is product owner
        require(
            msg.sender == product.owner,
            "Only product owner can transfer product"
        );

        // Check if product is validated before transfer it
        require(
            product.status == ProductStatus.Validated,
            "Product not validated yet"
        );

        // Change owner of product
        product.owner = _newOwner;

        // Add new owner to product owners array
        product.owners.push(_newOwner);
    }

    modifier checkWeatherProductExists(uint8 _id) {
        require(
            uint8(products[_id].status) != uint8(ProductStatus.Undefined),
            "Product does not exists"
        );
        _;
    }
}
