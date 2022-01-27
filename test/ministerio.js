const Ministerio = artifacts.require("Ministerio");
const Web3 = require("web3");
const fs = require("fs");
const path = require("path");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Ministerio", async () => {
  before(async () => {
    this.ministerio = await Ministerio.deployed();
    const web3 = new Web3(Web3.givenProvider || "ws://localhost:8545");
    this.accounts = await web3.eth.getAccounts;

    const file = JSON.parse(ministroFile);
  });
  it("migrate deployed successfully", async () => {
    console.log(this.ministerio1);
    const address = this.ministerio.address;
    assert.notEqual(address, null);
    assert.notEqual(address, undefined);
    assert.notEqual(address, 0x0);
    assert.notEqual(address, "");
  });

  it("add permitidos", async () => {
    for (let i = 3; i < 6; i++) {
      await this.ministerio.funcAutorizarCuenta(this.accounts[i]);
    }
    // permitidos.forEach(async (permitido) => {
    //   await this.ministerio.funcAutorizarCuenta({ ...permitido });
    // });
    const permitidosAddress = await this.ministerio.funcPermitido();
    assert.equal(permitidosAddress.length, 4);
    assert.equal(permitidosAddress[0], this.accounts[0]);
    assert.equal(permitidosAddress[1], this.accounts[3]);
    assert.equal(permitidosAddress[2], this.accounts[4]);
    assert.equal(permitidosAddress[3], this.accounts[5]);
  });

  it("add academias", async () => {});
});
