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
            HStack {
                WithViewStore(self.store) { viewStore in
                    let viewState = viewStore.state.toViewState()
                    VStack(alignment: .leading) {
                        Text("KRW")
                            .font(.caption)
                            .fontWeight(.semibold)
                        HStack {
                            Text(viewState.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink(
                                destination: {
                                    WithViewStore(
                                        self.store.scope(state: \.symbol)
                                    ) { viewItemStore in
                                        TransactionListView(
                                            store: Store(
                                                initialState: TransactionListState(
                                                    symbol: viewItemStore.state,
                                                    items: []
                                                ),
                                                reducer: transcationListReducer,
                                                environment: TransactionListEnvironment(
                                                    transactionListUseCase: {
                                                        TransactionListUseCase()
                                                    },
                                                    toastClient: .live
                                                )
                                            )
                                        )
                                    }
                                },
                                label: {
                                    Text("체결")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(8)
                                }
                            )
                            Spacer()
                                .frame(width: 8)
                            NavigationLink(
                                destination: {
                                    WithViewStore(
                                        self.store.scope(state: \.symbol)
                                    ) { viewItemStore in
                                        OrderBookListView(
                                            store: Store(
                                                initialState: OrderBookListState(
                                                    symbol: viewItemStore.state
                                                ),
                                                reducer: orderBookListReducer,
                                                environment: OrderBookListEnvironment(
                                                    useCase: OrderBookListUseCase()
                                                )
                                            )
                                        )
                                    }
                                },
                                label: {
                                    Text("호가")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(8)
                                }
                            )
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
            Spacer()
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
        .navigationTitle("상세")
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
