struct FreelancerProfile{
    uint256 id;
    string name;
    address wallet;
    uint8 experienceYears;
    bool isAvaliableHere;
    uint256 hourlyRateWei;
}

struct EmployeeProfile{
    uint256 id;
    string name;
    bool isHiring;
    address wallet; 
    JobListing[] jobListing;
}

struct createJobListingInput{
    string title;
    string description;
    uint256 deadline;
    uint256 fixedPriceInWei;
}

struct JobListing{
    uint256 id;
    string title;
    string description;
    uint256 deadlineTimestamp;
    bool isOpen;
    uint256 fixedPriceInWei;
    uint256 hiredFreelancerId;
    bool hasHiredFreelancer;
    bool isPaid;
}