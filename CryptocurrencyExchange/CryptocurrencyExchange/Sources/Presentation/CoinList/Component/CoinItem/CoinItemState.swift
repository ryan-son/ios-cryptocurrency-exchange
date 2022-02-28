//
//  CoinItemState.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/01.
//

import ComposableArchitecture

struct CoinItemState: Equatable {
    var name: String
    var price: Double
    var changeRate: Double
    var isPlus: Bool
    var isLiked: Bool
    var symbol: String
}

extension CoinItemState {
    func toViewState() -> CoinItemViewState {
        return CoinItemViewState(
            name: name,
            price: price.format(to: .won),
            changeRate: isPlus ? "+\(changeRate)%" : "-\(changeRate)%",
            isPlus: isPlus,
            isLiked: isLiked,
            symbol: symbol
        )
    }
}

struct CoinItemViewState {
    var name: String
    var price: String
    var changeRate: String
    var isPlus: Bool
    var isLiked: Bool
    var symbol: String
}
