const MultiSendWallet = artifacts.require('MultiSendWallet');
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

})