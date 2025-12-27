// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {UserFactory} from "../src/UserFactory.sol";
import {PoolFactory} from "../src/PoolFactory.sol";

contract DeployDataFi is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("Deploying contracts with the account:", deployer);
        console.log("Account balance:", deployer.balance);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy PoolFactory first
        PoolFactory poolFactory = new PoolFactory();
        console.log("PoolFactory deployed at:", address(poolFactory));

        // Deploy UserFactory with PoolFactory address
        UserFactory userFactory = new UserFactory(address(poolFactory));
        console.log("UserFactory deployed at:", address(userFactory));

        vm.stopBroadcast();

        console.log("Deployment completed!");
        console.log("PoolFactory address:", address(poolFactory));
        console.log("UserFactory address:", address(userFactory));
    }
}
