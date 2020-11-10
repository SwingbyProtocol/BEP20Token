# BEP20Token

## Requrements
- truffle v5.1.43 (Solidity v0.5.16 (solc-js), Node v14.8.0, Web3.js v1.2.1)
- ganache test rpc.

## Getting started
```
$ npm install 
```

## Deploy BEP-20 token
```
$ SEED=<your seed phrase> truffle migrate --network {development/bsc_testnet}
```
## Binding BEP20 token to BEP-2 token (for bsc_testnet)
Please have a look this [instuction](https://github.com/binance-chain/token-bind-tool#bind-bep2-token-with-bep20-token) and make sure all of requrements for binding.

### Step 1. Import your key to bnbcli
```
$ tbnbcli keys add owner --recover
```
### Step 2. BEP-2 token issue (example 1 billion tokens and symbol TESTONE-A43)
```
$ tbnbcli token issue --symbol TESTONE --token-name "TEST one token" --total-supply 100000000000000000 --from owner --chain-id Binance-Chain-Ganges --node http://data-seed-pre-0-s3.binance.org:80
```
### Step 3. BEP-20 token issue 
See the above command.
You have to check the following things before deploy token.
- Token symbol should have to same (if the BEP-2 token name is `SWINGBY-888`, symbol should be `SWINGBY`)
- Total supply should be same as BEP-2 token supply
- It may be better for tokens to disable the `mint` fucntion.

### Step 4. Make a binding tx for BC 
In thie case, the total supply is `100000000000000000`and `60000000000000000` 600 million BEP-2 tokens will be locked into the pure-code-controlled address on BC. then, `40000000000000000` 400 million BEP-20 tokens will be locked into the tokenManager contract on BSC.
```
$ tbnbcli bridge bind --symbol TESTONE-A43 --amount 60000000000000000 --expire-time <expiry time e.g. 1603011072> --contract-decimals 18 --from owner --chain-id Binance-Chain-Ganges --contract-address <your token contract address> --node http://data-seed-pre-0-s3.binance.org:80
```
### Step 5. Allowance tokens to token manager contract
```
$ SEED=<your seed phrase> AMOUNT=40000000000000000 truffle exec scripts/approveTokens.js --network bsc_testnet
```
### Step 6. Make a binding tx for BSC
```
$ SEED=<your seed phrase> SYMBOL=TESTONE-A43 truffle exec scripts/bindTokenContract.js --network bsc_testnet
```
### Step 7. Confirm bind result on BC
```
$ tbnbcli token info --symbol TESTONE-A43 --trust-node --node http://data-seed-pre-0-s3.binance.org:80
```

## TrasnferOut BSC from BC
```
$ tbnbcli bridge transfer-out --to <your bsc address> --expire-time <expiry time e.g. 1603011072> --chain-id Binance-Chain-Ganges --from owner --amount 20000000000:TESTONE-A43 --node http://data-seed-pre-0-s3.binance.org:80
```

## TransferOut BC from BSC 
```
$ AMOUNT=<your amount / 1e18 e.g. 0.1> TO=<your receiving address> truffle exec scripts/transferOutToBC.js --network bsc_testnet
```

## Test
```
$ truffle test
```
