// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./../interfaces/IProductRegistrationContract.sol";
import "./../abstract/Types.sol";

contract ProductValidationContract {
    IProductRegistrationContract productRegistrationContract;

    constructor(address productRegistrationContractAddress) {
        productRegistrationContract = IProductRegistrationContract(productRegistrationContractAddress);
    }

    function validateProduct(uint8 _productId) public {
        productRegistrationContract.approveOrRejectProduct(_productId, ProductStatus.Validated);
    }

    function rejectProduct(uint8 _productId) public {
        productRegistrationContract.approveOrRejectProduct(_productId, ProductStatus.Refused);
    }

    function getProdutStatus(uint8 _productId) public returns (ProductStatus){
        (, , , , , _status)productRegistrationContract.showProductInfos(_productId);

        return _status;
    }
}