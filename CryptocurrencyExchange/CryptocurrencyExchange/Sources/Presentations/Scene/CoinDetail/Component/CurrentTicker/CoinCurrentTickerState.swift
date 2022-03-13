//
//  CoinCurrentTickerState.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/13.
//

import Foundation

struct CoinCurrentTickerState: Equatable {
    let symbol: String
    var nowPrice: Double?
    var changeRate: Double?
    var changeAmount: Double?
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
        guard let nowPrice = nowPrice,
              let changeAmount = changeAmount,
              let changeRate = changeRate
        else {
            return CoinCurrentTickerViewState(
                currency: currencySymbol,
                name: coinSymbol,
                nowPrice: "",
                isPlus: false,
                changeAmountRate: ""
            )
        }
        let nowPriceFormatted = nowPrice.format(to: currency)
        let changeAmountFormatted = changeAmount.format(to: currency)
        let isPlus = changeRate >= 0
        let changeRateFormatted = isPlus ? "+\(changeRate)%" : "\(changeRate)%"
        let changeAmountRateFormatted = "\(changeAmountFormatted) (\(changeRateFormatted))"
        return CoinCurrentTickerViewState(
         currency: currencySymbol,
         name: coinSymbol,
         nowPrice: nowPriceFormatted,
         isPlus: isPlus,
         changeAmountRate: changeAmountRateFormatted
        )
    }
}
