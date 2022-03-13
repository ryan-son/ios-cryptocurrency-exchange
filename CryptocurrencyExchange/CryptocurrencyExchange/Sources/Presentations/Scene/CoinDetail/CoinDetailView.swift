//
//  CoinDetailView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

import SwiftUI

import ComposableArchitecture

struct CoinDetailView: View {
    let symbol: String

    var body: some View {
        VStack {
            priceAndNavigationView()
            graphView()
        }
        .navigationTitle("상세")
    }
}

extension CoinDetailView {
    func priceAndNavigationView() -> some View {
        CoinCurrentTickerView(
            store: Store(
                initialState: CoinCurrentTickerState(
                    symbol: symbol
                ),
                reducer: CoinCurrentTickerReducer,
                environment: CoinCurrentTickerEnvironment(
                    useCase: { TickerUseCase() }
                )
            )
        )
    }
    
    func graphView() -> some View {
        CoinCandleChartView(
            store: Store(
                initialState: CoinCandleChartState(
                    symbol: symbol
                ),
                reducer: coinCandleChartReducer,
                environment: CoinCandleChartEnvironment(
                    candleChartUseCase: CoinCandleChartUseCase(),
                    tickerUseCase: { TickerUseCase() },
                    toastClient: .live
                )
            )
        )
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(symbol: "BTC_KRW")
    }
}
