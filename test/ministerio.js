const Ministerio = artifacts.require("Ministerio");
const Academia = artifacts.require("Academia");

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
    this.accounts = await web3.eth.getAccounts();

    this.address = this.ministerio.address;
  });

  it("migrate deployed successfully", async () => {
    assert.notEqual(this.address, null);
    assert.notEqual(this.address, undefined);
    assert.notEqual(this.address, 0x0);
    assert.notEqual(this.address, "");
  });

  it("add permitidos", async () => {
    for (let i = 3; i < 6; i++) {
      await this.ministerio.funcAutorizarCuenta(this.accounts[i]);
    }
    // permitidos.forEach(async (permitido) => {
    //   await this.ministerio.funcAutorizarCuenta({ ...permitido });
    // });
    const permitidosAddress = await this.ministerio.funcPermitidos();
    assert.equal(permitidosAddress.length, 4);
    assert.equal(permitidosAddress[0], this.accounts[0]);
    assert.equal(permitidosAddress[1], this.accounts[3]);
    assert.equal(permitidosAddress[2], this.accounts[4]);
    assert.equal(permitidosAddress[3], this.accounts[5]);

    const permitido = await this.ministerio.mapPermitidos(this.address);
    assert.notEqual(this.address, false);
    assert.notEqual(this.accounts[3], false);
    assert.notEqual(this.accounts[4], false);
    assert.notEqual(this.accounts[5], false);
  });

  it("add academias", async () => {
    const mock = { nombre: "UNA", localidad: "Buenos Aires" };
    await this.ministerio.funcCrearAcademia(mock.nombre, mock.localidad);
    const cantidadAcademias = await this.ministerio.funcAcademias();
    const addressAcademia = cantidadAcademias[0];

    assert.equal(cantidadAcademias.length, 1);
    const mappingAcademia = await this.ministerio.accMapAcademias(
      this.accounts[0]
    );
    assert.equal(addressAcademia, mappingAcademia[0]);

    const academia = await Academia.at(mappingAcademia[0]);

    const name = await academia.nombreAcademia();
    const permitidos = await academia.accPermitido();
    const localidad = await academia.localidad();

    assert.equal(name, mock.nombre);
    assert.equal(permitidos[0], this.accounts[0]);
    assert.equal(localidad, mock.localidad);
  });
});
