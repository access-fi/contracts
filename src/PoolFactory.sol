// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Pool.sol";

contract PoolFactory {
    address[] public allPools;
    mapping(address => address[]) public creatorPools;

    // Custom errors
    error InvalidPrice();
    error InvalidBudget();
    error InvalidDeadline();

    event PoolCreated(address indexed creator, address indexed poolAddress, string name);

    function createPool(
        string memory _name,
        string memory _description,
        string memory _dataType,
        Pool.ProofRequirement[] memory _proofRequirements,
        uint256 _pricePerData,
        uint256 _totalBudget,
        uint256 _deadline,
        address _owner
    ) external payable returns (address) {
        if (_pricePerData == 0) revert InvalidPrice();
        if (_totalBudget == 0) revert InvalidBudget();
        
        Pool newPool = new Pool(
            _name,
            _description,
            _dataType,
            _proofRequirements,
            _pricePerData,
            _totalBudget,
            _deadline,
            _owner
        );
        
        address poolAddress = address(newPool);
        allPools.push(poolAddress);
        creatorPools[_owner].push(poolAddress);
        
        // Forward the ETH to the pool
        if (msg.value > 0) {
            (bool success, ) = payable(poolAddress).call{value: msg.value}("");
            require(success, "Failed to send ETH to pool");
        }
        
        emit PoolCreated(_owner, poolAddress, _name);
        return poolAddress;
    }

    function joinPool(address _poolAddress) external {
        Pool pool = Pool(payable(_poolAddress));
        pool.joinPoolBySender(msg.sender);
    }

    function verifySeller(address _poolAddress, address _seller, bool _verified, bytes32 _proof) external {
        Pool pool = Pool(payable(_poolAddress));
        pool.verifySeller(_seller, _verified, _proof);
    }

    function submitProof(address _poolAddress, string memory _proofName, bytes32 _proofHash) external {
        Pool pool = Pool(payable(_poolAddress));
        pool.submitProofBySender(msg.sender, _proofName, _proofHash);
    }

    function submitSelfProof(address _poolAddress, string memory _proofName, bytes32 _selfProofHash) external {
        Pool pool = Pool(payable(_poolAddress));
        pool.submitSelfProofBySender(msg.sender, _proofName, _selfProofHash);
    }

    function getAllPools() external view returns (address[] memory) {
        return allPools;
    }

    function getCreatorPools(address _creator) external view returns (address[] memory) {
        return creatorPools[_creator];
    }

    function getTotalPools() external view returns (uint256) {
        return allPools.length;
    }

}