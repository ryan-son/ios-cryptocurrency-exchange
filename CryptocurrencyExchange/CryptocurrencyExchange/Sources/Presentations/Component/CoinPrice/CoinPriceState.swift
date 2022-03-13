//
//  CoinPriceState.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/12.
//

import Foundation

struct CoinPriceState: Equatable {
    let symbol: String
    var nowPrice: Double?
}

extension CoinPriceState {
    func toViewState() -> OrderBookListViewState {
        let symbols = symbol.components(separatedBy: "_")
        let coinSymbol = symbols.first ?? ""
        let currencySymbol = symbols.last ?? ""
        let currency = Currency(rawValue: currencySymbol.lowercased()) ?? .none
        let formattedPrice = nowPrice?.format(to: currency) ?? ""
        let imageURL = URL(
            string: "https://cryptoicon-api.vercel.app/api/icon/\(coinSymbol.lowercased())"
        )
        return OrderBookListViewState(
            symbolName: coinSymbol,
            nowPrice: formattedPrice,
            imageURL: imageURL
        )
    }
}

struct OrderBookListViewState {
    let symbolName: String
    var nowPrice: String
    let imageURL: URL?
}
