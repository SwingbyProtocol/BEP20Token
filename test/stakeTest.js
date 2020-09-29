const BEP20Token = artifacts.require('BEP20Token');
const Staking = artifacts.require('Staking');

const BN = web3.utils.BN;

contract('Staking', async (accounts) => {
    it('Token issue and Staking test', async () => {
        try {
            let token = await BEP20Token.new()
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

            let stake = await Staking.new(token.address)
            let amountToStake = web3.utils.toWei(new BN('10000'), 'ether')

            await token.approve(stake.address, amountToStake, {
                from: from
            });
            let timeHex = web3.utils.toHex(Math.floor(Date.now() / 1000))
            let timeHex32 = web3.utils.padLeft(timeHex, 64)

            await stake.stake(amountToStake, timeHex32, { from: from })

            let StakedBalance = await stake.totalStakedFor(from);
            assert.equal(amountToStake.toString(), StakedBalance.toString());

            let stakeID = web3.utils.padLeft("0x0", 64)
            await stake.unstake(amountToStake, stakeID, { from: from })

            let NewStakedBalance = await stake.totalStakedFor(from);
            assert.equal(NewStakedBalance.toString(), "0");

        } catch (err) {
            console.log(err)
        }
    });
})