const Migrations = artifacts.require("Migrations");

module.exports = function (deployer, net) {
  if (net !== "development") {
    return
  }
  deployer.deploy(Migrations);
};
