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
[token-bind-tool](https://github.com/binance-chain/token-bind-tool#bind-bep2-token-with-bep20-token)
Please have a look this instuction and make sure all of requrements for binding before starting the process. 

### Step 1. Import your key to bnbcli
```
$ tbnbcli keys add owner --recover
```
### Step 2. BEP-2 token issue
```
$ tbnbcli token issue --symbol TEST-999 --token-name "TEST token" --mintable --total-supply 10000000000000000 --from owner --chain-id Binance-Chain-Ganges --node http://data-seed-pre-0-s3.binance.org:80
```
### Step 3. BEP-20 token issue (see above, symbol should be same)
### Step 4. Make a binding tx for BC 
```
$ tbnbcli bridge bind --symbol TEST-999 --amount 6000000000000000 --expire-time <expiry time> --contract-decimals 18 --from owner --chain-id Binance-Chain-Ganges --contract-address <your token contract address> --node http://data-seed-pre-0-s3.binance.org:80
```
### Step 5. Allowance tokens to token manager contract
```
$ SEED=<your seed phrase> AMOUNT=4000000000000000 truffle exec scripts/approveTokens.js --network {development/bsc_testnet} 
```
### Step 6. Make a binding tx for BSC
```
$ SEED=<your seed phrase> truffle exec scripts/bindTokenContract.js --network {development/bsc_testnet}
```
 
## Test
```
$ truffle test
```
