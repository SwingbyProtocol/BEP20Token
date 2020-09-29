const BEP20Token = artifacts.require("BEP20Token");

module.exports = function (deployer) {
  deployer.deploy(BEP20Token);
};
