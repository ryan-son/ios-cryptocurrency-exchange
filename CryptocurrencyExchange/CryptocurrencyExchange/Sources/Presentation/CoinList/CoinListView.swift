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
    var alert: AlertState<CoinListAction>?
}

enum CoinListAction: Equatable {
    case coinItem(id: CoinItemState.ID, action: CoinItemAction)
    case coinItemTapped
    case onAppear
    case onDisappear
    // TODO: Error Equatable 채택 안되는 문제 처리 필요.
    case updateCoinItems(result: Result<[CoinItemState], NSError>)
    case showAlert(message: String)
    case dismissAlert
}

struct CoinListEnvironment {
    let coinListUseCase: () -> CoinListUseCaseProtocol
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
        struct CancelId: Hashable {}
        let cancelId = CancelId()
        switch action {
        case let .updateCoinItems(result):
            switch result {
            case let .success(items):
                // TODO: 문제 없는지 확인.
                state.items = IdentifiedArray(uniqueElements: items)
                return .none
            case let .failure(error):
                return Effect(value: .showAlert(message: error.localizedDescription))
            }
        case .coinItem:
            return .none
        case .coinItemTapped:
            return .none
        case .onAppear:
            return logic(environment: environment, cancelId: cancelId)
        case .onDisappear:
            return .cancel(id: cancelId)
        case let .showAlert(message):
            state.alert = .init(
                title: .init("알림"),
                message: .init(message),
                dismissButton: .default(.init("확인"))
            )
            return .none
        case .dismissAlert:
            state.alert = nil
            return .none
        }
    }
)

fileprivate func logic(
    environment: CoinListEnvironment,
    cancelId: AnyHashable
) -> Effect<CoinListAction, Never> {
    var coinItemStates = [CoinItemState]()
    let useCase = environment.coinListUseCase()
    return useCase.getTickerSinglePublisher()
        .map { tickers in
            tickers.map { ticker in
                ticker.toCoinItemState(isLiked: false)
            }
        }
        .handleEvents(
            receiveOutput: {
                coinItemStates = $0
            }
        )
        .flatMap {
            useCase.getTickerStreamPublisher(
                symbols: $0.map { $0.symbol },
                tickTypes: [.day]
            )
        }
        .map { ticker in
            ticker.toCoinItemState(isLiked: false)
        }
        .map { updateState -> [CoinItemState] in
            // TODO: Dictionary 로 사용 시 cancel 안되는 문제 확인 필요.
            var updateState = updateState
            guard let index = coinItemStates.firstIndex(
                where: {
                    $0.symbol == updateState.symbol
                }
            ) else {
                return coinItemStates
            }
            updateState.id = coinItemStates[index].id
            coinItemStates[index] = updateState
            return coinItemStates
        }
        .map {
            $0.sorted(by: {
                $0.price > $1.price
            })
        }
//        .tryMap{ _ in
//            throw NSError(domain: "테스트에러", code: 1, userInfo: [NSLocalizedDescriptionKey : "테스트 오류 입니다."])
//        }
        .eraseToAnyPublisher()
        // TODO: 사용자 정의 에러 필요.
        .mapError({ _ in
            return NSError(domain: "테스트에러", code: 1, userInfo: [NSLocalizedDescriptionKey : "테스트 오류 입니다."])
        })
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
        .catchToEffect()
        .map(CoinListAction.updateCoinItems(result:))
        .cancellable(id: cancelId, cancelInFlight: true)
}

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
            .alert(store.scope(state: \.alert), dismiss: CoinListAction.dismissAlert)
            .listStyle(.plain)
            .buttonStyle(.plain)
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
                
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
                    coinListUseCase: {
                        CoinListUseCase()
                    }
                )
            )
        )
            .preferredColorScheme(.dark)
    }
}
