// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./User.sol";

contract UserFactory {
    mapping(address => address) public users;
    address[] public allUsers;
    address public poolFactory;

    event UserCreated(address indexed wallet, address indexed userContract);

    constructor(address _poolFactory) {
        poolFactory = _poolFactory;
    }

    function createUser() external {
        require(users[msg.sender] == address(0), "User already exists");
        
        User newUser = new User(msg.sender, poolFactory);
        users[msg.sender] = address(newUser);
        allUsers.push(address(newUser));
        
        emit UserCreated(msg.sender, address(newUser));
    }
    
    function getUser(address _wallet) external view returns (address) {
        return users[_wallet];
    }
    
    function userExists(address _wallet) external view returns (bool) {
        return users[_wallet] != address(0);
    }

    function getAllUsers() external view returns (address[] memory) {
        return allUsers;
    }

    function getTotalUsers() external view returns (uint256) {
        return allUsers.length;
    }
}