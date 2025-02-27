// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./../interfaces/IProductRegistrationContract.sol";
import "./../abstract/Types.sol";

contract ProductValidationContract {
    IProductRegistrationContract productRegistrationContract;

    constructor(address productRegistrationContractAddress) {
        productRegistrationContract = IProductRegistrationContract(
            productRegistrationContractAddress
        );
    }

    function validateProduct(
        string memory _serialNumber,
        address _creator
    ) public {
        // must be validator

        productRegistrationContract.approveOrRejectProduct(
            _creator,
            _serialNumber,
            ProductStatus.Validated
        );
    }

    function rejectProduct(
        string memory _serialNumber,
        address _creator
    ) public {
        productRegistrationContract.approveOrRejectProduct(
            _creator,
            _serialNumber,
            ProductStatus.Refused
        );
    }

    function getProductStatus(
        string memory _serialNumber
    ) public view returns (ProductStatus) {
        (, , , , , , , , ProductStatus _status, ) = productRegistrationContract
            .showProductInfos(_serialNumber);

        return _status;
    }
}
