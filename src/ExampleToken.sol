// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title ExampleToken
 * @dev Implementation of the ExampleToken with owner and admin roles
 * Owner is set to the deployer (msg.sender)
 * Owner can set admins and pause/unpause the contract
 * Only admins can mint and burn tokens
 * Token transfers, minting, and burning are disabled when the contract is paused
 */
contract ExampleToken is ERC20, Ownable, Pausable {
    address private _admin;

    // Events
    event AdminChanged(address indexed account);
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);

    /// @dev Constructor that sets the owner to the deployer (msg.sender)
    constructor() ERC20("Example Token", "EXPT") Ownable(msg.sender) {}

    /// @dev Modifier to restrict function access to admin only
    modifier onlyAdmin() {
        require(_admin == msg.sender, "ExampleToken: caller is not an admin");
        _;
    }

    /// @dev Sets admin for an account
    /// @param account The address to set admin for
    /// Only owner can call this function
    function setAdmin(address account) external onlyOwner {
        require(account != address(0), "ExampleToken: cannot set admin status for zero address");
        _admin = account;
        emit AdminChanged(account);
    }

    /// @dev Pauses all token transfers, minting, and burning
    /// Only owner can call this function
    function pause() external onlyOwner {
        _pause();
    }

    /// @dev Unpauses all token transfers, minting, and burning
    /// Only owner can call this function
    function unpause() external onlyOwner {
        _unpause();
    }

    /// @dev Mints tokens to the specified account
    /// @param to The address to mint tokens to
    /// @param amount The amount of tokens to mint
    /// Only admins can call this function
    /// This function is disabled when the contract is paused
    function mint(address to, uint256 amount) external onlyAdmin whenNotPaused {
        require(to != address(0), "ExampleToken: cannot mint to the zero address");
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    /// @dev Burns tokens from the specified account
    /// @param from The address to burn tokens from
    /// @param amount The amount of tokens to burn
    /// Only admins can call this function
    /// This function is disabled when the contract is paused
    function burn(address from, uint256 amount) external onlyAdmin whenNotPaused {
        require(from != address(0), "ExampleToken: cannot burn from the zero address");
        _burn(from, amount);
        emit TokensBurned(from, amount);
    }

    /// @dev Override the _update function to include the whenNotPaused modifier
    /// This will affect all transfers, mints, and burns
    function _update(address from, address to, uint256 amount) internal virtual override whenNotPaused {
        super._update(from, to, amount);
    }
}
