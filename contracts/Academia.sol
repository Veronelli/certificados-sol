// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Academia {
    string nombreAcademia;
    address[] permitidos;
    string localidad;

    bool verificado;
    address[] alumnos;

    // --------------------- Events ---------------------
    event eventAcademiaCreada(address permitido, address contrato);

    constructor(
        string memory _nombreAcademia,
        address _permitidos,
        string memory _localidad
    ) {
        nombreAcademia = _nombreAcademia;
        permitidos.push(_permitidos);
        localidad = _localidad;

        emit eventAcademiaCreada(_permitidos, address(this));
    }
}
