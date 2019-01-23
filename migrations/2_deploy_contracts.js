const Token = artifacts.require("./Token");
const SmartEscrow = artifacts.require("./SmartEscrow");

module.exports = function(deployer) {
  const nameA = "Token A";
  const symbolA = "TKNA";
  const nameB = "Token A";
  const symbolB = "TKNA";
  const decimals = 18;
  const total = 1000000000000000000000000000;


  deployer.deploy(Token, nameA, symbolA, decimals, total).then(async () => {

  await deployer.deploy(SmartEscrow);
  })
};
