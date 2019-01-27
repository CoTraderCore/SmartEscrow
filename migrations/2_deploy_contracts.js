const TokenA = artifacts.require("./TokenA");
const TokenB = artifacts.require("./TokenB");
const SmartEscrow = artifacts.require("./SmartEscrow");

module.exports = function(deployer) {
  const nameA = "Token A";
  const symbolA = "TKNA";
  const nameB = "Token B";
  const symbolB = "TKNB";
  const decimals = 18;
  const total = 1000000000000000000000000000;

  const KYBER_ADDRESS_ROPSTEN = '0x818E6FECD516Ecc3849DAf6845e3EC868087B755'


  deployer.deploy(TokenA, nameA, symbolA, decimals, total).then(async () => {

  await deployer.deploy(TokenB, nameB, symbolB, decimals, total);

  await deployer.deploy(SmartEscrow, KYBER_ADDRESS_ROPSTEN);
  })
};
