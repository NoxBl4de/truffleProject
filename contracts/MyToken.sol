pragma solidity ^0.7.5;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 * Based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.1/contracts/examples/SimpleToken.sol
 */
contract MyToken is ERC20, Ownable {

    using SafeMath for uint;

    // Mapping for whitelist
     
    mapping (address => uint8) private tiers;
    mapping (address => bool) private allowedUsers;

    // counter for the several tiers
    uint256 private tierCount;

    /**
     * @dev Constructor that sets the name and symbol of the token.
     */
    constructor(
        string memory ticker,
        string memory symbol,
        uint256 totalSupply
    ) public ERC20(ticker, symbol) {
    }

    /**
     * @dev Give the tokens to the user asking for them.
     */
    function getToken() payable public onlyAllowed {
        //we set the tier before starting the exchange procedure
        setTier(msg.sender);

        // If you are in the first tier you get 100 tokens
        if (tiers[msg.sender] == 1) {
            _mint(msg.sender, 100);
        }

        // If you are in the second tier you get 50 tokens
        else if (tiers[msg.sender] == 2) {
            _mint(msg.sender, 50);
        }

        // If you are in the third tier you get 10 tokens
        else if (tiers[msg.sender] == 3) {
            _mint(msg.sender, 10);
        }

        // If an information is not entered right, we throw the function
        else {}
    }

    /**
     * @dev Called each time getToke() is called. Manages the tiers of the ICO.
     */
    function setTier(address _user) private {
        // the first tier is a 100 users
        if (tierCount <= 100) {
            tiers[_user] = 1;
        }

        // the second tier is till we reach 1000 users
        else if (tierCount > 100 && tierCount <= 1000) {
            tiers[_user] = 2;
        }

        // the third tier is over 1000 users
        else if (tierCount > 1000) {
            tiers[_user] = 3;
        }
        
        tierCount += 1;
    }

    /**
     * @dev Add an allowed user to the mapping.
     */
    function addAllowedUser(address _user) public virtual onlyOwner {
        allowedUsers[_user] = true;
    }

    /**
     * @dev Throws if called by any account other than the allowed ones.
     */
    modifier onlyAllowed() {
        require(allowedUsers[msg.sender], "Allowed: user is not allowed to call this function");
        _;
    }

    /**
     * @dev Mints and sends token to an arbitrary address.
     */
     function airdrop(address _arbitrary, uint256 amount) public virtual onlyOwner {
         _mint(_arbitrary, amount);
     }
}