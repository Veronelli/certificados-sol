// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {arrayPlus} from "./Arrays.sol";

contract Academia {
    string public nombreAcademia;
    address[] public permitidos;
    string public localidad;

    using arrayPlus for *;
    bool verificado;

    struct alumno {
        uint256 createdAt;
        bool asistencia;
    }

    address[] alumnos;
    mapping(address => alumno) mapAlumnos;
    mapping(address => bool) mapPermitidos;

    // --------------------- Access array ---------------------
    function accPermitido() public view returns (address[] memory) {
        return permitidos;
    }

    function accAlumnos() public view returns (address[] memory) {
        return alumnos;
    }

    // --------------------- Events ---------------------
    event eventAcademiaCreada(address _permitido, address _contrato);
    event eventAltaCuenta(address _habilitador, address _habilitado);
    event eventBajarCuenta(address _desabilidator, address _desabilitado);

    event eventRegistrarAlumno(address _autorizado, address _alumno);
    event eventAltaAlumno(address _autorizado, address _alumno);
    event eventBajarAlumno(address _autorizado, address _alumno);

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
    modifier isPermitido() {
        require(mapPermitidos[msg.sender] == true, "No estas autorizado");
        _;
    }

    // --------------------- Functions ---------------------
    function altaCuenta(address _direccion) public isPermitido {
        permitidos.push(_direccion);
        mapPermitidos[_direccion] = true;

        emit eventAltaCuenta(msg.sender, _direccion);
    }

    function bajarCuenta(address _direccion) public isPermitido {
        uint256 index = permitidos.findIndex(_direccion);
        delete permitidos[index];
        mapPermitidos[_direccion] = false;

        emit eventBajarCuenta(msg.sender, _direccion);
    }

    function registrarAlumno(address _direccion) public isPermitido {
        alumno memory infoAlumno = alumno(block.timestamp, true);
        mapAlumnos[_direccion] = infoAlumno;
        alumnos.push(_direccion);

        emit eventRegistrarAlumno(msg.sender, _direccion);
    }

    function bajarAlumno(address _direccion) public isPermitido {
        mapAlumnos[_direccion].asistencia = false;

        emit eventBajarAlumno(msg.sender, _direccion);
    }

    function altaAlumno(address _direccion) public isPermitido {
        mapAlumnos[_direccion].asistencia = true;

        emit eventAltaAlumno(msg.sender, _direccion);
    }
}
