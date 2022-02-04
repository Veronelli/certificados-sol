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

    struct StructCertificado {
        string titutlo;
        bool verificado;
        TipoCertificado tipoCertificado;
        bytes32 propietario;
        string fechaEmision;
        address academia;
    }

    address owner;

    StructCertificado[] certificados;
    mapping(address => StructCertificado[]) alumnoCertificado;

    function createCertificado(
        string memory _titulo,
        TipoCertificado _tipoCertificado,
        address _alumno,
        address _academia
    ) public {}
}
