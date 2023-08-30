// get the contracts to deploy
const Pool = artifacts.require("Pool");
const RouterV1 = artifacts.require("RouterV1");
const BTCB = artifacts.require("BTCB");
const PACO = artifacts.require("PACO");

module.exports = async function (deployer, network, accounts) {
  // deploy BTCB
  await deployer.deploy(BTCB);
  const btcb = await BTCB.deployed();
  console.log("BTCB address: ", btcb.address);

  // deploy PACO
  await deployer.deploy(PACO);
  const paco = await PACO.deployed();
  console.log("PACO address: ", paco.address);

  await deployer.deploy(Pool, btcb.address, paco.address);
  const pool = await Pool.deployed();
  console.log("Pool address: ", pool.address);
  // deploy FactoryV1
  await deployer.deploy(
    RouterV1,
    pool.address,
    pool.address,
    pool.address,
    pool.address
  );
  const router = await RouterV1.deployed();
  console.log("FactoryV1 address: ", router.address);
};
