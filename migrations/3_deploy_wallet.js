const MultiSendWallet = artifacts.require("MultiSendWallet");

module.exports = function (deployer) {
  deployer.deploy(MultiSendWallet);
};
