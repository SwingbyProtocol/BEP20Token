const BEP20Token = artifacts.require("Token");

module.exports = function (deployer) {
  deployer.deploy(BEP20Token);
};
