const Token = artifacts.require("Token");
const ITokenHub = artifacts.require("ITokenHub");
// The Address of token manager 
const tokenHubConctractAddr = "0x0000000000000000000000000000000000001004"
const BN = web3.utils.BN;
const bech32 = require('bech32-buffer');

module.exports = async function (done) {
   try {
      const token = await Token.deployed()
      const th = await ITokenHub.at(tokenHubConctractAddr)
      minRelayFee = "0.01"
      let value = web3.utils.toWei(minRelayFee, 'ether')
      let amount = web3.utils.toWei(process.env.AMOUNT, 'ether')
      let addr = bech32.decode(process.env.TO)
      let to = "0x" + Buffer.from(addr.data).toString('hex')
      let time = Math.floor(Date.now() / 1000) + 1000
      let approve = await token.approve(th.address, amount)
      console.log(approve.tx, "approved")
      let result = await th.transferOut(token.address, to, amount, time, {
         value: value
      })
      console.log(result.tx, "done")
      done()
   } catch (err) {
      console.log(err)
   }
}
