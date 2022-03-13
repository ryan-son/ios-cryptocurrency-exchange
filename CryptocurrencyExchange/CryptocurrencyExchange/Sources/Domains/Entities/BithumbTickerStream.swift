//
//  BithumbTickerStream.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/27.
//

import Foundation

/// Example Response (ticker)
/// https://apidocs.bithumb.com/docs/websocket_public
struct BithumbTickerStream: Equatable {
    /// 통화코드
    let symbol: String
    /// 변동 기준시간- 30M, 1H, 12H, 24H, MID
    let tickType: TickType
    /// 일자 및 시간
    let date: Date
    /// 시가
    let openPrice: Double
    /// 종가
    let closePrice: Double
    /// 저가
    let lowPrice: Double
    /// 고가
    let highPrice: Double
    /// 누적거래금액
    let value: Double
    /// 누적거래량
    let volume: Double
    /// 매도누적거래량
    let sellVolume: Double
    /// 매수누적거래량
    let buyVolume: Double
    /// 전일종가
    let previousClosePrice: Double
    /// 변동률
    let changeRate: Double
    /// 변동금액
    let changeAmount: Double
    /// 체결강도
    let volumePower: Double
}

extension BithumbTickerStream {
    func toCoinItemState(isLiked: Bool) -> CoinItemState {
        return CoinItemState(
            name: symbol.symbolToName(),
            price: closePrice,
            changeRate: changeRate,
            isLiked: isLiked,
            symbol: symbol
        )
    }
}

extension BithumbTickerStream {
    func toCoinCandleChartItemState() -> CoinCandleChartItemState {
        let date = date
        let openPrice = openPrice
        let closePrice = closePrice
        let lowPrice = lowPrice
        let highPrice = highPrice
        return CoinCandleChartItemState(
            date: date,
            openPrice: openPrice,
            closePrice: closePrice,
            lowPrice: lowPrice,
            highPrice: highPrice
        )
    }
}


