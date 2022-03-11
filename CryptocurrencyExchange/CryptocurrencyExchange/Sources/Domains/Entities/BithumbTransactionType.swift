//
//  BithumbTransactionType.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/10.
//

import Foundation

enum BithumbTransactionType {
    case sell
    case buy
    case none
}

extension BithumbTransactionType {
    static func from(value: String) -> BithumbTransactionType {
        switch value {
        case "ask":
            return .sell
        case "bid":
            return .buy
        default:
            return .none
        }
    }
    
    static func from(value: Int) -> BithumbTransactionType {
        switch value {
        case 1:
            return .sell
        case 2:
            return .buy
        default:
            return .none
        }
    }
}
