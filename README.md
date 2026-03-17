# Cross-Chain Token Bridge

A professional, flat-structured implementation of a cross-chain bridging mechanism. This repository focuses on the "Burn-and-Mint" model, which is widely used for moving assets across independent Layer 1 and Layer 2 networks.

## Features
* **Burn-and-Mint Logic:** Ensures the total supply remains constant across all chains by burning tokens on the source and minting on the destination.
* **Role-Based Access:** Uses OpenZeppelin's AccessControl to manage authorized bridge relayers.
* **Replay Protection:** Unique transaction IDs (hashes) prevent the same bridge event from being processed multiple times on the destination chain.
* **Emergency Stops:** Pausable functionality to halt bridging in case of detected anomalies.

## Workflow
1. **Initiate:** User calls `bridgeTokens(amount, targetChainId)` on Chain A. The contract burns the user's tokens.
2. **Relay:** An off-chain relayer listens for the `TokensBurned` event.
3. **Fulfill:** The relayer calls `processMint(user, amount, sourceTxHash)` on Chain B.
4. **Complete:** The contract on Chain B verifies the relayer and mints the equivalent tokens to the user.

## Security
This implementation requires a trusted set of relayers. For production use, consider integrating decentralized oracle networks like Chainlink CCIP or LayerZero.
