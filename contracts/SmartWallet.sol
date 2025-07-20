// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract SmartWallet {
    address payable public owner;
    address payable public nextOwner;
    uint public guardiansResetCount;
    uint public constant guardianConfirmations = 3;

    mapping(address => bool) public guardians;
    mapping(address => mapping(address => bool)) public AlreadyVotedBool;
    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;

    constructor() {
        owner = payable(msg.sender);
    }

    function setGuardian(address _guardian, bool _isGuardian) public {
        require(msg.sender == owner, "You are not the owner! Aborting.");
        guardians[_guardian] = _isGuardian;
    }

    function proposeNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender], "You are not a guardian! Aborting.");
        require(!AlreadyVotedBool[_newOwner][msg.sender], "You have already voted!");

        if (_newOwner != nextOwner) {
            nextOwner = _newOwner;
            guardiansResetCount = 0;
        }

        AlreadyVotedBool[_newOwner][msg.sender] = true;
        guardiansResetCount++;

        if (guardiansResetCount >= guardianConfirmations) {
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }

    function setAllowance(address _for, uint _amount) public {
        require(msg.sender == owner, "You are not the owner! Aborting.");
        allowance[_for] = _amount;
        isAllowedToSend[_for] = _amount > 0;
    }

    function transfer(address payable _to, uint _amount, bytes memory _payload) public returns (bytes memory) {
        if (msg.sender != owner) {
            require(isAllowedToSend[msg.sender], "You are not allowed to send! Aborting.");
            require(allowance[msg.sender] >= _amount, "Insufficient allowance! Aborting.");
            allowance[msg.sender] -= _amount;
        }

        (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(success, "Call was not successful!");
        return returnData;
    }

    receive() external payable {}
}


contract consumer{
    function showBalance() public view returns(uint){
        return address(this).balance;
    }
    function deposit() public payable{}
}
