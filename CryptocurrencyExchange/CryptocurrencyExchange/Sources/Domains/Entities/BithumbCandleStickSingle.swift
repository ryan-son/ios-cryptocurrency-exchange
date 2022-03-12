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
    var asDateString: String {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: date / 1000)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
