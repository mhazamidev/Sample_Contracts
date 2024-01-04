// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceFeed {
    AggregatorV3Interface internal priceFeed;

    constructor() {}

    function getlatestPrice(
        address aggregatorAddress
    ) public view returns (int) {
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = AggregatorV3Interface(aggregatorAddress).latestRoundData();

        return price;
    }

    function getDecimal(
        address aggregatorAddress
    ) public view returns (uint8 decimals) {
        decimals = AggregatorV3Interface(aggregatorAddress).decimals();
    }

    /*
    Price Feed Aggregator addresses

    Goerli Testnet Aggregator

    BTC / ETH   :   0x779877A7B0D9E8603169DdbD7836e478b4624789  -   Decimals:   18
    BTC / USD   :   0xA39434A63A52E749F02807ae27335515BA4b07F7  -   Decimals:   8
    CZK / USD   :   0xAE45DCb3eB59E27f05C170752B218C6174394Df8  -   Decimals:   8
    DAI / USD   :   0x0d79df66BE487753B02D015Fb622DED7f0E9798d  -   Decimals:   8
    ETH / USD   :   0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e  -   Decimals:   8
    EUR / USD   :   0x44390589104C9164407A0E0562a9DBe6C24A0E05  -   Decimals:   8
    FORTH / USD :   0x7A65Cf6C2ACE993f09231EC1Ea7363fb29C13f2F  -   Decimals:   8
    GBP / USD   :   0x73D9c953DaaB1c829D01E1FC0bd92e28ECfB66DB  -   Decimals:   8
    JPY / USD   :   0x982B232303af1EFfB49939b81AD6866B2E4eeD0B  -   Decimals:   8
    LINK / ETH  :   0xb4c4a493AB6356497713A78FFA6c60FB53517c63  -   Decimals:   8
    LINK / USD  :   0x48731cF7e84dc94C5f84577882c14Be11a5B7456  -   Decimals:   8
    SNX / USD   :   0xdC5f59e61e51b90264b38F0202156F07956E2577  -   Decimals:   8
    USDC / USD  :   0xAb5c49580294Aff77670F839ea425f5b78ab3Ae7  -   Decimals:   8
    XAU / USD   :   0x7b219F57a8e9C7303204Af681e9fA69d17ef626f  -   Decimals:   18
    */
}
