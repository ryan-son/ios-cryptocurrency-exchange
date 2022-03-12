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
        CoinCandleChartView(
            store: Store(
                initialState: CoinCandleChartState(
                    symbol: "XRP_KRW"
                ),
                reducer: coinCandleChartReducer,
                environment: CoinCandleChartEnvironment(
                    useCase: CoinCandleChartUseCase(),
                    toastClient: .live
                )
            )
        )
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
