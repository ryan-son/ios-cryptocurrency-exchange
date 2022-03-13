//
//  CoinListView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/01.
//

import Combine
import SwiftUI

import ComposableArchitecture
import IdentifiedCollections

struct CoinListView: View {
    let store: Store<CoinListState, CoinListAction>
    
    var body: some View {
        ZStack(alignment: .top) {
            List {
                ForEachStore(
                    self.store.scope(
                        state: \.items,
                        action: CoinListAction.coinItem(id:action:)
                    )
                ) { itemStore in
                    WithViewStore(
                        self.store.scope(state: \.selectedItem)
                    ) { selectedItemViewStore in
                        WithViewStore(itemStore) { itemViewStore in
                            NavigationLink(
                                tag: itemViewStore.symbol,
                                selection: selectedItemViewStore.binding(
                                    get: { $0?.id },
                                    send: { CoinListAction.setCoinDetailViewSelection(symbol: $0) }
                                ),
                                destination: {
                                    IfLetStore(
                                        self.store.scope(
                                            state: \.selectedItem?.value,
                                            action: CoinListAction.coinDetail
                                        ),
                                        then: CoinDetailView.init,
                                        else: ProgressView.init
                                    )
                                },
                                label: { CoinItemView(store: itemStore) }
                            )
                        }
                    }
                }
            }
            .listStyle(.plain)
            .buttonStyle(.plain)
            .onAppear {
                ViewStore(store).send(.onAppear)
            }
            .onDisappear {
                ViewStore(store).send(.onDisappear)
            }
            WithViewStore(
                store.scope(state: \.toastMessage)
            ) { viewStore in
                if let toastMessage = viewStore.state {
                    ToastView(message: toastMessage)
                }
            }
        }
        .navigationTitle("목록")
    }
}

extension IdentifiedArray where ID == CoinItemState.ID, Element == CoinItemState {
    static let mock: Self = [
        CoinItemState(
            rank: nil,
            name: "비트코인",
            price: 78427482.42,
            changeRate: 1.24,
            isLiked: false,
            symbol: "BTC_USD"
        ),
        CoinItemState(
            rank: nil,
            name: "이더리움",
            price: 78427482.42,
            changeRate: -1.24,
            isLiked: true,
            symbol: "ETH_USD"
        )
    ]
}

struct CoinListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView(
            store: Store(
                initialState: CoinListState(items: .mock),
                reducer: coinListReducer,
                environment: CoinListEnvironment(
                    tickerUseCase: { TickerUseCase() },
                    toastClient: .live
                )
            )
        )
            .preferredColorScheme(.dark)
    }
}
