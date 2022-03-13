//
//  CoinCurrentTickerView.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/13.
//

import SwiftUI

import ComposableArchitecture

struct CoinCurrentTickerView: View {
    let store: Store<CoinCurrentTickerState, CoinCurrentTickerAction>
    
    init(store: Store<CoinCurrentTickerState, CoinCurrentTickerAction>) {
        self.store = store
        let viewStore = ViewStore(store)
        viewStore.send(.onAppear)
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            let viewState = viewStore.state.toViewState()
            VStack(alignment: .leading, spacing: 0) {
                Text(viewState.currency)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                HStack(spacing: 8) {
                    Text(viewState.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    navigationButton(navigationButtonType: .transaction)
                    navigationButton(navigationButtonType: .orderBook)
                }
                Text(viewState.nowPrice)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(viewState.changeAmountRate)
                    .font(.body)
                    .foregroundColor(viewState.isPlus ? .red : .blue)
            }
            .padding()
        }
        .onDisappear {
            ViewStore(store).send(.onDisappear)
        }
    }
}

extension CoinCurrentTickerView {
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

extension CoinCurrentTickerView {
    enum NavigationButtonType {
        case transaction
        case orderBook
        
        var label: String {
            switch self {
            case .transaction:
                return "체결"
            case .orderBook:
                return "호가"
            }
        }
        
        func getTapBarItem() -> OrderLayoutView.TapBarList {
            switch self {
            case .transaction:
                return .transaction
            case .orderBook:
                return .orderBook
            }
        }
    }
}

struct CoinCurrentTickerView_Previews: PreviewProvider {
    static var previews: some View {
        CoinCurrentTickerView(
            store: Store(
                initialState: CoinCurrentTickerState(symbol: "BTC_KRW"),
                reducer: coinCurrentTickerReducer,
                environment: CoinCurrentTickerEnvironment(
                    useCase: TransactionUseCase()
                )
            )
        )
            .previewLayout(.sizeThatFits)
    }
}
