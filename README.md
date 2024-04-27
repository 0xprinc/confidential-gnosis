# Hardhat Template [![Open in Gitpod][gitpod-badge]][gitpod] [![Github Actions][gha-badge]][gha] [![Hardhat][hardhat-badge]][hardhat] [![License: MIT][license-badge]][license]

## Getting Started

Click the [`Use this template`](https://github.com/inco-fhevm/fhevm-hardhat-template/generate) button at the top of the
page to create a new repository with this repo as the initial state.

## Usage

### Pre Requisites

Install [pnpm](https://pnpm.io/installation)

Before being able to run any command, you need to create a `.env` file and set a BIP-39 compatible mnemonic as an
environment variable. If you don't already have a mnemonic, you can use this [website](https://iancoleman.io/bip39/) to
generate one. You can run the following command to use the example .env:

```sh
cp .env.example .env
```

Then, proceed with installing dependencies:

```sh
pnpm install
```

### Compile

Compile the smart contracts with Hardhat:

```sh
npx hardhat compile --network inco
```

### Deploy

Deploy the ERC20 to Inco Gentry Testnet Network:

```sh
npx hardhat deploy --network inco
```


### Test

Run the tests with Hardhat:

```sh
npx hardhat test --network inco
```

## License

This project is licensed under MIT.
