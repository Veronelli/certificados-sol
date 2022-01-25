// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Certificado.sol";
import "./Academia.sol";
import {arrayPlus} from "./Arrays.sol";

contract Ministerio {
    // --------------------- Address ---------------------
    address[] academias;
    address[] permitidos;
    address owner;

    // --------------------- Mapping ---------------------
    mapping(address => bool) public mapPermitidos;
    mapping(address => Certificado[]) public mapCertificados;
    mapping(address => address[]) public mapAcademias;

    // --------------------- Events ---------------------
    event eventContractoCreado(address creado);
    event eventAltaCuenta(address habilitador, address habilitado);
    event eventBajaCuenta(address deshabilitador, address deshabilitado);

    event eventAltaAcademia(address habilitador, address academia);
    event eventBajaAcademia(address deshabilitador, address academia);

    // --------------------- Events ---------------------
    using arrayPlus for *;

    // --------------------- Modifiers ---------------------
    modifier isPermitido() {
        require(
            mapPermitidos[msg.sender] == true,
            "No estas habilidad para agregar otra cuenta que gestione las academias"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
        mapPermitidos[owner] = true;
        permitidos.push(owner);

        emit eventContractoCreado(owner);
    }

    // --------------------- Function ---------------------
    function altaCuenta(address _account) public isPermitido {
        mapPermitidos[_account] = true;
        permitidos.push(_account);

        emit eventAltaCuenta(msg.sender, _account);
    }

    function bajaCuenta(address _account) public isPermitido {
        mapPermitidos[_account] = false;
        uint256 index = permitidos.findIndex(_account);
        delete permitidos[index];

        emit eventBajaCuenta(msg.sender, _account);
    }

    function crearAcademia(
        string memory _nombre,
        address _director,
        string memory _localidad
    ) public {
        address direccion = address(
            new Academia(_nombre, _director, _localidad)
        );
        mapAcademias[msg.sender].push(direccion);

        emit eventAltaAcademia(msg.sender, direccion);
    }
}
