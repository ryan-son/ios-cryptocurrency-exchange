//
//  CoinListError.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/12.
//

import Foundation

enum CoinListError: Equatable {
    case description(String)
}

extension CoinListError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .description(message):
            return message
        }
    }
}
