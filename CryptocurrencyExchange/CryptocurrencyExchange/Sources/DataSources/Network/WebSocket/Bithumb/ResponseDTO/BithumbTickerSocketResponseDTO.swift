//
//  BithumbTickerTypeResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/27.
//

import Foundation

/// Example Response (ticker)
/// https://apidocs.bithumb.com/docs/websocket_public
struct BithumbTickerSocketResponseDTO: Decodable {
    let type: BithumbWebSocketTopicType
    let content: Ticker
    
    struct Ticker: Decodable {
        let symbol, tickType, date, time: String
        let openPrice, closePrice, lowPrice, highPrice: String
        let value, volume, sellVolume, buyVolume: String
        let prevClosePrice, chgRate, chgAmt, volumePower: String
    }
}

extension BithumbTickerSocketResponseDTO.Ticker {
    func toDomain() -> BithumbTickerStream {
        return BithumbTickerStream(
            symbol: symbol,
            tickType: TickType(rawValue: tickType) ?? .none,
            date: (date + time).toDate(format: .yyyyMMddHHmmss) ?? Date(),
            openPrice: Double(openPrice) ?? 0,
            closePrice: Double(closePrice) ?? 0,
            lowPrice: Double(lowPrice) ?? 0,
            highPrice: Double(highPrice) ?? 0,
            value: Double(value) ?? 0,
            volume: Double(volume) ?? 0,
            sellVolume: Double(sellVolume) ?? 0,
            buyVolume: Double(buyVolume) ?? 0,
            previousClosePrice: Double(prevClosePrice) ?? 0,
            changeRate: Double(chgRate) ?? 0,
            changeAmount: Double(chgAmt) ?? 0,
            volumePower: Double(volumePower) ?? 0
        )
    }
}
