// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract Counter {
    uint private count;
    error InvalidCount();

    function increament() external payable {
        count++;
    }

    function getCount() external view returns (uint) {
        return count;
    }

    function getValidCount() external view returns (uint) {
        if (count > 5) revert InvalidCount();
        return count;
    }
}

contract MyContract {
    function simpleExtCall(address _counter) public view returns (uint) {
        return Counter(_counter).getCount();
    }

    function extCallWithTryCatch(
        address _counter
    ) public view returns (uint cnt, bool, string memory, uint, bytes memory) {
        try Counter(_counter).getValidCount() returns (uint c) {
            return (c, true, "", 0, "");
        } catch Error(string memory reason)  {
            return (0, false, reason, 0, "");
        } catch Panic(uint errorCode) {
            //overflow or under flow errors
            return (0, false, "", errorCode, "");
        } catch (bytes memory lowLevelData) {
            // low level call (any error in parents contracts)
            return (0, false, "", 0, lowLevelData);
        }
    }

    function customizeExternalCall(address _counter) public payable {
        Counter(_counter).increament{value: msg.value, gas: 40_000}();
    }
}
