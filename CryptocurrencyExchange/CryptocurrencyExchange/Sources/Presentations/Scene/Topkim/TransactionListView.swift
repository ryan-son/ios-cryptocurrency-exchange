//
//  TransactionListView.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import Combine
import SwiftUI

import ComposableArchitecture
import IdentifiedCollections

enum TransactionListError: Equatable {
    case description(String)
}

extension TransactionListError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .description(message):
            return message
        }
    }
}

struct TransactionListState: Equatable {
    var symbol: String
    var items: IdentifiedArrayOf<TransactionItemState>
    var toastMessage: String?
}

enum TransactionListAction: Equatable {
    case transactionItem(id: TransactionItemState.ID, action: TransactionItemAction)
    case onAppear
    case onDisappear
    case updateTransactionItems(result: Result<[TransactionItemState], TransactionListError>)
}

struct TransactionListEnvironment {
    let transactionListUseCase: () -> TransactionListUseCaseProtocol
    let toastClient: ToastClient
}

let transcationListReducer = Reducer<
    TransactionListState, TransactionListAction, TransactionListEnvironment
>.combine(
    Reducer { state, action, environment in
        struct CancelId: Hashable {}
        let cancelId = CancelId()
        switch action {
        case let .updateTransactionItems(result):
            switch result {
            case let .success(items):
                state.items = IdentifiedArray(uniqueElements: items)
                return .none
            case let .failure(error):
                return .none
            }
        case .transactionItem:
            return .none
        case .onAppear:
            return fetchTransaction(
                symbol: state.symbol,
                environment: environment,
                cancelId: cancelId
            )
        case .onDisappear:
            return .cancel(id: cancelId)
        }
    }
)

fileprivate func fetchTransaction(
    symbol: String,
    environment: TransactionListEnvironment,
    cancelId: AnyHashable
) -> Effect<TransactionListAction, Never> {
    var transactionItemStates = [TransactionItemState]()
    let useCase = environment.transactionListUseCase()
    
    return useCase
        .getTransactionHistorySinglePublisher(
            symbol: symbol
        )
        .map { transcations in
            transcations.map { transcation in
                transcation.toTransactionItemState()
            }
        }
        .handleEvents(
            receiveOutput: {
                transactionItemStates = $0
            }
        )
        .flatMap { _ in
            useCase
                .getTransactionStreamPublisher(
                    symbols: [symbol]
                )
                .merge(
                    with: Just([]).setFailureType(to: Error.self)
                )
        }
        .map { transcations in
            transcations.map { transcation in
                transcation.toTransactionItemState()
            }
        }
        .map { newStates -> [TransactionItemState] in
            transactionItemStates.append(contentsOf: newStates)
            return transactionItemStates
        }
        .map { $0.reversed() }
        .eraseToAnyPublisher()
        .mapError { error in
            Log.error("Error: \(error)")
            return TransactionListError.description("다시 연결 중...")
        }
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
        .catchToEffect()
        .map(TransactionListAction.updateTransactionItems(result:))
        .cancellable(id: cancelId, cancelInFlight: true)
}

struct TransactionListView: View {
    let store: Store<TransactionListState, TransactionListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack(alignment: .top) {
                List {
                    ForEachStore(
                        self.store.scope(
                            state: \.items,
                            action: TransactionListAction.transactionItem(id:action:)
                        ),
                        content: { itemStore in
                            TransactionItemView(store: itemStore)
                        }
                    )
                }
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

extension IdentifiedArray where ID == TransactionItemState.ID, Element == TransactionItemState {
    static let mock: Self = [
        TransactionItemState(
            id: UUID(),
            symbol: "BTC_KRW",
            contDate: Date(),
            contPrice: 200000,
            contQuantity: 1
        ),
        TransactionItemState(
            id: UUID(),
            symbol: "ETH_KRW",
            contDate: Date(),
            contPrice: 1000,
            contQuantity: 2
        )
    ]
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(
            store: Store(
                initialState: TransactionListState(symbol: "BTC_KRW", items: .mock),
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
}
