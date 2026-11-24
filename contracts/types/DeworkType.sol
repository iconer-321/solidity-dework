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
}