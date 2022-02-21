const Ministerio = artifacts.require("Ministerio");
const Academia = artifacts.require("Academia");
const Certificado = artifacts.require("Certificado")

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
    // address certificate storage
    const addressCertificado = await this.ministerio.contractCertificado();

    assert.notEqual(addressCertificado, null);
    assert.notEqual(addressCertificado, undefined);
    assert.notEqual(addressCertificado, 0x0);
    assert.notEqual(addressCertificado, "");

    // address contract
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

  it("delete permitir", async () => {
    const permitidos1 = await this.ministerio.funcPermitidos();
    await this.ministerio.bajaCuenta(this.accounts[3]);
    await this.ministerio.bajaCuenta(this.accounts[5]);
    const permitidos2 = await this.ministerio.funcPermitidos();

    assert.equal(permitidos2.length, 2);
    assert.notEqual(permitidos2.length, permitidos1.length);
  });

  it("add academias", async () => {
    const mock = [
      { nombre: "UNA", localidad: "Buenos Aires" },
      { nombre: "UBA", localidad: "Buenos Aires" },
    ];

    // Se crea nuevas acadeamias con distinatas cuentas
    await this.ministerio.funcCrearAcademia(mock[0].nombre, mock[0].localidad);
    await this.ministerio.funcCrearAcademia(mock[1].nombre, mock[1].localidad, {
      from: this.accounts[3],
    });

    const cantidadAcademias = await this.ministerio.funcAcademias();
    const addressAcademia = cantidadAcademias[0];

    assert.equal(cantidadAcademias.length, 2);
    const mappingAcademia = await this.ministerio.accMapAcademias(
      this.accounts[0]
    );
    assert.equal(addressAcademia, mappingAcademia[0]);

    const academia = await Academia.at(mappingAcademia[0]);

    const name = await academia.nombreAcademia();
    const permitidos = await academia.accPermitido();
    const localidad = await academia.localidad();

    assert.equal(name, mock[0].nombre);
    assert.equal(permitidos[0], this.accounts[0]);
    assert.equal(localidad, mock[0].localidad);
  });

  // Test Academia
  it("add permitidos address | Academia", async () => {
    const academiaAddress = await this.ministerio.accMapAcademias(
      this.accounts[0]
    );
    this.academia = await Academia.at(academiaAddress[0], {
      from: this.accounts[0],
    });
    await this.academia.altaCuenta(this.accounts[9]);
    await this.academia.altaCuenta(this.accounts[8]);
    await this.academia.altaCuenta(this.accounts[7]);

    const permitidos1 = await this.academia.accPermitido();

    assert.equal(permitidos1[0], this.accounts[0]);
    assert.equal(permitidos1[1], this.accounts[9]);
    assert.equal(permitidos1[2], this.accounts[8]);
    assert.equal(permitidos1[3], this.accounts[7]);
  });

  it("delete permitidos address | Academia",async()=>{
    await this.academia.bajarCuenta(this.accounts[8]);
    await this.academia.bajarCuenta(this.accounts[0]);
    const permitidos = await this.academia.accPermitido({from:this.accounts[4]});

    assert.equal(permitidos.length,2);
    assert.equal(permitidos[0],this.accounts[9]);
    assert.equal(permitidos[1],this.accounts[7]);

  })

  // Alta alumno
  it("add alumnos mapping | Academia",async()=>{
    await this.academia.registrarAlumno(this.accounts[6]);
    await this.academia.registrarAlumno(this.accounts[5]);
    await this.academia.registrarAlumno(this.accounts[2]);
    const alumnos = await this.academia.accAlumnos();

    assert.equal(alumnos.length,3);
    assert.equal(alumnos[0],this.accounts[6]);
    assert.equal(alumnos[1],this.accounts[5]);
    assert.equal(alumnos[2],this.accounts[2]);
  })

  it("unsubscribe alumno", async()=>{
    await this.academia.bajarAlumno(this.accounts[5]);
    await this.academia.bajarAlumno(this.accounts[2]);

    // unsubscribed
    const account1 = await this.academia.getAlumnos(this.accounts[5]);
    const account2 = await this.academia.getAlumnos(this.accounts[2]);
    
    // subscribe
    const account3 = await this.academia.getAlumnos(this.accounts[6]);

    assert.equal(account1[1],false);
    assert.equal(account2[1],false);
    assert.equal(account3[1],true);
  })

  it("subscribe alumno", async()=>{
    await this.academia.altaAlumno(this.accounts[5]);
    await this.academia.altaAlumno(this.accounts[2]);

    const account1 = await this.academia.getAlumnos(this.accounts[5]);
    const account2 = await this.academia.getAlumnos(this.accounts[2]);

    assert.equal(account1[1],true);
    assert.equal(account2[1],true);
  })

  it("add certificado | Academia",async()=>{
    await this.academia.agregarCertificado("Tecnico en Sistemas",4,this.accounts[5]);
    await this.academia.agregarCertificado("Programacion en super computadoras",3,this.accounts[5]);
    await this.academia.agregarCertificado("Liquidacion de sueldos",3,this.accounts[2]);

    // get Certidificado contract
    const contractCertificado = await this.ministerio.contractCertificado();
    this.certificado = await Certificado.at(contractCertificado);

    // test fiveth account
    const student1 = await this.certificado.getAlumnoCertificados(this.accounts[5]);
    assert.equal(student1.length,2);

    assert.equal(student1[0].titulo,"Tecnico en Sistemas");
    assert.equal(student1[0].verificado,false);
    assert.equal(student1[0].tipoCertificado,4);
    assert.equal(student1[0].propietario,this.accounts[5]);
    assert.equal(student1[0].academia,await this.academia.getAddressAcademia())

    assert.equal(student1[1].titulo,"Programacion en super computadoras");
    assert.equal(student1[1].verificado,false);
    assert.equal(student1[1].tipoCertificado,3);
    assert.equal(student1[1].propietario,this.accounts[5]);
    assert.equal(student1[1].academia,await this.academia.getAddressAcademia())

    // .. second account
    const student2 = await this.certificado.getAlumnoCertificados(this.accounts[2]);
    assert.equal(student2.length,1);

    assert.equal(student2[0].titulo,"Liquidacion de sueldos");
    assert.equal(student2[0].verificado,false);
    assert.equal(student2[0].tipoCertificado,3);
    assert.equal(student2[0].propietario,this.accounts[2  ]);
    assert.equal(student2[0].academia,await this.academia.getAddressAcademia())
    
  })

});
