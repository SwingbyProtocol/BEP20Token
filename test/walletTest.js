const MultiSendWallet = artifacts.require('MultiSendWallet');
const Token = artifacts.require('Token');
const MultiSendWalletFactory = artifacts.require("MultiSendWalletFactory")

const BN = web3.utils.BN;

contract('MultiSendWallet', async (accounts) => {
    it('Token deploy and checking the owner', async () => {
        try {
            let from = accounts[1];
            let wallet = await MultiSendWallet.new(from)
            let owner = await wallet.owner()
            assert.equal(owner, from);
        } catch (err) {
            console.log(err)
        }
    });
    it('Factory deploy and checking the owner', async () => {
        try {
            let from = accounts[1];
            let factory = await MultiSendWalletFactory.new()
            let deployed = await factory.deployNewWallet(from)
            let wallet = await MultiSendWallet.at(deployed.logs[0].args.wallet)
            let owner = await wallet.owner()
            assert.equal(owner, from);
        } catch (err) {
            console.log(err)
        }
    });
    it('multi transfer (multiTransferERC20TightlyPacked)', async () => {
        try {
            let token = await Token.new()
            // Defaut token decimals == 18
            let mintValue = web3.utils.toWei(new BN('1000000000'), 'ether')
            let from = accounts[0];
            let to = accounts[1];
            let to2 = accounts[2]
            let amount = web3.utils.toWei(new BN('500000000'), 'ether')

            let balanceFrom = await token.balanceOf(from);

            assert.equal(balanceFrom.toString(), mintValue.toString());

            let factory = await MultiSendWalletFactory.new()
            let deployed = await factory.deployNewWallet(from)
            let wallet = await MultiSendWallet.at(deployed.logs[0].args.wallet)
            let balanceTo = await token.balanceOf(to);
            let balanceTo2 = await token.balanceOf(to2);


            // Sending toknes to deployed contract wallet.
            await token.transfer(wallet.address, amount)

            let sendAmount = amount.div(new BN('2'))

            let send1 = "0x" + web3.utils.padLeft(sendAmount.toString('hex') + to.slice(2), 64)
            let send2 = "0x" + web3.utils.padLeft(sendAmount.toString('hex') + to2.slice(2), 64)
            // 0x00000001158e460913d00000943Bef1Fb2F25C43Ab4a010ae835E936d1A34fE1

            const txs = [
                send1, send2
            ]

            // Should be 32bytes hex if calling from golang
            const inputDecimals = 18

            let logs = await wallet.multiTransferERC20TightlyPacked(token.address, txs, inputDecimals, {
                from: from
            });

            // console.log(logs.logs)

            let updateBalanceWallet = await token.balanceOf(wallet.address);
            let updateBalanceTo = await token.balanceOf(to);
            let updateBalanceTo2 = await token.balanceOf(to2);

            // Wallet balance should be zero
            assert.equal(new BN('0').toString(), updateBalanceWallet.toString());
            assert.equal(balanceTo.add(sendAmount).toString(), updateBalanceTo.toString());
            assert.equal(balanceTo2.add(sendAmount).toString(), updateBalanceTo2.toString());
        } catch (err) {
            console.log(err)
        }
    });

})