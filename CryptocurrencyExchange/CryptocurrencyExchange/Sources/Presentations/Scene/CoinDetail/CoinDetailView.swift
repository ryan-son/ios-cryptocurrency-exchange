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
        WithViewStore(self.store) { viewStore in
            let viewState = viewStore.state.toViewState()
            VStack(alignment: .leading, spacing: 0) {
                Text("KRW")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                HStack(spacing: 8) {
                    Text(viewState.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    navigationButton(navigationButtonType: .transaction)
                    navigationButton(navigationButtonType: .orderbook)
                }
                Text("₩1,239,100")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("+₩1,450 (+3.0%)")
                    .font(.body)
                    .foregroundColor(.red)
            }
            .padding()
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

extension CoinDetailView {
    func navigationButton(
        navigationButtonType: NavigationButtonType
    ) -> some View {
        NavigationLink(
            destination: {
                WithViewStore(
                    self.store.scope(state: \.symbol)
                ) { viewItemStore in
                    OrderLayoutView(
                        store: Store(
                            initialState: OrderLayoutState(
                                symbol: viewItemStore.state,
                                selection: navigationButtonType.getTapBarItem()
                            ),
                            reducer: orderLayoutReducer,
                            environment: OrderLayoutEnvironment()
                        )
                    )
                }
            },
            label: {
                Text(navigationButtonType.label)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
            }
        )
    }
}

extension CoinDetailView {
    enum NavigationButtonType {
        case transaction
        case orderbook
        
        var label: String {
            switch self {
            case .transaction:
                return "체결"
            case .orderbook:
                return "호가"
            }
        }
        
        func getTapBarItem() -> OrderLayoutView.TapBarList {
            switch self {
            case .transaction:
                return .transaction
            case .orderbook:
                return .orderbook
            }
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
