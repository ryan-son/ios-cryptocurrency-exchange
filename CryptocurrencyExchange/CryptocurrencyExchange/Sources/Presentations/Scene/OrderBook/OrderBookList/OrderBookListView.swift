//
//  OrderBookListView.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/09.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct OrderBookListView: View {
    let store: Store<OrderBookListState, OrderBookListAction>
    
    init(store: Store<OrderBookListState, OrderBookListAction>) {
        self.store = store
        let viewStore = ViewStore(store)
        viewStore.send(.onAppear)
    }
    
    var body: some View {
        VStack {
            WithViewStore(
                store.scope(state: \.coinPriceState)
            ) { coinPriceStore in
                CoinPriceView(
                    store: Store(
                        initialState: coinPriceStore.state,
                        reducer: coinPriceReducer,
                        environment: CoinPriceEnvironment(
                            useCase: TransactionListUseCase()
                        )
                    )
                )
            }
            HStack {
                Text("판매 잔여 수량")
                Spacer()
                Text("구매 잔여 수량")
            }
            .padding(.horizontal, 20)
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        WithViewStore(
                            store.scope(state: \.orderBooks)
                        ) { orderBooksViewStore in
                            ForEach(orderBooksViewStore.state, id: \.self) { orderBookState in
                                OrderBookView(
                                    orderBookItem: orderBookState.toViewItem()
                                )
                            }
                        }
                    }
                    .frame(minHeight: 1100)
                    .id(1)
                    .onAppear {
                        proxy.scrollTo(1, anchor: .center)
                    }
                }
            }
        }
        .padding(.horizontal)
        //        .onAppear {
        //            ViewStore(store).send(.onAppear)
        //        }
        .onDisappear {
            ViewStore(store).send(.onDisappear)
        }
        .navigationTitle("호가")
    }
}

struct OrderBookListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookListView(
            store: Store(
                initialState: OrderBookListState(
                    symbol: "BTC_KRW"
                ),
                reducer: orderBookListReducer,
                environment: OrderBookListEnvironment(
                    useCase: OrderBookListUseCase()
                )
            )
        )
            .preferredColorScheme(.dark)
    }
}
