const Web3 = require("web3");

contract("Swap", function (accounts) {
  beforeEach("should setup the contract instance", async () => {
    btcb = await artifacts.require("BTCB").deployed();
    paco = await artifacts.require("PACO").deployed();
    pool = await artifacts.require("Pool").deployed();
    router = await artifacts.require("RouterV1").deployed();
  });
  it("should mint 100 BTCB to accounts[0]", async function () {
    await btcb.mint(accounts[0], Web3.utils.toWei("100", "ether"));

    const balance = await btcb.balanceOf(accounts[0]);
    assert.equal(Web3.utils.fromWei(balance.toString(), "ether"), 100);
  });
  it("should mint 100 PACO to accounts[0]", async function () {
    await paco.mint(accounts[0], Web3.utils.toWei("100", "ether"));

    const balance = await paco.balanceOf(accounts[0]);
    assert.equal(Web3.utils.fromWei(balance.toString(), "ether"), 100);
  });

  it("should provide liquidity", async function () {
    // check balance before BTCB and PACO
    const balanceBTCB = await btcb.balanceOf(accounts[0]);
    const balancePACO = await paco.balanceOf(accounts[0]);
    assert.equal(
      Web3.utils.fromWei(balanceBTCB.toString(), "ether"),
      Web3.utils.fromWei(balancePACO.toString(), "ether")
    );

    // approve
    await btcb.approve(pool.address, balanceBTCB, {
      from: accounts[0],
    });
    await paco.approve(pool.address, balancePACO, {
      from: accounts[0],
    });
    const share = await pool.addLiquidity(balanceBTCB, balancePACO, {
      from: accounts[0],
    });
    const balanceShare = await pool.balanceOf(accounts[0]);
    console.log(
      "balanceShare: ",
      Web3.utils.fromWei(balanceShare.toString(), "ether")
    );
  });

  it("should swap BTCB to PACO", async function () {
    // mint 10 token BTCB
    await btcb.mint(accounts[0], Web3.utils.toWei("10", "ether"));
    // approve
    await btcb.approve(pool.address, Web3.utils.toWei("10", "ether"), {
      from: accounts[0],
    });
    // swap
    await pool.swap(btcb.address, Web3.utils.toWei("10", "ether"), {
      from: accounts[0],
    });
    assert(true, "swap success");
  });
});
