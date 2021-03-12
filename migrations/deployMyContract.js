const Migrations = artifacts.require("MyToken");

module.exports = function (deployer) {
  deployer.deploy(Migrations, 'BigCoin', 'BGC', '10000000000000000000000');
};

