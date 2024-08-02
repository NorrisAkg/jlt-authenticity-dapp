// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./../abstract/Types.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ProductRegistrationContract is AccessControl {
    error productAlreadyExists();
    error productAlreadyValidated();
    error onlyValidator();
    error onlyAdmin();
    error InvalidReportIndex();

    bytes32 VALIDATOR_ROLE = keccak256("VALIDATOR_ROLE");
    bytes32 MANUFACTURER_ROLE = keccak256("MANUFACTURER_ROLE");

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


    address public counterfeitReportedAddress;
    address public productValidationAddress;
    address public ownershipTransferContract;

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // function initialize(
    //     address _counterfeitReportedAddress,
    //     address _productValidationAddress,
    //     address _ownershipTransferContract
    // ) public {
    //     productValidationAddress = _productValidationAddress;
    //     counterfeitReportedAddress = _counterfeitReportedAddress;
    //     ownershipTransferContract = _ownershipTransferContract;
    // }

    function addManufacturer(address _manufacturer) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Not the admin");
        grantRole(MANUFACTURER_ROLE, _manufacturer);
    }

    function addValidator(address _manufacturer) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Not the admin");
        grantRole(VALIDATOR_ROLE, _manufacturer);
    }

    function addProduct(
        string memory _serialNumber,
        string memory _name,
        string memory _description,
        string memory _picture,
        uint256 _price
    ) public {
        require(hasRole(MANUFACTURER_ROLE, msg.sender));

        // Check weather msg.sender role is Maker

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
        // Check weather msg.sender role is Maker
        require(hasRole(MANUFACTURER_ROLE, msg.sender));

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
        require(
            msg.sender == productValidationAddress,
            "Not productValidation contract"
        );
        (, , , , , , , , ProductStatus status, ) = showProductInfos(
            _serialNumber
        );

        require(status == ProductStatus.Pending, "Product already treated");

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
        address _currentOwner,
        address _newOwner
    ) public checkWeatherProductExists(_serialNumber) {
        require(
            msg.sender == ownershipTransferContract,
            "Not ownershipTransferContract"
        );
        Product storage product = s_products[_serialNumber];

        // Check if msg sender is product owner
        require(
            _currentOwner == product.owner,
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
        require(
            msg.sender == counterfeitReportedAddress,
            "Not counterfeitReported Contract"
        );

        (, , , , , , , , ProductStatus status, ) = showProductInfos(
            _serialNumber
        );

        require(
            uint8(status) == uint8(ProductStatus.Validated),
            "Product not validated yet"
        );

        // Check weather msg.sender role is simple user

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
        require(
            msg.sender == counterfeitReportedAddress,
            "Not counterfeitReported Contract"
        );
        return s_counterfeitReports[_serialNumber];
    }

    function resolveReport(
        string memory _serialNumber,
        uint256 reportIndex
    ) public {
        require(
            msg.sender == counterfeitReportedAddress,
            "Not counterfeitReported Contract"
        );

        if (reportIndex >= s_counterfeitReports[_serialNumber].length) {
            revert InvalidReportIndex();
        }

        delete s_counterfeitReports[_serialNumber][reportIndex];
        emit ReportResolved(_serialNumber, reportIndex);
    }

    modifier checkWeatherProductExists(string memory _serialNumber) {
        require(
            s_products[_serialNumber].status != ProductStatus.Undefined,
            "Product does not exists"
        );
        _;
    }
}
