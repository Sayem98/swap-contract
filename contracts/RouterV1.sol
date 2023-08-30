//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./interfaces/IPool.sol";
/*
    will contain 4 pools...
    $PACO-BTCB
    $PACO-USDT
    $PACO-BUSD
    $PACO-BNB

    BTCB-$PACO
    USDT-$PACO
    BUSD-$PACO
    BNB-$PACO
    
*/
contract RouterV1{

    IPool public pool1; //$PACO-BTCB <--> BTCB-$PACO
    IPool public pool2; //$PACO-USDT <--> USDT-$PACO
    IPool public pool3; //$PACO-BUSD <--> BUSD-$PACO
    IPool public pool4; //$PACO-BNB <--> BNB-$PACO
    
    // leter we will thing about making this dynamic

    // Initializer of the contract
    constructor(address _pool1, address _pool2, address _pool3, address _pool4){
        pool1 = IPool(_pool1);
        pool2 = IPool(_pool2);
        pool3 = IPool(_pool3);
        pool4 = IPool(_pool4);
    }

    function swap(address _pool, uint _amountIn, address _tokenIn) external {
        
        require(_pool == address(pool1) || _pool == address(pool2) || _pool == address(pool3) || _pool == address(pool4), "Invalid pool");
        require(_amountIn > 0, "Invalid amount");

        if(_pool == address(pool1)){
            pool1.swap(_tokenIn, _amountIn);
        }
        else if(_pool == address(pool2)){
            pool2.swap(_tokenIn, _amountIn);
        }
        else if(_pool == address(pool3)){
            pool3.swap(_tokenIn, _amountIn);
        }   
        else if(_pool == address(pool4)){
            pool4.swap(_tokenIn, _amountIn);
        }
    }

    function addLiquidity(
        address _pool,
        uint _amount0,
        uint _amount1
    ) external returns(uint shares){
        require(_pool == address(pool1) || _pool == address(pool2) || _pool == address(pool3) || _pool == address(pool4), "Invalid pool");
        if(_pool == address(pool1)){
            shares = pool1.addLiquidity(_amount0, _amount1);
        }
        else if(_pool == address(pool2)){
            shares = pool2.addLiquidity(_amount0, _amount1);
        }
        else if(_pool == address(pool3)){
            shares = pool3.addLiquidity(_amount0, _amount1);
        }   
        else if(_pool == address(pool4)){
            shares = pool4.addLiquidity(_amount0, _amount1);
        }
    }

    function removeLiquidity(
        address _pool,
        uint _shares
    )  external returns (uint amount0, uint amount1){
        require(_pool == address(pool1) || _pool == address(pool2) || _pool == address(pool3) || _pool == address(pool4), "Invalid pool");
        if(_pool == address(pool1)){
            (amount0, amount1) = pool1.removeLiquidity(_shares);
        }
        else if(_pool == address(pool2)){
            (amount0, amount1) = pool2.removeLiquidity(_shares);
        }
        else if(_pool == address(pool3)){
            (amount0, amount1) = pool3.removeLiquidity(_shares);
        }   
        else if(_pool == address(pool4)){
            (amount0, amount1) = pool4.removeLiquidity(_shares);
        }
    }
    

}