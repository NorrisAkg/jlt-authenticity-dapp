// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./../abstract/Types.sol";
import "./../interfaces/IUserManagement.sol";

contract ProductRegistrationContract {
    error onlyMaker();
    error productAlreadyExists();
    error productAlreadyValidated();
    error onlyValidator();
    error onlyAdmin();
    error InvalidReportIndex();

    event NewProductAdded(
        string serialNumber,
        string name,
        string description,
        string picture,
        uint256 price,
        uint256 registrationDate,
        address manufacter,
        address owner,
        ProductStatus status,
        address[] owners
    );
    event ProductUpdated(
        string serialNumber,
        string name,
        string description,
        uint256 price
    );
    event ProductSatusChanged(ProductStatus status, string message);
    event CounterfeitReported(
        string indexed serialNumber,
        address indexed reporter,
        string details
    );
    event ReportResolved(string indexed serialNumber, uint256 reportIndex);
    event AlertIssued(string indexed serialNumber, string message);

    uint8 s_productIdCounter = 0;
    uint256 public s_alertThreshold = 3;

    mapping(string => Product) s_products;
    mapping(string => Report[]) public s_counterfeitReports;

    IUserManagement userManagement;
    address s_admin;

    constructor(address userManagementContractAddress) {
        userManagement = IUserManagement(userManagementContractAddress);
        s_admin = msg.sender;
    }

    function addProduct(
        string memory _serialNumber,
        string memory _name,
        string memory _description,
        string memory _picture,
        uint256 _price
    ) public {
        UserRole role = userManagement.getUser(msg.sender);

        // Check weather msg.sender role is Maker
        if (role != UserRole.Maker) {
            revert onlyMaker();
        }

        if (s_products[_serialNumber].status != ProductStatus.Undefined) {
            revert productAlreadyExists();
        }

        // Proceed to adding product
        s_products[_serialNumber] = Product(
            _serialNumber,
            _name,
            _description,
            _picture,
            _price,
            block.timestamp,
            msg.sender,
            msg.sender,
            ProductStatus.Pending,
            new address[](0)
        );

        // Push owner to product owners array
        appendOwnerToProductOwners(_serialNumber, msg.sender);

        // Incremement Products id counter
        s_productIdCounter++;

        emit NewProductAdded(
            _serialNumber,
            _name,
            _description,
            _picture,
            _price,
            block.timestamp,
            msg.sender,
            msg.sender,
            ProductStatus.Pending,
            new address[](0)
        );
    }

    function appendOwnerToProductOwners(
        string memory _serialNumber,
        address _owner
    ) public checkWeatherProductExists(_serialNumber) {
        Product storage product = s_products[_serialNumber];

        product.owners.push(_owner);
    }

    function showProductInfos(
        string memory _serialNumber
    )
        public
        view
        checkWeatherProductExists(_serialNumber)
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
        )
    {
        Product memory product = s_products[_serialNumber];

        return (
            product.serialNumber,
            product.name,
            product.description,
            product.picture,
            product.price,
            product.registrationDate,
            product.manufacter,
            product.owner,
            product.status,
            product.owners
        );
    }

    function updateProduct(
        string memory _serialNumber,
        string memory _name,
        string memory _description,
        uint256 _price
    ) public checkWeatherProductExists(_serialNumber) {
        UserRole role = userManagement.getUser(msg.sender);

        // Check weather msg.sender role is Maker
        if (role != UserRole.Maker) {
            revert onlyMaker();
        }

        (
            ,
            ,
            ,
            ,
            ,
            ,
            ,
            address owner,
            ProductStatus status,

        ) = showProductInfos(_serialNumber);

        // Check weather msg.sender is the owner of the product
        require(
            owner == msg.sender,
            "Must be the product owner to perform this action"
        );

        // Check weather msg.sender is the owner of the product
        if (status == ProductStatus.Validated) {
            revert productAlreadyValidated();
        }

        // Proceed to updating product
        s_products[_serialNumber].name = _name;
        s_products[_serialNumber].description = _description;
        s_products[_serialNumber].price = _price;

        emit ProductUpdated(_serialNumber, _name, _description, _price);
    }

    function approveOrRejectProduct(
        string memory _serialNumber,
        ProductStatus _status
    ) public checkWeatherProductExists(_serialNumber) {
        UserRole role = userManagement.getUser(msg.sender);

        // Check weather msg.sender role is Validator
        // if (role != UserRole.Validator) {
        //     revert onlyValidator();
        // }

        // (, , , , , , , , ProductStatus status, ) = showProductInfos(
        //     _serialNumber
        // );

        // require(
        //     status == ProductStatus.Pending,
        //     "Product already treated"
        // );

        // Proceed to updating of product
        Product storage product = s_products[_serialNumber];

        product.status = _status;

        emit ProductSatusChanged(
            _status,
            _status == ProductStatus.Validated
                ? "Product validated"
                : "Product refused"
        );
    }

    function transferProduct(
        string memory _serialNumber,
        address _newOwner
    ) public checkWeatherProductExists(_serialNumber) {
        Product storage product = s_products[_serialNumber];

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

    function reportProduct(
        string memory _serialNumber,
        string memory _details
    ) public checkWeatherProductExists(_serialNumber) {
        UserRole role = userManagement.getUser(msg.sender);

        (, , , , , , , , ProductStatus status, ) = showProductInfos(
            _serialNumber
        );

        require(
            uint8(status) == uint8(ProductStatus.Validated),
            "Product not validated yet"
        );

        // Check weather msg.sender role is simple user
        require(
            role == UserRole.FinalUser,
            "Must be a simple user to perform this action"
        );

        Report memory newReport = Report({
            serialNumber: _serialNumber,
            reporter: msg.sender,
            details: _details,
            reportDate: block.timestamp
        });

        s_counterfeitReports[_serialNumber].push(newReport);
        emit CounterfeitReported(_serialNumber, msg.sender, _details);

        if (s_counterfeitReports[_serialNumber].length >= s_alertThreshold) {
            emit AlertIssued(
                _serialNumber,
                "High number of counterfeit reports. Investigation needed."
            );
        }
    }

    function getReports(
        string memory _serialNumber
    ) public view returns (Report[] memory) {
        return s_counterfeitReports[_serialNumber];
    }

    function resolveReport(
        string memory _serialNumber,
        uint256 reportIndex
    ) public {
        if (msg.sender != s_admin) {
            revert onlyAdmin();
        }
        if (reportIndex >= s_counterfeitReports[_serialNumber].length) {
            revert InvalidReportIndex();
        }

        delete s_counterfeitReports[_serialNumber][reportIndex];
        emit ReportResolved(_serialNumber, reportIndex);
    }

    modifier checkWeatherProductExists(string memory _serialNumber) {
        require(
            uint8(s_products[_serialNumber].status) !=
                uint8(ProductStatus.Undefined),
            "Product does not exists"
        );
        _;
    }
}
