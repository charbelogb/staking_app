pragma solidity >=0.4.22 <0.9.0;

import "./Dummy_Token.sol";
import "./Tether_Token.sol";

contract Staking_Dapp {

    string public name = "Staking Dapp";
    address public owner;
    Dummy_Token public dummy_token;
    Tether_Token public tether_token;

    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(Dummy_Token _dummyToken, Tether_Token _tetherToken) public {
        dummy_token = _dummyToken;
        tether_token = _tetherToken;
        owner = msg.sender;
    }

    function stakeTokens(uint _amount) public {
        require(_amount > 0, "Amount can not be zero");
        tether_token.transferFrom(msg.sender, address(this), _amount); // transfer tether to contravct address
        stakingBalance[msg.sender] += _amount;
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    function unstakeTokens() public {
        uint balance = stakingBalance[msg.sender]; //fetch balance of staker into a variable
        require(balance > 0, "Staking balance is zero"); //check if balance is zero
        tether_token.transfer(msg.sender, balance); // transfer back tether token to user
        stakingBalance[msg.sender] = 0; // set staking balance to 0
        isStaking[msg.sender] = false; // update staking status
    }

    function issueDummy() public {
        require(msg.sender == owner, "Caller must be the owner for this function");
        for(uint i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if (balance > 0) {
                dummy_token.transfer(recipient, balance);
            }
        }
    }

}