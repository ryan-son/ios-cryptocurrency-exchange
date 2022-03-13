//
//  CoinDetailView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

import SwiftUI

import ComposableArchitecture

struct CoinDetailView: View {
    let store: Store<CoinDetailState, CoinDetailAction>

    var body: some View {
        VStack {
            WithViewStore(
                self.store.scope(state: \.symbol)
            ) { symbolViewStore in
                CoinCurrentTickerView(
                    store: Store(
                        initialState: CoinCurrentTickerState(
                            symbol: symbolViewStore.state
                        ),
                        reducer: coinCurrentTickerReducer,
                        environment: CoinCurrentTickerEnvironment(
                            useCase: TransactionUseCase()
                        )
                    )
                )
                CoinCandleChartView(
                    store: Store(
                        initialState: CoinCandleChartState(
                            symbol: symbolViewStore.state
                        ),
                        reducer: coinCandleChartReducer,
                        environment: CoinCandleChartEnvironment(
                            candleChartUseCase: CoinCandleChartUseCase(),
                            tickerUseCase: { TickerUseCase() },
                            toastClient: .live)
                    )
                )
            }
        }
        .navigationTitle("상세")
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(
            store: Store(
                initialState: CoinDetailState(
                    symbol: "BTC_KRW"
//                    coinCurrentTicker: CoinCurrentTickerState(symbol: "BTC_KRW"),
//                    coinCandleChart: CoinCandleChartState(symbol: "BTC_KRW")
                ),
                reducer: coinDetailReducer,
                environment: CoinDetailEnvironment()
            )
        )
    }
}
