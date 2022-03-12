//
//  CoinCandleChartState.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

import Foundation

struct CoinCandleChartState: Equatable {
    var symbol: String
    var dataEntries: [BithumbCandleStickDataSingle]?
}
