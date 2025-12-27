// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./PoolFactory.sol";

contract User {
    address public owner;
    address[] public createdPools;
    address[] public joinedPools;
    uint256 public totalSpent;
    uint256 public totalEarned;
    address public poolFactory;
    PoolFactory public factory;

    event PoolCreated(address indexed poolAddress);
    event PoolJoined(address indexed poolAddress);

    constructor(address _owner, address _poolFactory) {
        owner = _owner;
        poolFactory = _poolFactory;
        factory = PoolFactory(poolFactory);
    }

    function createPool(
        string memory _name,
        string memory _description,
        string memory _dataType,
        Pool.ProofRequirement[] memory _proofRequirements,
        uint256 _pricePerData,
        uint256 _totalBudget,
        uint256 _deadline
    ) external payable returns (address) {
        require(msg.sender == owner, "Only owner can create pools");
        
        address poolAddress = factory.createPool{value: msg.value}(
            _name,
            _description,
            _dataType,
            _proofRequirements,
            _pricePerData,
            _totalBudget,
            _deadline,
            msg.sender
        );
        
        createdPools.push(poolAddress);
        emit PoolCreated(poolAddress);
        
        return poolAddress;
    }

    function joinPool(address _poolAddress) external {
        require(msg.sender == owner, "Only owner can join pools");
        factory.joinPool(_poolAddress);
        joinedPools.push(_poolAddress);
        emit PoolJoined(_poolAddress);
    }

    function verifySeller(address _poolAddress, address _seller, bool _verified, bytes32 _proof) external {
        require(msg.sender == owner, "Only owner can verify sellers");
        factory.verifySeller(_poolAddress, _seller, _verified, _proof);
    }

    function submitProof(address _poolAddress, string memory _proofName, bytes32 _proofHash) external {
        require(msg.sender == owner, "Only owner can submit proofs");
        factory.submitProof(_poolAddress, _proofName, _proofHash);
    }

    function submitSelfProof(address _poolAddress, string memory _proofName, bytes32 _selfProofHash) external {
        require(msg.sender == owner, "Only owner can submit Self proofs");
        factory.submitSelfProof(_poolAddress, _proofName, _selfProofHash);
    }

    function recordSpending(uint256 _amount) external {
        totalSpent += _amount;
    }

    function recordEarning(uint256 _amount) external {
        totalEarned += _amount;
    }

    function getCreatedPools() external view returns (address[] memory) {
        return createdPools;
    }

    function getJoinedPools() external view returns (address[] memory) {
        return joinedPools;
    }

    function getCreatedPoolsCount() external view returns (uint256) {
        return createdPools.length;
    }

    function getJoinedPoolsCount() external view returns (uint256) {
        return joinedPools.length;
    }

    function getTotalSpent() external view returns (uint256) {
        return totalSpent;
    }

    function getTotalEarned() external view returns (uint256) {
        return totalEarned;
    }

    receive() external payable {}
}