const BEP20 = artifacts.require("BEP20Token");

module.exports = function (deployer) {
  deployer.deploy(BEP20);
};
