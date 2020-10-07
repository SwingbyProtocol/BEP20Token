const MultiSendWallet = artifacts.require("MultiSendWallet");

module.exports = function (deployer, net, wallet) {
  deployer.deploy(MultiSendWallet, wallet[0]);
};
