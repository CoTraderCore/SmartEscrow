const Token = artifacts.require("./Token");
const SmartEscrow = artifacts.require("./SmartEscrow");

module.exports = function(deployer) {
  const nameA = "Token A";
  const symbolA = "TKNA";
  const nameB = "Token A";
  const symbolB = "TKNA";
  const decimals = 18;
  const total = 1000000000000000000000000000;

  const KYBER_ADDRESS_ROPSTEN = '0x818E6FECD516Ecc3849DAf6845e3EC868087B755'


  deployer.deploy(Token, nameA, symbolA, decimals, total).then(async () => {

  await deployer.deploy(SmartEscrow, KYBER_ADDRESS_ROPSTEN);
  })
};
