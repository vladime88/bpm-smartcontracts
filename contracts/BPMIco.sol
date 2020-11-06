// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "./ERC2020.sol";

contract BPMIco {
    // Declare a FirstErc20 contract
    ERC2020 public token;

    // The price of 1 unit of our token in wei;
    uint256 public _price;

    // Address of token seller
    address payable private _seller;

    uint256 private _decimal;

    constructor(
        uint256 price,
        address payable seller,
        address ERC2020Address
    ) public {
        _price = price = 10**17;
        _seller = seller;
        _decimal = (10**uint256(token.decimals()));
        token = ERC2020(ERC2020Address);
    }

    receive() external payable {
        buy(msg.value / _price);
    }

    function buy(uint256 nbTokens) public payable returns (bool) {
        require(msg.value >= 0, "ICO: Price is not 0 ether");
        require(
            nbTokens * _price <= msg.value,
            "ICO: Not enough Ether for purchase"
        );
        uint256 _realPrice = nbTokens * _price;
        uint256 _remaining = msg.value - _realPrice;
        token.transferFrom(_seller, msg.sender, nbTokens);
        _seller.transfer(_realPrice);
        if (_remaining > 0) {
            msg.sender.transfer(_remaining);
        }
        return true;
    }
}
