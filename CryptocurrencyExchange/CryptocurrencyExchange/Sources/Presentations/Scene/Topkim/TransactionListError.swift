//
//  TransactionListError.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/11.
//

import Foundation

enum TransactionListError: Equatable {
    case description(String)
}

extension TransactionListError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .description(message):
            return message
        }
    }
}
