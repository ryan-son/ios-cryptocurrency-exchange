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

enum CoinListError: Equatable {
    case description(String)
}

extension CoinListError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .description(message):
            return message
        }
    }
}

struct CoinListState: Equatable {
    var items: IdentifiedArrayOf<CoinItemState>
    var selectedItem: Identified<CoinItemState.ID, CoinItemState>?
    var alert: AlertState<CoinListAction>?
    var toastMessage: String?
}

enum CoinListAction: Equatable {
    case coinItem(id: CoinItemState.ID, action: CoinItemAction)
    case coinItemTapped
    case onAppear
    case onDisappear
    case updateCoinItems(result: Result<[CoinItemState], CoinListError>)
    case showAlert(message: String)
    case dismissAlert
    case showToast(message: String)
}

struct CoinListEnvironment {
    let coinListUseCase: () -> CoinListUseCaseProtocol
    let toastClient: ToastClient
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
                state.items = IdentifiedArray(uniqueElements: items)
                return .none
            case let .failure(error):
                return Effect.merge(
                    Effect(value: .onAppear),
                    Effect(value: .showToast(message: "\(error.localizedDescription)"))
                )
            }
        case .coinItem:
            return .none
        case .coinItemTapped:
            return .none
        case .onAppear:
            return fetchTickers(environment: environment, cancelId: cancelId)
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
        case let .showToast(message):
            let model = ToastModel(duration: 3, message: message)
            return environment.toastClient.show(model)
                .fireAndForget()
        }
    }
)

fileprivate func fetchTickers(
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
        .eraseToAnyPublisher()
        .mapError { error in
            Log.error("Error: \(error)")
            // TODO: 오류 났을 때 처리 필요.
            return CoinListError.description("다시 연결 중...")
        }
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
            ZStack(alignment: .top) {
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
                if let toastMessage = viewStore.toastMessage {
                    ToastView(message: toastMessage)
                }
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
                    },
                    toastClient: .live
                )
            )
        )
            .preferredColorScheme(.dark)
    }
}
