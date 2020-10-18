const Token = artifacts.require("Token");
const tokenManager = artifacts.require("ITokenManager");
// The Address of token manager 
const tokenManagerConctractAddr = "0x0000000000000000000000000000000000001008"
const BN = web3.utils.BN;

module.exports = async function (done) {
   try {
      const token = await Token.deployed()
      const tm = await tokenManager.at(tokenManagerConctractAddr)
      miniRelayFee = "0.01"
      let value = web3.utils.toWei(miniRelayFee, 'ether')
      let result = await tm.approveBind(token.address, process.env.SYMBOL, {
         value: value
      })
      console.log(result.tx)
      done()
   } catch (err) {
      console.log(err)
   }
}
