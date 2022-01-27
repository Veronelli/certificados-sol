// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Academia {
    string public nombreAcademia;
    address[] public permitidos;
    string public localidad;

    bool verificado;
    address[] alumnos;

    // --------------------- Access array ---------------------
    function accPermitido() public view returns (address[] memory) {
        return permitidos;
    }

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

    // --------------------- Functions ---------------------
}
