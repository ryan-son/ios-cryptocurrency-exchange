//
//  CoinPriceError.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/13.
//

import Foundation

enum CoinPriceError: Error, Equatable {
    case description(String)
}

extension CoinPriceError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .description(message):
            return message
        }
    }
}
