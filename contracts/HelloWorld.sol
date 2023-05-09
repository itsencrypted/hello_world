//SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract HelloWorld {
    string public userName;

    constructor() {
        userName = "Subscriber";
    }

    function setName(string memory _name) public {
        userName = _name;
    }
}
