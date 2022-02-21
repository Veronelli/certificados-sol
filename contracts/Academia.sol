// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {arrayPlus} from "./Arrays.sol";
import "./Ministerio.sol";

contract Academia {
    string public nombreAcademia;
    address[] public permitidos;
    string public localidad;
    address public ministerioAddress;

    using arrayPlus for *;
    bool verificado;

    struct alumno {
        uint256 createdAt;
        bool asistencia;
    }

    address[] private alumnos;
    address contractMinisterio;

    mapping(address => alumno) mapAlumnos;
    mapping(address => bool) mapPermitidos;

    function getAddressAcademia()public view returns(address){
        return address(this);
    }

    // --------------------- Access array ---------------------
    function accPermitido() public view returns (address[] memory) {
        return permitidos;
    }

    function accAlumnos() public view returns (address[] memory) {
        return alumnos;
    }

    function getAlumnos(address _alumnoAddress) public view returns(alumno memory){
        return mapAlumnos[_alumnoAddress];
    }

    // --------------------- Events ---------------------
    event eventAcademiaCreada(address _permitido, address _contrato);
    event eventAltaCuenta(address _habilitador, address _habilitado);
    event eventBajarCuenta(address _desabilidator, address _desabilitado);

    event eventRegistrarAlumno(address _autorizado, address _alumno);
    event eventAltaAlumno(address _autorizado, address _alumno);
    event eventBajarAlumno(address _autorizado, address _alumno);

    event eventCertificadoCreado(address _emisor, address _academia, address _alumno);

    constructor(
        string memory _nombreAcademia,
        address _permitidos,
        string memory _localidad,
        address _contractMinistro
    ) {
        ministerioAddress = msg.sender;
        nombreAcademia = _nombreAcademia;
        permitidos.push(_permitidos);
        mapPermitidos[_permitidos] = true;
        localidad = _localidad;
        contractMinisterio = _contractMinistro;
        emit eventAcademiaCreada(_permitidos, address(this));
    }

    // --------------------- Modifiers ---------------------
    modifier isPermitido() {
        require(mapPermitidos[msg.sender] == true, "No estas autorizado");
        _;
    }

    modifier isAlumno(address _direccionAlumno){
        require(mapAlumnos[_direccionAlumno].asistencia == true,"El alumno no asiste al colegio");
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
        permitidos.remove(index);

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

    // To do and test
    function agregarCertificado(
        string memory _titulo,
        TipoCertificado _tipoCertificado,
        address _alumno
    ) isAlumno(_alumno) public {
        Ministerio ministerio = Ministerio(ministerioAddress);
        Certificado certificado = Certificado(ministerio.contractCertificado());
        certificado.createCertificado(_titulo,_alumno, _tipoCertificado);

        emit eventCertificadoCreado(msg.sender, address(this), _alumno);
    }
}
