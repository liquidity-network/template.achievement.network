# Template

## Requirements
+ NodeJS
+ Windows, Linux or MacOS

## Installation

To run this website, you first need to install gitbook
```sh
npm install gitbook-cli -g
git clone https://github.com/liquidity-network/plugin-exercises ../plugin-exercises
cd ../plugin-exercises
npm install
npm link
cd -
npm link gitbook-plugin-exercises
gitbook install
```

## Run locally

### Local blockchain

1. Follow the instruction of [Ganache](https://truffleframework.com/ganache/) to run a local blockchain

2. Run `Ganache`, select and account and copy paste its private key into a file (e.g. `private.key`) as follow:
```txt
PRIVATE_KEY=...
```

3. Run
```sh
source private.key
PRIVATE_KEY=${PRIVATE_KEY} make debug
```

4. Website is located under `http://localhost:4000`

### On Ropsten

1. Save the private key associated to your ropsten account in a file named `private.key` as follow:
```text
PRIVATE_KEY=...
```

2. Run
```sh
source private.key
PRIVATE_KEY=${PRIVATE_KEY} make build
```

3. Website has been saved in `_book`. You can host it anywhere you want (Github pages for instance).

### Write Mode

If you only need to verify your syntax and not test it on a real blockchain

1. Set your private key to `0x0` (optional)
```text
PRIVATE_KEY=0x0000000000000000000000000000000000000000
```

2. Run
```sh
source private.key
PRIVATE_KEY=${PRIVATE_KEY} make write
```

3. Website is located under `http://localhost:4000`
