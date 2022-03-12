//
//  BithumbCandleStickSingle.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/10.
//

import Foundation

import Charts

struct BithumbCandleStickSingle {
    let data: [BithumbCandleStickDataSingle]
}

struct BithumbCandleStickDataSingle: Equatable {
    let date: Double
    let openPrice: Double
    let closePrice: Double
    let lowPrice: Double
    let highPrice: Double
    let transactionVolume: Double
}

extension BithumbCandleStickDataSingle {
    func toDataEntry() -> CandleChartDataEntry {
        return CandleChartDataEntry(
            x: date,
            shadowH: highPrice,
            shadowL: lowPrice,
            open: openPrice,
            close: closePrice
        )
    }
}
