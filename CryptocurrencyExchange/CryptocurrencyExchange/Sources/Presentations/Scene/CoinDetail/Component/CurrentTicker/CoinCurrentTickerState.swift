//
//  CoinCurrentTickerState.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/13.
//

import Foundation

struct CoinCurrentTickerState: Equatable {
    let symbol: String
    var nowPrice: Double = 0
    var changeRate: Double = 0
    var changeAmount: Double = 0
}

struct CoinCurrentTickerViewState: Equatable {
    let currency: String
    let name: String
    let nowPrice: String
    let isPlus: Bool
    let changeAmountRate: String
}

extension CoinCurrentTickerState {
    func toViewState() -> CoinCurrentTickerViewState {
        let symbols = symbol.components(separatedBy: "_")
        let coinSymbol = symbols.first ?? ""
        let currencySymbol = symbols.last ?? ""
        let currency = Currency(rawValue: currencySymbol.lowercased()) ?? .none
        let nowPrice = nowPrice.format(to: currency)
        let changeAmount = changeAmount.format(to: currency)
        let isPlus = changeRate >= 0
        let changeRate = isPlus ? "+\(changeRate)%" : "\(changeRate)%"
        let changeAmountRate = "\(changeAmount) (\(changeRate))"
        return CoinCurrentTickerViewState(
         currency: currencySymbol,
         name: coinSymbol,
         nowPrice: nowPrice,
         isPlus: isPlus,
         changeAmountRate: changeAmountRate
        )
    }
}
