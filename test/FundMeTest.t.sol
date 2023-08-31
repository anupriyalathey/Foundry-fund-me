// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe; //made a state variable

    function setUp() external {
        fundMe = new FundMe(); // fundMe variable of FundMe type = new FundMe contract
    }

    // function testDemo() public {
        
    // }
    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18); //test contract gave access to assertEq fn
    }


    function testOwnerIsMsgSender() public {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        console.log(address(this));
        // it will show error since 
        // us -> fundMeTest -> fundMe
        //so fundMeTest should be owner
        // assertEq(fundMe.i_owner(), msg.sender);
        assertEq(fundMe.i_owner(), address(this));
    }
}
