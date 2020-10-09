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
    it('multi transfer', async () => {
        try {
            let token = await Token.new()
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
            let owner = await wallet.owner()
            assert.equal(owner, from);
    
            let balanceTo = await token.balanceOf(to);
    
            let send1 = "0x" + web3.utils.padLeft(amount.toString('hex') + to.slice(2), 64)
    
            let send2 = "0x" + web3.utils.padLeft(amount.toString('hex') + to2.slice(2), 64)
            // 0x00000001158e460913d00000943Bef1Fb2F25C43Ab4a010ae835E936d1A34fE1
    
            // console.log(send1)
    
            const txs = [
                send1, send2
            ]
    
            let logs = await wallet.multiTransferERC20(txs, {
                from: from
            });
    
            // console.log(logs.logs)
    
            let updateBalanceFrom = await token.balanceOf(from);
            let updateBalanceTo = await token.balanceOf(to);
            let updateBalanceTo2 = await token.balanceOf(to2);
    
    
            assert.equal(mintValue.sub(amount).sub(amount).toString(), updateBalanceFrom.toString());
            assert.equal(balanceTo.add(amount).toString(), updateBalanceTo.toString());
            assert.equal(amount.toString(), updateBalanceTo2.toString());
        } catch (err) {
            console.log(err)
        }

    });

})