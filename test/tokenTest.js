const Token = artifacts.require('Token');
const BN = web3.utils.BN;

contract('Token', async (accounts) => {
    it('transfer', async () => {
        let token = await Token.new()
        let mintValue = web3.utils.toWei(new BN('1000000000'), 'ether')
        let from = accounts[0];
        let to = accounts[1];
        let amount = web3.utils.toWei(new BN('20'), 'ether')

        let balanceFrom = await token.balanceOf(from);

        assert.equal(balanceFrom.toString(), mintValue.toString());

        let balanceTo = await token.balanceOf(to);

        await token.transfer(to, amount, {
            from: from
        });

        let updateBalanceFrom = await token.balanceOf(from);
        let updateBalanceTo = await token.balanceOf(to);

        assert.equal(mintValue.sub(amount).toString(), updateBalanceFrom.toString());
        assert.equal(balanceTo.add(amount).toString(), updateBalanceTo.toString());
    });
    // it('Contract paused', async () => {
    //     let decimals = 18
    //     let mintValue = web3.utils.toWei(new BN('1000000000'), 'ether')
    //     let token = await Token.new()

    //     let from = accounts[0];

    //     let balanceFrom = await token.balanceOf(from);

    //     assert.equal(balanceFrom.toString(), mintValue.toString());

    //     await token.setPaused(true)

    //     let to = accounts[1];
    //     let amount = web3.utils.toWei(new BN('20'), 'ether')

    //     await token.transfer(to, amount, {
    //         from: from
    //     }).catch((err) => {
    //         assert.isObject(err, "passed")
    //     });

    //     await token.approve(to, amount, {
    //         from: from
    //     }).catch((err) => {
    //         assert.isObject(err, "passed")
    //     });

    //     await token.increaseAllowance(to, amount, {
    //         from: from
    //     }).catch((err) => {
    //         assert.isObject(err, "passed")
    //     });
    //     await token.decreaseAllowance(to, amount, {
    //         from: from
    //     }).catch((err) => {
    //         assert.isObject(err, "passed")
    //     });

    //     await token.mint(to, amount, {
    //         from: from
    //     }).catch((err) => {
    //         assert.isObject(err, "passed")
    //     });
    // })
    it('token mint', async () => {
        let token = await Token.new()
        let mintValue = web3.utils.toWei(new BN('1000000000'), 'ether')
        let from = accounts[0];
        let amount = web3.utils.toWei(new BN('20'), 'ether')

        let balanceFrom = await token.balanceOf(from);

        assert.equal(balanceFrom.toString(), mintValue.toString());

        await token.mint(amount, {
            from: from
        })

        await token.mint(amount, {
            from: accounts[2]
        }).catch((err) => {
            assert.notEqual(err, null)
        });

        let updateBalanceFrom = await token.balanceOf(from);

        assert.equal(balanceFrom.add(amount).toString(), updateBalanceFrom.toString());
    });
})