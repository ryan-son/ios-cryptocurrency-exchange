//
//  BithumbTransactionHistroySingle.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import Foundation

struct BithumbTransactionHistroySingle {
    var symbol: String
    var transactionType: BithumbTransactionType
    var contDate: Date
    var contPrice: Double
    var contQuantity: Double
}

extension BithumbTransactionHistroySingle {
    func toTransactionItemState() -> TransactionItemState {
        return TransactionItemState(
            symbol: symbol,
            type: transactionType,
            contDate: contDate,
            contPrice: contPrice,
            contQuantity: contQuantity
        )
    }
}
