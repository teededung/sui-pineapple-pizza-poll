# 🍕 Pineapple Pizza Poll

A smart contract on the Sui blockchain for voting on the eternal question: **"Should pineapple belong on pizza?"**
The goal of this project is to gain a deeper understanding of **Shared Objects** through a simple voting application, while exploring the choice between **VecSet** and **Table** for storing the list of wallet addresses that have already voted.

## 📋 Overview

- **Module**: `pineapple_pizza_poll`
- **Network**: Sui Testnet
- **Example Package ID**: `0x1272d1c6239601e240afe63cd7d09d86a2c3ffd4c81b3226eb3c41275120654a`

### Features

- Each address can vote only once (anti-spam)
- Vote YES or NO
- Results are viewable via events (no heavy on-chain queries needed)
- Displays the current leading side

---

## 🚀 Usage Guide

### 1. Publish the Package

```bash
sui client switch --env testnet
```

```bash
sui client publish
```

**Sample Output:**

```
╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                               │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                             │
│  ┌──                                                                                                         │
│  │ ObjectID: 0x91a3a4175d2e0cc9caccaa2a5f3a20f2c063a28f6f63d1508d746523f377f5cf                              │
│  │ ObjectType: 0x8d5dd61...::pineapple_pizza_poll::PizzaPoll                                                 │
│  └──                                                                                                         │
│ Published Objects:                                                                                           │
│  ┌──                                                                                                         │
│  │ PackageID: 0x1272d1c6239601e240afe63cd7d09d86a2c3ffd4c81b3226eb3c41275120654a                             │
│  └──                                                                                                         │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

**Save these:**

- `PackageID` → use in `--package`
- `ObjectID` of the `PizzaPoll` object → use in `--args`

---

### 2. Vote YES 🍍

```bash
sui client call \
  --package 0x1272d1c6239601e240afe63cd7d09d86a2c3ffd4c81b3226eb3c41275120654a \
  --module pineapple_pizza_poll \
  --function vote_yes \
  --args 0x91a3a4175d2e0cc9caccaa2a5f3a20f2c063a28f6f63d1508d746523f377f5cf \
  --gas-budget 100000000
```

### 3. Vote NO ❌

```bash
sui client call \
  --package 0x1272d1c6239601e240afe63cd7d09d86a2c3ffd4c81b3226eb3c41275120654a \
  --module pineapple_pizza_poll \
  --function vote_no \
  --args 0x91a3a4175d2e0cc9caccaa2a5f3a20f2c063a28f6f63d1508d746523f377f5cf \
  --gas-budget 100000000
```

### 4. Voting Twice → Error E_ALREADY_VOTED

If the same address tries to vote again:

```bash
sui client call \
  --package 0x1272d1c6239601e240afe63cd7d09d86a2c3ffd4c81b3226eb3c41275120654a \
  --module pineapple_pizza_poll \
  --function vote_yes \
  --args 0x91a3a4175d2e0cc9caccaa2a5f3a20f2c063a28f6f63d1508d746523f377f5cf \
  --gas-budget 100000000
```

**Error Result:**

```
Error executing transaction 'DKtBo72P9M8cCo2S4fwtJYTqs1NE5M1jm6VVTnyYmyE7': 1st command aborted within function '0x1272d1c6239601e240afe63cd7d09d86a2c3ffd4c81b3226eb3c41275120654a::pineapple_pizza_poll::vote_no' at instruction 13 with code 1
```

> The code `1` corresponds to `E_ALREADY_VOTED` — you have already voted!

---

## 📊 View Results via Events

### View Topic

```bash
sui client call \
  --package 0x1272d1c6239601e240afe63cd7d09d86a2c3ffd4c81b3226eb3c41275120654a \
  --module pineapple_pizza_poll \
  --function emit_topic \
  --args 0x91a3a4175d2e0cc9caccaa2a5f3a20f2c063a28f6f63d1508d746523f377f5cf \
  --gas-budget 100000000
```

**Event Output:**

```json
{
  "type": "0x...::pineapple_pizza_poll::TopicEvent",
  "parsedJson": {
    "topic": "Does pineapple belong on pizza?"
  }
}
```

### View Vote Counts

```bash
sui client call \
  --package 0x1272d1c6239601e240afe63cd7d09d86a2c3ffd4c81b3226eb3c41275120654a \
  --module pineapple_pizza_poll \
  --function emit_votes \
  --args 0x91a3a4175d2e0cc9caccaa2a5f3a20f2c063a28f6f63d1508d746523f377f5cf \
  --gas-budget 100000000
```

**Event Output:**

```json
{
  "type": "0x...::pineapple_pizza_poll::VotesEvent",
  "parsedJson": {
    "yes": 5,
    "no": 3
  }
}
```

### View Current Leader

```bash
sui client call \
  --package 0x1272d1c6239601e240afe63cd7d09d86a2c3ffd4c81b3226eb3c41275120654a \
  --module pineapple_pizza_poll \
  --function emit_leader \
  --args 0x91a3a4175d2e0cc9caccaa2a5f3a20f2c063a28f6f63d1508d746523f377f5cf \
  --gas-budget 100000000
```

**Event Output (example when YES is leading):**

```json
{
  "type": "0x...::pineapple_pizza_poll::LeaderEvent",
  "parsedJson": {
    "message": "Pineapple lovers are winning! 🍍🍕"
  }
}
```

---

## 💡 Why Use Events?

> Emitting events is a simple and clear way to display results to users, frontends, or CLI tools — for example, you can listen to `Voted(address)` events in real-time without heavy on-chain queries.

---

## 📁 Project Structure

```
.
├── Move.toml                 # Package config
├── Pub.testnet.toml          # Metadata after publish
├── sources/
│   └── pineapple_pizza_poll.move   # Smart contract
└── README.md
```

---

## 🔗 References

- [Sui Move Documentation](https://docs.sui.io/concepts/sui-move-concepts)
- [Sui CLI Reference](https://docs.sui.io/references/cli/client)
