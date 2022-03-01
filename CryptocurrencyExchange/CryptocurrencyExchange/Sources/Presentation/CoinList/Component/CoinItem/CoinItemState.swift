//
//  CoinItemState.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/01.
//

import ComposableArchitecture

struct CoinItemState: Equatable {
    var rank: Int?
    var name: String
    var price: Double
    var changeRate: Double
    var isLiked: Bool
    var symbol: String // "BTC_KRW"
}

extension CoinItemState {
    func toViewState() -> CoinItemViewState {
        let rank = rank != nil ? "\(rank!)" : nil
        let symbols = symbol.components(separatedBy: "_")
        let coinSymbol = symbols.first ?? ""
        let currencySymbol = symbols.last ?? ""
        let isPlus = changeRate >= 0
        let changeRate = isPlus ? "+\(changeRate)%" : "\(changeRate)%"
        let currency = Currency(rawValue: currencySymbol.lowercased()) ?? .none
        let formattedPrice = price.format(to: currency)
        let imageURL = URL(
            string: "https://cryptoicon-api.vercel.app/api/icon/\(coinSymbol.lowercased())"
        )
        
        return CoinItemViewState(
            rank: rank,
            name: name,
            price: formattedPrice,
            changeRate: changeRate,
            isPlus: isPlus,
            isLiked: isLiked,
            symbol: symbol,
            imageURL: imageURL
        )
    }
}

struct CoinItemViewState {
    var rank: String?
    var name: String
    var price: String
    var changeRate: String
    var isPlus: Bool
    var isLiked: Bool
    var symbol: String
    var imageURL: URL?
}
