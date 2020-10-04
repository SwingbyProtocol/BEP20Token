const BEP20Token = artifacts.require("BEP20Token");
// The Address of token manager contract
const BN = web3.utils.BN;

module.exports = async function () {
   try {
      const token = await BEP20Token.deployed()
      let amount = web3.utils.toWei(new BN('1000'), 'ether')
      await token.transfer(process.env.TO, amount)
   } catch (err) {
      console.log(err)
   }
}
