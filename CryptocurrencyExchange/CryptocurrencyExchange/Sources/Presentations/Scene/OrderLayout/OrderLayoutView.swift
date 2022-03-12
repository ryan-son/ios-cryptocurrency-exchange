//
//  OrderLayoutView.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/12.
//

import SwiftUI

import ComposableArchitecture

struct OrderLayoutView: View {
    let store: Store<OrderLayoutState, OrderLayoutAction>
    @Namespace private var tapBar
    @Namespace private var animation
    
    var body: some View {
        VStack {
            TapBarView()
            WithViewStore(
                store.scope(state: \.selection)
            ) { selectionStore in
                content(tapBar: selectionStore.state)
            }
        }
    }
}

extension OrderLayoutView {
    func TapBarView() -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .offset(y: -1)
            HStack {
                ForEach(TapBarList.allCases, id: \.self) { tapBarItem in
                    Button(action: {
                        withAnimation {
                        ViewStore(store).send(.tapBarTapped(tapBarItem))
                        }
                    }) {
                        WithViewStore(
                            store.scope(state: \.selection)
                        ) { selectionStore in
                            ZStack(alignment: .bottom) {
                                Text(tapBarItem.label)
                                    .font(.title2)
                                    .fontWeight(
                                        selectionStore.state == tapBarItem ? .bold : .regular
                                    )
                                    .padding(10)
                            
                                if selectionStore.state == tapBarItem {
                                    Rectangle()
                                        .frame(height: 3)
                                        .padding(.horizontal, 20)
                                        .matchedGeometryEffect(id: tapBar, in: animation)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

extension OrderLayoutView {
    
    @ViewBuilder
    func content(tapBar: TapBarList) -> some View {
        switch tapBar {
        case .transaction:
            WithViewStore(
                store.scope(state: \.symbol)
            ) { symbol in
                TransactionListView(
                    store: Store(
                        initialState: TransactionListState(
                            symbol: symbol.state,
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
            
        case .orderbook:
            WithViewStore(
                store.scope(state: \.symbol)
            ) { symbol in
                OrderBookListView(
                    store: Store(
                        initialState: OrderBookListState(
                            symbol: symbol.state
                        ),
                        reducer: orderBookListReducer,
                        environment: OrderBookListEnvironment(
                            useCase: OrderBookListUseCase()
                        )
                    )
                )
            }
        }
    }
}

extension OrderLayoutView {
    enum TapBarList: Equatable, CaseIterable {
        case transaction
        case orderbook
        
        var label: String {
            switch self {
            case .transaction:
                return "체결내역"
            case .orderbook:
                return "호가"
            }
        }
    }
}

struct OrderLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        OrderLayoutView(
            store: Store(
                initialState: OrderLayoutState(symbol: "BTC_KRW"),
                reducer: orderLayoutReducer,
                environment: OrderLayoutEnvironment()
            )
        )
    }
}
