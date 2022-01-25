// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Certificado {
    enum TipoCertificado {
        Ingenieria,
        Doctorado,
        Master,
        Comun,
        Tecnico,
        Licenciatura,
        Abogacia
    }

    struct structCertificado {
        string titutlo;
        bool verificado;
        TipoCertificado tipoCertificado;
        bytes32 propietario;
        string fechaEmision;
        address academia;
        bytes32 certificadoSeed;
    }

    constructor() {}
}
