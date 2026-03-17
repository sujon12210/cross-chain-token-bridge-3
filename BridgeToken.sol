// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title BridgeToken
 * @dev ERC20 token with Mint/Burn capabilities controlled by Bridge Admins.
 */
contract BridgeToken is ERC20, ERC20Burnable, AccessControl {
    bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");

    // Tracks processed transaction hashes from other chains to prevent double-minting
    mapping(bytes32 => bool) public processedTransactions;

    event TokensBurned(address indexed user, uint256 amount, uint256 targetChainId);
    event TokensMinted(address indexed user, uint256 amount, bytes32 sourceTxHash);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @dev User calls this to move tokens to another chain.
     */
    function bridgeTokens(uint256 amount, uint256 targetChainId) external {
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount, targetChainId);
    }

    /**
     * @dev Relayer calls this to finalize the bridge from the source chain.
     */
    function processMint(
        address user,
        uint256 amount,
        bytes32 sourceTxHash
    ) external onlyRole(RELAYER_ROLE) {
        require(!processedTransactions[sourceTxHash], "Transaction already processed");
        
        processedTransactions[sourceTxHash] = true;
        _mint(user, amount);
        
        emit TokensMinted(user, amount, sourceTxHash);
    }
}
