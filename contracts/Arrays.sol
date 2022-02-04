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

    function remove(address[] storage permitidos, uint256 index) internal {
        for (uint256 i = index; i < permitidos.length - 1; i++) {
            permitidos[i] = permitidos[i + 1];
        }

        permitidos.pop();
    }
}
