// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
// import "../lib/forge-std/src/Test.sol";

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe; //made a state variable

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; // decimals don't work in solidity but 0.1 ether = 10e7
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        // us -> FundMeTest -> fundMe
       // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306); // fundMe variable of FundMe type = new FundMe contract
       // OR
       DeployFundMe deployFundMe = new DeployFundMe();
       fundMe = deployFundMe.run();
       vm.deal(USER, STARTING_BALANCE); // Give USER some money
    }

    // function testDemo() public {
    //      console.log(number);
    //     assertEq(number, 2);
    //  }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18); //test contract gave access to assertEq fn
    }


    function testOwnerIsMsgSender() public {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        console.log(address(this));
        // it will show error since 
        // us -> fundMeTest -> fundMe (us calling FundMeTest which deploys FundMe)
        // so fundMeTest should be owner of fundMe
        // assertEq(fundMe.i_owner(), msg.sender); --> test will fail
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate () public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4); // since we know version should be 4
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); // Hey, the next line should revert!
        // equivalent to assert(This tx fails/reverts)
        fundMe.fund(); // send 0 value so this test will pass 
        
        // (bool revertAsExpected,) = address(fundMe).call{value: 1e18}("");
        // assertTrue(revertAsExpected, "expectedRevert: call did not revert");
    }
        function testFundUpdatesFundedDataStructure() public {
            //To be clear about who sends the transaction use pranks(cheatcode from foundry)
            vm.prank(USER); // The next TX will be sent by USER

            fundMe.fund{value: SEND_VALUE}(); // 10 eth
            uint256 amountFunded = fundMe.getAddressToAmountFunded(address(USER));
            assertEq(amountFunded, SEND_VALUE);
    }
}
