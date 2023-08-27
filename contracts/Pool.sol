//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./interfaces/IERC20.sol";
import "./interfaces/IPool.sol";

contract Pool is IPool{

    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;

    // total share
    uint public totalSupply;

    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1){
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address to, uint amount) private{
        totalSupply += amount;
        balanceOf[to] += amount;
    }

    function _burn(address from, uint amount) private{
        balanceOf[from] -= amount;
        totalSupply -= amount;
    }
    function _update(uint _reserve0, uint _reserve1) private{
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    function swap(address _tokenIn, uint256 _amountIn) override external returns (uint256 _amountOut){
        // check if tokenIn is token0 or token1
        require(_tokenIn == address(token0) || _tokenIn == address(token1), "Invalid token");
        require(_amountIn > 0, "Invalid amount");
        // if tokenIn is token0, then token1 is tokenOut
        // if tokenIn is token1, then token0 is tokenOut
        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint reserveIn, uint reserveOut) = isToken0 ? (token0, token1, reserve0, reserve1) : (token1, token0, reserve1, reserve0);
        // transfer tokenIn from msg.sender
        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        // get amountOut from formula
        // token out --- fee 0.3%
        uint amountInWithFee = (_amountIn * 997)/1000;
        // formula: yDx/(x+dx) = dy
        _amountOut = (reserveOut  * amountInWithFee) / (reserveIn + amountInWithFee);
        // update reserve0 and reserve1
        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
        // transfer tokenOut to msg.sender
        tokenOut.transfer(msg.sender, _amountOut);
    }

    function addLiquidity(uint _amount0, uint _amount1) override external returns(uint shares){
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        // dy/dx = y/x
        if(reserve0 > 0 && reserve1 > 0){
            require(_amount0 * reserve1 == _amount1 * reserve0, "dy/dx != y/x");
        }

        if (totalSupply == 0) {
            shares = _sqrt(_amount0 * _amount1);
        } else {
            shares = _min(
                (_amount0 * totalSupply) / reserve0,
                (_amount1 * totalSupply) / reserve1
            );
        }
        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);

        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
            
    }

    function removeLiquidity(
        uint _shares
    ) override external returns (uint amount0, uint amount1) {
        
        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));

        amount0 = (_shares * bal0) / totalSupply;
        amount1 = (_shares * bal1) / totalSupply;
        require(amount0 > 0 && amount1 > 0, "amount0 or amount1 = 0");

        _burn(msg.sender, _shares);
        _update(bal0 - amount0, bal1 - amount1);

        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);
    }



    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }




    function _sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    

}

