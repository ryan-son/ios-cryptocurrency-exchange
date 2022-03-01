//
//  ContentView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//
import Combine
import SwiftUI

import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        CoinItemView(
            store: Store(
                initialState: CoinItemState(
                    rank: nil,
                    name: "비트코인",
                    price: 78427482.42,
                    changeRate: 1.24,
                    isLiked: true,
                    symbol: "BTC_KRW"
                ),
                reducer: coinItemReducer,
                environment: CoinItemEnvironment()
            )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
