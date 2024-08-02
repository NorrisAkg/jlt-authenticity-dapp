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

    function transferProduct(
        string memory _serialNumber,
        address _newOwner
    ) public {

        productRegistrationContract.transferProduct(_serialNumber,msg.sender, _newOwner);
    }

    function getProductOwners(
        string memory _serialNumber
    ) public view returns (address[] memory) {
        (
            ,
            ,
            ,
            ,
            ,
            ,
            ,
            ,
            ,
            address[] memory _owners
        ) = productRegistrationContract.showProductInfos(_serialNumber);

        return _owners;
    }
}
