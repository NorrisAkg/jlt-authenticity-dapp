// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./../interfaces/IProductRegistrationContract.sol";
import "./../abstract/Types.sol";

contract OwnershipTransferContract {
    IProductRegistrationContract productRegistrationContract;

    constructor(address productRegistrationContractAddress) {
        productRegistrationContract = IProductRegistrationContract(
            productRegistrationContractAddress
        );
    }

    function getProductOwners(
        uint8 _productId
    ) public returns (address[] memory) {
        (
            ,
            ,
            ,
            ,
            ,
            ProductStatus _status,
            address[] memory _owners
        ) = productRegistrationContract.showProductInfos(_productId);

        return _owners;
    }
}
