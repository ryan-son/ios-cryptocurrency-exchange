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
            priceAndNavigationView()
            graphView()
        }
        .navigationTitle("상세")
    }
}

extension CoinDetailView {
    func priceAndNavigationView() -> some View {
        WithViewStore(
            self.store.scope(state: \.symbol)
        ) { viewItemStore in
            CoinCurrentTickerView(
                store: Store(
                    initialState: CoinCurrentTickerState(
                        symbol: viewItemStore.state
                    ),
                    reducer: CoinCurrentTickerReducer,
                    environment: CoinCurrentTickerEnvironment(
                        useCase: TransactionListUseCase()
                    )
                )
            )
        }
    }
    
    func graphView() -> some View {
        WithViewStore(
            self.store.scope(state: \.symbol)
        ) { viewItemStore in
            CoinCandleChartView(
                store: Store(
                    initialState: CoinCandleChartState(
                        symbol: viewItemStore.state
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
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(
            store: Store(
                initialState: CoinDetailState(
                    symbol: "BTC_KRW"
                ),
                reducer: coinDetailReducer,
                environment: CoinDetailEnvironment()
            )
        )
    }
}
