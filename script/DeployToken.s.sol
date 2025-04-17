// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";

import {ExampleToken} from "../src/ExampleToken.sol";

/**
 * @title DeployToken
 * @dev Deployment script for ExampleToken
 */
contract DeployToken is Script {
    function run() external returns (ExampleToken token) {
        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy the token contract
        token = new ExampleToken();

        // Stop broadcasting transactions
        vm.stopBroadcast();

        return token;
    }
}
