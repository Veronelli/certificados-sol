// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
enum TipoCertificado {
    Ingenieria,
    Doctorado,
    Master,
    Comun,
    Tecnico,
    Licenciatura,
    Abogacia
}

contract Certificado {
    struct StructCertificado {
        string titutlo;
        bool verificado;
        TipoCertificado tipoCertificado;
        address propietario;
        string fechaEmision;
        address academia;
    }

    address owner;

    StructCertificado[] certificados;
    mapping(address => StructCertificado[]) alumnoCertificado;

    constructor(address _owner) {
        owner = _owner;
    }

    function createCertificado(
        string memory _titulo,
        address _alumno,
        address _academia
    ) public {}
}
