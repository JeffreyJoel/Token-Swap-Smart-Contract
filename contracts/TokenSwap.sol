// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSwap is Ownable {
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public reserveA;
    uint256 public reserveB;

    constructor(IERC20 _tokenA, IERC20 _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    
    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than 0");
        uint256 sqrtK = sqrt(reserveA * reserveB);
        uint256 newReserveA = reserveA + amountA;
        uint256 newReserveB = (sqrtK * newReserveA) / reserveA - 1;
        reserveA = newReserveA;
        reserveB = newReserveB;
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);
    }

  
    function removeLiquidity(uint256 liquidity) external {
        require(liquidity > 0, "Liquidity must be greater than 0");
        uint256 amountA = (liquidity * reserveA) / (reserveA + reserveB);
        uint256 amountB = (liquidity * reserveB) / (reserveA + reserveB);
        reserveA -= amountA;
        reserveB -= amountB;
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
    }

   
    function swapAToB(uint256 amountA) external {
        require(amountA > 0, "Amount must be greater than 0");
        uint256 amountB = (reserveB * amountA) / reserveA;
        require(amountB > 0, "Not enough liquidity");
        reserveA += amountA;
        reserveB -= amountB;
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transfer(msg.sender, amountB);
    }

 
    function swapBToA(uint256 amountB) external {
        require(amountB > 0, "Amount must be greater than 0");
        uint256 amountA = (reserveA * amountB) / reserveB;
        require(amountA > 0, "Not enough liquidity");
        reserveB += amountB;
        reserveA -= amountA;
        tokenB.transferFrom(msg.sender, address(this), amountB);
        tokenA.transfer(msg.sender, amountA);
    }

  
    function getExchangeRateAToB(uint256 amountA) external view returns (uint256) {
        require(amountA > 0, "Amount must be greater than 0");
        return (reserveB * amountA) / reserveA;
    }

    function getExchangeRateBToA(uint256 amountB) external view returns (uint256) {
        require(amountB > 0, "Amount must be greater than 0");
        return (reserveA * amountB) / reserveB;
    }

    
    function getTotalLiquidity() external view returns (uint256) {
        return reserveA + reserveB;
    }

    function sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }
}
