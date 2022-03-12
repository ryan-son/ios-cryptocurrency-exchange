//
//  TransactionListReducer.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/11.
//

import Combine

import ComposableArchitecture

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
