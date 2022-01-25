const Arrays = artifacts.require("arrayPlus");
const Ministerio = artifacts.require("Ministerio");
const Academia = artifacts.require("Academia");
const Certificado = artifacts.require("Certificado");

module.exports = function (_deployer, network) {
  // Use deployer to state migration tasks.
  if ((network = "live")) {
    console.log("Unfolding the contracts");
    _deployer.deploy(Arrays);
    _deployer.link(Arrays, Ministerio);
    _deployer.deploy(Ministerio);
  } else {
    console.log("The network is not allow");
  }
};
