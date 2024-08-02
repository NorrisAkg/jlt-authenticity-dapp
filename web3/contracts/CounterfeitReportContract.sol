// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ProductRegistrationContract.sol";
import "./../abstract/Types.sol";

contract CounterfeitReportContract {
    /////////// CUSTOMER ERRORS ///////////////
    //////////////////////////////////////////

    error onlyOwner();
    error productNotRegistered();
    error InvalidReportIndex();

    ////////////////// EVENTS ///////////////////////
    /////////////////////////////////////////////////

    event CounterfeitReported(
        uint256 indexed productId,
        address indexed reporter,
        string details
    );
    event ReportResolved(uint256 indexed productId, uint256 reportIndex);
    event AlertIssued(uint256 indexed productId, string message);


    ///////// STORAGE VARIABLES  ////////////
    ////////////////////////////////////////

    mapping(uint256 => Report[]) public s_counterfeitReports;
    address public s_owner;
    ProductRegistrationContract s_productRegistrationContract;
    uint256 public s_alertThreshold = 3;

    ///////////// CONSTRUCTOR //////////////////////
    ////////////////////////////////////////////////

    constructor(address _productRegistrationContract) {
        s_owner = msg.sender;
        s_productRegistrationContract = ProductRegistrationContract(
            _productRegistrationContract
        );
    }

    ////////////// FUNCTIONS /////////////////////////
    /////////////////////////////////////////////////

    function reportCounterfeit(
        string memory _serialNumber,
        string memory _details
    ) public {
        s_productRegistrationContract.reportProduct(_serialNumber, _details);
    }

    function getReports(
        string memory _serialNumber
    ) public view {
        s_productRegistrationContract.getReports(_serialNumber); 
    }
}