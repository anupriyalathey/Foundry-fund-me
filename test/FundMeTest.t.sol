// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
// import "../lib/forge-std/src/Test.sol";

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe; //made a state variable

    function setUp() external {
        // us -> FundMeTest -> fundMe
        fundMe = new FundMe(); // fundMe variable of FundMe type = new FundMe contract
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
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionIsAccurate () public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4); // since we know version should be 4
    }
}
