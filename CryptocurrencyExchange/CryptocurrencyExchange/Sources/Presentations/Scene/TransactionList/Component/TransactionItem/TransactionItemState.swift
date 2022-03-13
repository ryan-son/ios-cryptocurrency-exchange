//
//  TransactionItemState.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import SwiftUI

struct TransactionItemState: Equatable, Identifiable {
    var id = UUID()
    var symbol: String
    var type: BithumbTransactionType
    var contDate: Date
    var contPrice: Double
    var contQuantity: Double
}

extension TransactionItemState {
    func toViewState() -> TransactionItemViewState {
        let type: String
        let typeColor: Color
        switch self.type {
        case .sell:
            type = "매도"
            typeColor = .blue
        case .buy:
            type = "매수"
            typeColor = .red
        case .none:
            type = "None"
            typeColor = .yellow
        }
        let contDate = contDate.format(with: "HH:mm:ss")
        let symbols = symbol.components(separatedBy: "_")
        let nameSymbol = symbols.first ?? ""
        let currencySymbol = symbols.last ?? ""
        let currency = Currency(rawValue: currencySymbol.lowercased()) ?? .none
        let contPrice = contPrice.format(to: currency)
        let contQuantity = contQuantity.toSimpleString() + nameSymbol
        return TransactionItemViewState(
            type: type,
            typeColor: typeColor,
            contDate: contDate,
            contPrice: contPrice,
            contQuantity: contQuantity
        )
    }
}

struct TransactionItemViewState {
    var type: String
    var typeColor: Color
    var contDate: String
    var contPrice: String
    var contQuantity: String
}

fileprivate extension Double {
    func toSimpleString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = .max
        let number = NSNumber(value: self)
        return numberFormatter.string(from: number) ?? ""
    }
}
