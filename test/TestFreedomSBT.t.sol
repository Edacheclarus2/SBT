// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {FreedomSBT} from "../src/FreedomSBT.sol";
import {DeployFreedomSBT} from "../script/DeployFreedomSBT.s.sol";
// import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract TestOpenNFT is Test {
    DeployFreedomSBT public deployer;
    FreedomSBT public freedomSBT;
    address private _bob = makeAddr("bob");
    address private _alice = makeAddr("Alice");
    address _addressForMyTestExperiment = 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;

    function setUp() public {
        deployer = new DeployFreedomSBT();
        freedomSBT = deployer.run();
        freedomSBT.mintToken(_alice, 1);
    }

    ///////////
    // TESTS //
    //////////

    function testData() public {
        assertEq(freedomSBT.name(), freedomSBT.getName());

        assertEq(freedomSBT.symbol(), freedomSBT.getSymbol());

        assertEq(freedomSBT.getBasicURI(), "ipfs://bafybeigogdgnc7ernxrve2s6gu2zovigtstt5rrlguu6pg6s46bibwbg3m/");
        assert(freedomSBT.getMaxSupply() == 4);
        console.log("Total Supply: ", freedomSBT.getTotalSupply());
    }

    // MINT TOKEN
    function testMintToken() public {
        vm.prank(_bob);
        freedomSBT.mintToken(_bob, 2);
    }

    function testCantMintTokenTwice() public {
        vm.prank(_bob);
        freedomSBT.mintToken(_bob, 2);
        vm.expectRevert(); // This should revert because _bob  has already minted a TOKEN.
        freedomSBT.mintToken(_bob, 5);
        console.log(freedomSBT.tokenURI(2));
    }

    function testCurrentStatus() public view {
        freedomSBT.getCurrentStatus();
        freedomSBT.getMintedStatus(_bob);
    }

    function testTotalSupply() public view {
        console.log("Current Supply : ", freedomSBT.getTotalSupply());
    }

    function testOnlyTokenOwnerCanBurnToken() public {
        vm.startPrank(_alice);
        vm.expectRevert("Not Token OWner");
        freedomSBT.burnToken(0);
        console.log("Alice Remaining Balance: ", freedomSBT.balanceOf(_alice));
        vm.stopPrank();
    }

    function testBaseURI() public {
        assertEq(freedomSBT.getBasicURI(), "ipfs://bafybeigogdgnc7ernxrve2s6gu2zovigtstt5rrlguu6pg6s46bibwbg3m/");
    }

    function testTransfers() public {
        vm.prank(_bob);
        freedomSBT.mintToken(_bob, 2);
        vm.startPrank(_bob);
        freedomSBT.approve(_addressForMyTestExperiment, 2);
        vm.expectRevert();
        freedomSBT.safeTransferFrom(_bob, _addressForMyTestExperiment, 2);
        vm.stopPrank();
    }
    //////////////////
    // DEPLOY SCRIPT//
    //////////////////

    function testRun() public {
        deployer.run();
    }
}
