//
//  CoinCandleStickChartView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/09.
//

import SwiftUI

import Charts
import ComposableArchitecture

struct CoinCandleChartView: View {
    let store: Store<CoinCandleChartState, CoinCandleChartAction>
    
    init(store: Store<CoinCandleChartState, CoinCandleChartAction>) {
        self.store = store
        let viewStore = ViewStore(store)
        viewStore.send(.onAppear)
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            IfLetStore(
                self.store.scope(state: \.dataEntries),
                then: { store in
                    CoinCandleChartRepresentable(viewStore: ViewStore(store))
                        .padding()
                },
                else: {
                    ProgressView()
                        .frame(maxHeight: .infinity)
                }
            )
        }
    }
}

struct CoinCandleStickChartView_Previews: PreviewProvider {
    static var previews: some View {
        CoinCandleChartView(
            store: Store(
                initialState: CoinCandleChartState(
                    symbol: "BTC_KRW"
                ),
                reducer: coinCandleChartReducer,
                environment: CoinCandleChartEnvironment(
                    candleChartUseCase: CoinCandleChartUseCase(),
                    tickerUseCase: { TickerUseCase() },
                    toastClient: .live
                )
            )
        )
            .preferredColorScheme(.dark)
    }
}
