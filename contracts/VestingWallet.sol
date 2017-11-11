
pragma solidity ^0.4.15;

import "./ERC20.sol";

  /**
   * @dev For the tokens issued for founders.
   */

contract VestingWallet {
    event TokensReleased(uint _tokensReleased, uint _tokensRemaining, uint _nextPeriod);

    ////// [low] Uninitialized
    address public foundersWallet;
    address public crowdsaleContract;
    ERC20 public tokenContract;
    // Two-year vesting with 1 month cliff. Roughly.
    uint constant cliffPeriod = 30 days;
    uint constant totalPeriods = 24;

    uint public periodsPassed = 0;
    uint public nextPeriod;
    uint public tokensRemaining;
    uint public tokensPerBatch;

    // Constructor
    // ===========
    function VestingWallet(address _foundersWallet, address _tokenContract) {
        foundersWallet  = _foundersWallet;
        tokenContract   = ERC20(_tokenContract);
        crowdsaleContract = msg.sender;
    }

    // PRIVILEGED FUNCTIONS
    // ====================
    //
    ////// [critical] Founders can call that BEFORE launchVesting()
    ////// which will ruin 'periodsPassed' var.
    function releaseBatch() external onlyFounders {
        require( now > nextPeriod );
        require( periodsPassed < totalPeriods );
        uint tokensToRelease = 0;
        do {
            periodsPassed   += 1;
            nextPeriod      += cliffPeriod;
            tokensToRelease += tokensPerBatch;
        } while (now > nextPeriod);

        // If vesting has finished, just transfer the remaining tokens.
        if (periodsPassed >= totalPeriods) {
            tokensToRelease = tokenContract.balanceOf(this);
            nextPeriod = 0x0;
        }

        ////// [critical] Consider using Safe Math 
        tokensRemaining -= tokensToRelease;
        tokenContract.transfer(foundersWallet, tokensToRelease);
        TokensReleased(tokensToRelease, tokensRemaining, nextPeriod);
    }

    ////// [low] This can be called again
    function launchVesting() onlyCrowdsale {
        tokensRemaining = tokenContract.balanceOf(this);
        nextPeriod      = now + cliffPeriod;
        tokensPerBatch  = tokensRemaining / totalPeriods;
    }

    // INTERNAL FUNCTIONS
    // ==================
    modifier onlyFounders() {
        require( msg.sender == foundersWallet );
        _;
    }

    modifier onlyCrowdsale() {
        require( msg.sender == crowdsaleContract );
        _;
    }
}
