//
//  BithumbTransaction.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/28.
//

import Foundation

struct BithumbTransaction {
    let symbol: String
    let transactionType: BithumbTransactionType
    let contPrice: Double
    let contQuantity: Double
    let contAmount: Double
    let transactionDate: Date
    let priceUpDown: BithumbTransactionPriceUpDown
}

enum BithumbTransactionType: Int {
    case sell = 1
    case buy = 2
    case none = -1
}

enum BithumbTransactionPriceUpDown: String {
    case up
    case down = "dn"
    case none
}
