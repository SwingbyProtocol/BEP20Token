const Token = artifacts.require("Token");
// The Address of token manager contract
const tokenManagerConctractAddr = "0x0000000000000000000000000000000000001008"
const BN = web3.utils.BN;

module.exports = async function (done) {
   try {
      const token = await Token.deployed()
      let amount = web3.utils.toWei(new BN(process.env.AMOUNT).mul(new BN(1 * 10 ** 10)), 'wei')
      let result = await token.approve(tokenManagerConctractAddr, amount)
      console.log(result.tx)
      done()
   } catch (err) {
      console.log(err)
   }
}
