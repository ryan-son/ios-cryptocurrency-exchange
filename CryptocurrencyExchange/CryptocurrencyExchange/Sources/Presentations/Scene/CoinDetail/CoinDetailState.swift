//
//  CoinDetailState.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

extension String {
    func symbolToName() -> String {
        return self.replacingOccurrences(of: "_KRW", with: "")
    }
}

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
