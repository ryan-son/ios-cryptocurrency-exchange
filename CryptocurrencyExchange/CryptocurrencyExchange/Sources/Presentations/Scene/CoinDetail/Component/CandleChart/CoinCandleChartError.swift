//
//  CoinCandleChartError.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/13.
//

import Foundation

enum CoinCandleChartError: Equatable {
    case description(String)
}

extension CoinCandleChartError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .description(message):
            return message
        }
    }
}
