//
//  TransactionItemState.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import Foundation

struct TransactionItemState: Equatable, Identifiable {
    var id = UUID()
    var symbol: String
    var contDate: Date
    var contPrice: Double
    var contQuantity: Double
}


extension TransactionItemState {
    func toViewState() -> TransactionItemViewState {
        let contDate = contDate.format(with: "HH:mm:ss")
        let symbols = symbol.components(separatedBy: "_")
        let currencySymbol = symbols.last ?? ""
        let currency = Currency(rawValue: currencySymbol.lowercased()) ?? .none
        let contPrice = contPrice.format(to: currency)
        let contQuantity = String(format: "%.8f", contQuantity)

        return TransactionItemViewState(
            contDate: contDate,
            contPrice: contPrice,
            contQuantity: contQuantity
        )
    }
}

struct TransactionItemViewState {
    var contDate: String
    var contPrice: String
    var contQuantity: String
}

extension Date {
    func format(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
