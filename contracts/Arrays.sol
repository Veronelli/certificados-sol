// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library arrayPlus {
    function findIndex(address[] memory _direcciones, address element)
        public
        pure
        returns (uint256)
    {
        for (uint256 i = 0; i < _direcciones.length; i++) {
            if (_direcciones[i] == element) {
                return i;
            }
        }
        return 0;
    }
}
