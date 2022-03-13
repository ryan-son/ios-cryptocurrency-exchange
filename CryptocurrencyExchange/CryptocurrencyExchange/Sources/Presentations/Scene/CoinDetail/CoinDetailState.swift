//
//  CoinDetailState.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

struct CoinDetailState: Equatable {
    let symbol: String
}

extension CoinDetailState {
    func toViewState() -> CoinDetailViewState {
        return CoinDetailViewState(
            name: symbol.symbolToName()
        )
    }
}

struct CoinDetailViewState {
    let name: String
}
