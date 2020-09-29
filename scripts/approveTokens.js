const BEP20Token = artifacts.require("BEP20Token");
// The Address of token manager contract
const tokenManagerConctractAddr = "0x0000000000000000000000000000000000001008"
const BN = web3.utils.BN;

module.exports = async function () {
   try {
      const token = await BEP20Token.deployed()
      let amount = web3.utils.toWei(new BN(process.env.AMOUNT), 'wei')
      await token.approve(tokenManagerConctractAddr, amount)
   } catch (err) {
      console.log(err)
   }
}
