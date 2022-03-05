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

struct CoinListState: Equatable {
    var items: IdentifiedArrayOf<CoinItemState>
    var selectedItem: Identified<CoinItemState.ID, CoinItemState>?
    var cancellables: Set<AnyCancellable> = []
}

enum CoinListAction {
    case coinItem(id: CoinItemState.ID, action: CoinItemAction)
    case coinItemTapped
    case onAppear
}

struct CoinListEnvironment {
    let coinListUseCase: CoinListUseCaseProtocol
}

let coinListReducer = Reducer<
    CoinListState, CoinListAction, CoinListEnvironment
>.combine(
    coinItemReducer.forEach(
        state: \.items,
        action: /CoinListAction.coinItem(id:action:),
        environment: { _ in CoinItemEnvironment() }
    ),
    Reducer { state, action, environment in
        struct WebSocketId: Hashable {}

        switch action {
        case .coinItem:
            return .none
        case .coinItemTapped:
            return .none
        case .onAppear:
            let useCase = environment.coinListUseCase
            let symbolsPublisher = useCase.getTickerSinglePublisher().share()
            symbolsPublisher
                .flatMap {
                    useCase.getTickerStreamPublisher(
                        symbols: $0.map { $0.name + "_KRW" },
                        tickTypes: [.day]
                    )
                }
                .map { ticker in
                    CoinItemState(
                        name: ticker.symbol.replacingOccurrences(of: "_KRW", with: ""),
                        price: ticker.closePrice,
                        changeRate: ticker.changeRate,
                        isLiked: false,
                        symbol: ticker.symbol
                    )
                }
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
//                        case .complete:
//                            Log.debug("getTickerPublisher Completed")
                        case let .failure(error):
                            Log.error(error)
                        default:
                            Log.error("???????")
                        }
                    },
                    receiveValue: {
                        Log.debug($0)
                    }
                )
                .store(in: &state.cancellables)

            return .none
        }
    }
)

struct CoinListView: View {
    let store: Store<CoinListState, CoinListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                ForEachStore(
                    self.store.scope(
                        state: \.items,
                        action: CoinListAction.coinItem(id:action:)
                    ),
                    content: { itemStore in
                        NavigationLink(destination: {
                            CoinItemView(store: itemStore)
                        }) {
                            CoinItemView(store: itemStore)
                        }
                    }
                )
            }
            .listStyle(.plain)
            .buttonStyle(.plain)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
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
                    coinListUseCase: CoinListUseCase()
                )
            )
        )
            .preferredColorScheme(.dark)
    }
}
