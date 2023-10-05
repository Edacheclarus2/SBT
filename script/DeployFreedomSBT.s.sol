// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FreedomSBT} from "../src/FreedomSBT.sol";

contract DeployFreedomSBT is Script {
    function run() external returns (FreedomSBT) {
        vm.startBroadcast();
        FreedomSBT freedomSbt = new  FreedomSBT(); // Freedom ("ipfs://bafybeigogdgnc7ernxrve2s6gu2zovigtstt5rrlguu6pg6s46bibwbg3m/");
        vm.stopBroadcast();
        return freedomSbt;
    }
}
