const Token = artifacts.require('Token');
const Staking = artifacts.require('Staking');

const BN = web3.utils.BN;

contract('Staking', async (accounts) => {
    it('Token issue and Staking test', async () => {
        try {
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

            let stake = await Staking.new(token.address)
            let amountToStake = web3.utils.toWei(new BN('10000'), 'ether')

            await token.approve(stake.address, amountToStake, {
                from: from
            });
            let timeHex = web3.utils.toHex(Math.floor(Date.now() / 1000))
            let timeHex32 = web3.utils.padLeft(timeHex, 64)
            let pubkeyHex32 = web3.utils.padLeft("0xc4b50e91d77878cefcb8467694503c5f9a74d49b0077316f327786c3abdfdc75", 64)
            let addressHex32 = web3.utils.padLeft(accounts[1], 64)
            let data = timeHex32 + pubkeyHex32.slice(2) + addressHex32.slice(2)
            // 0x000000000000000000000000000000000000000000000000000000005f846a50c4b50e91d77878cefcb8467694503c5f9a74d49b0077316f327786c3abdfdc75000000000000000000000000943Bef1Fb2F25C43Ab4a010ae835E936d1A34fE1

            //console.log(data)

            await stake.stake(amountToStake, data, { from: from })

            let nodeInfo = await stake.getNodeInfo(from)
            /**
             * Result {  '0': '0xc4b50e91d77878cefcb8467694503c5f9a74d49b0077316f327786c3abdfdc75', '1': '0x00000000000000000000000007385da2f4ebe2d2a6f837f3719952ea580301f5'}
             */

            //console.log(nodeInfo)
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