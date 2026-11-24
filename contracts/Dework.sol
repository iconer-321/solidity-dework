// SPDX-License-Identifier: GPL-3.0
pragma solidity =0.8.34;
import {FreelancerProfile, EmployeeProfile} from "./types/DeworkType.sol";

contract Dework{
    uint connectFee;
    address public initialOwner;
    FreelancerProfile[] public freelancerProfiles;
    EmployeeProfile[] public employeeProfiles;

    constructor(address _initalOwner){
        initialOwner = _initalOwner;
    }

    function getNumberOfRegisteredFreelancers() public view returns (uint256){
        return freelancerProfiles.length;
    }

    function registerFreelancherProfile(
        string calldata name,
        uint8 experienceYears,
        uint256 hourlyRateWei 
    ) external {
        uint256 freelancerId = getNumberOfRegisteredFreelancers();
        FreelancerProfile memory freelancherProfile = FreelancerProfile({
            id: freelancerId,
            name: name,
            wallet: msg.sender,
            experienceYears: experienceYears,
            isAvaliableHere: true,
            hourlyRateWei: hourlyRateWei
        });
        freelancerProfiles.push(freelancherProfile);
        
    }

    function getFreelancerProfile() public view returns(FreelancerProfile[] memory){
        return  freelancerProfiles;
    }

    // Employee
    function getNumberOfEmployee() public view returns (uint256){
        return employeeProfiles.length;
    }

    function registerEmployeeProfile(
        string calldata name
    ) external  {
        uint256 employeeId = getNumberOfEmployee();

        EmployeeProfile memory employeeProfile = EmployeeProfile({
            id: employeeId,
            name: name,
            wallet: msg.sender,
            isHiring: false
        });

        employeeProfiles.push(employeeProfile);
    }

    function getEmployeeProfile() public view returns(EmployeeProfile[] memory){
        return employeeProfiles;
    }


} 