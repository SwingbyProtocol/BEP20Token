const Migrations = artifacts.require("Migrations");

module.exports = function (deployer, net) {
  if (net == "bsc_testnet") {
    return
  }
  deployer.deploy(Migrations);
};
