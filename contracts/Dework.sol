// SPDX-License-Identifier: MIT
pragma solidity =0.8.34;
import {FreelancerProfile, EmployeeProfile, createJobListingInput, JobListing} from "./types/DeworkType.sol";

contract Dework{
    uint connectFee;
    address public initialOwner;
    FreelancerProfile[] public freelancerProfiles;
    EmployeeProfile[] public employeeProfiles;
    mapping(uint256=>address) public freelancherIdToAddress;
    mapping(uint256=>address) public employeeIdToAddress;


    // Event
    event FreelancerProfileRegistered(uint256 freelancerId, address caller);
    event EmployeeRegistered(uint256 employeeId, address caller);

    // Error
    error Dework_IncorrectJobCreateionFee(uint256 expectedFee, uint256 actualFee);
    error DoWork_JobClosed(uint256 jobId);
    error DoWork_InvalidJob(uint256 employeeId, uint256 jobId);
    error DoWork_UnAuthorizedEmployee(uint256 employeeId, address caller);
    error DoWork_UnAuthorizedFreelancer(uint256 freelancerId, address caller);

    //modifier
    modifier onlyAuthorizedEmployee(uint256 employeeId) {
        address emplpyee = employeeIdToAddress[employeeId];
        if (emplpyee != msg.sender || emplpyee == address(0)){
            revert DoWork_UnAuthorizedEmployee(employeeId, msg.sender);
        }
        _;
    }


    //function

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
        freelancherIdToAddress[freelancerId] = msg.sender;

        emit FreelancerProfileRegistered(freelancerId, msg.sender);
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
            isHiring: false,
            jobListing: new JobListing[](0)
        });

        employeeProfiles.push(employeeProfile);
        employeeIdToAddress[employeeId] = msg.sender;
        emit EmployeeRegistered(employeeId, msg.sender);
    }

    function _getEmployeeProfile(uint256 employeeId) internal view returns(EmployeeProfile storage){
        return employeeProfiles[employeeId];
    }


    // Job 

    function getNumberOfCreatedJobList(uint256 employeeID) public view returns(uint256){
        return employeeProfiles[employeeID].jobListing.length;

    } 

    function createJobListing(
        uint256 employeeId,
        createJobListingInput memory jobListingInput
    ) external payable onlyAuthorizedEmployee(employeeId){
        uint256 fixedPriceForJob = jobListingInput.fixedPriceInWei;
        if (msg.value != fixedPriceForJob){
            revert Dework_IncorrectJobCreateionFee(fixedPriceForJob, msg.value);
        }
        EmployeeProfile storage employeeProfile = _getEmployeeProfile(employeeId);
        uint256 jobId = getNumberOfCreatedJobList(employeeId);

        JobListing memory newJobs = JobListing({
            id: jobId,
            title: jobListingInput.title,
            description: jobListingInput.description,
            deadlineTimestamp: jobListingInput.deadline,
            isOpen: true,
            fixedPriceInWei: jobListingInput.fixedPriceInWei,
            hasHiredFreelancer: false,
            hiredFreelancerId: 0,
            isPaid: false
        });
        employeeProfile.jobListing.push(newJobs);
    }

    function _requiredJobIsOpen(JobListing memory job) internal pure{
        if (job.isOpen == true){
            revert DoWork_JobClosed(job.id);
        }
    } 

    function _getJob(uint256 employeeId, uint256 jobId) internal view returns(JobListing storage){
        return employeeProfiles[employeeId].jobListing[jobId];
    }

    function getJobList(uint256 employeeId) external view returns (JobListing[] memory){
        return employeeProfiles[employeeId].jobListing;
    }

    function hiredFreelancer(uint256 employeeId, uint256 freelancherId, uint256 jobId) public onlyAuthorizedEmployee(employeeId){
        
        if (freelancherId >= getNumberOfRegisteredFreelancers() || freelancherIdToAddress[freelancherId] == address(0)){
            revert DoWork_UnAuthorizedFreelancer(freelancherId, msg.sender);
        }
        if (jobId >= getNumberOfCreatedJobList(employeeId)){
            revert DoWork_InvalidJob(employeeId, jobId);
        }
        JobListing storage job = _getJob(employeeId, jobId);
        _requiredJobIsOpen(job);
        job.hiredFreelancerId = freelancherId;
        job.hasHiredFreelancer = true;
        job.isOpen = false;
    }




} 

