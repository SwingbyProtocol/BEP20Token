const Migrations = artifacts.require("Migrations");

module.exports = function (deployer, net, acc) {
  //console.log(acc[0])
  if (net !== "development") {
    return
  }
  //deployer.deploy(Migrations);
};
