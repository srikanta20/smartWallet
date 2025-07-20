# SmartWallet (Solidity)

A secure smart wallet contract written in Solidity that enables controlled fund transfers, guardian-based ownership recovery, and allowance management.

## Features

- **Owner-only access** to set allowances and guardians.
- **Allowance system**: Permit addresses to send up to a defined amount.
- **Guardian system**: Multiple trusted addresses can vote to recover/change ownership.
- **Low-level call support**: Can send Ether and call functions via `.call`.
- **Fallback receive function** for direct deposits.

## Files

- `contracts/SmartWallet.sol` - Main smart contract logic.
- `consumer` contract inside the file is for testing deposit and balance viewing.

## How to Use

1. Deploy the `SmartWallet` contract.
2. Add guardians using `setGuardian(address, true)`.
3. Transfer ownership via `proposeNewOwner(address)`.
4. Send funds with optional payload using `transfer()`.

## License

MIT
