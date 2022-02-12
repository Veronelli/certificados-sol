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
        string titulo;
        bool verificado;
        TipoCertificado tipoCertificado;
        address propietario;
        uint fechaEmision;
        address academia;
    }

    address ministerioAddress;

    StructCertificado[] certificados;
    mapping(address => StructCertificado[]) alumnoCertificados;

    // --------------------- Variables ---------------------
    function getAlumnoCertificados(address _direccion)public view returns(StructCertificado[] memory){
        return alumnoCertificados[_direccion];
    }
    function getCertificados()public view returns(StructCertificado[] memory){
        return certificados;
    }

    constructor(address _owner) {
        ministerioAddress = _owner;
    }

    function createCertificado(
        string memory _titulo,
        address _alumno,
        TipoCertificado _tipoCertificado
    ) public {
        uint date = block.timestamp;

        address _academiaAddress = msg.sender;
        StructCertificado memory _certidicado = StructCertificado(_titulo,false,_tipoCertificado,_alumno,date,_academiaAddress);
        certificados.push(_certidicado);
        alumnoCertificados[_alumno].push(_certidicado);
    }
}
