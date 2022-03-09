////
////  TransactionListView.swift
////  CryptocurrencyExchange
////
////  Created by 김정상 on 2022/03/09.
////
//
//import Combine
//import SwiftUI
//
//import ComposableArchitecture
//import IdentifiedCollections
//
//enum TransactionListError: Equatable {
//    case description(String)
//}
//
//extension TransactionListError: LocalizedError {
//    var localizedDescription: String {
//        switch self {
//        case let .description(message):
//            return message
//        }
//    }
//}
//
//struct TransactionListState: Equatable {
//    var items: IdentifiedArrayOf<TransactionItemState>
//    var toastMessage: String?
//}
//
//enum TransactionListAction: Equatable {
//    case transactionItem(id: TransactionItemState.ID, action: TransactionItemAction)
//    case onAppear
//    case onDisappear
//    case updateTransactionItems(result: Result<[TransactionItemState], TransactionListError>)
//}
//
//struct TransactionListEnvironment {
//    let transactionListUseCase: () -> TransactionListUseCaseProtocol
//    let toastClient: ToastClient
//}
//
//let trainscationListReducer = Reducer<
//    TransactionListState, TransactionListAction, TransactionListEnvironment
//>.combine(
//    Reducer { state, action, environment in
//        struct CancelId: Hashable {}
//        let cancelId = CancelId()
//        switch action {
//        case let .updateTransactionItems(result):
//            switch result {
//            case let .success(items):
//                state.items = IdentifiedArray(uniqueElements: items)
//                return .none
//            case let .failure(error):
//                return .none
//            }
//        case .transactionItem:
//            return .none
//        case .onAppear:
//            return fetchTransaction(environment: environment, cancelId: cancelId)
//        case .onDisappear:
//            return .cancel(id: cancelId)
//        }
//    }
//)
//
//fileprivate func fetchTransaction(
//    environment: TransactionListEnvironment,
//    cancelId: AnyHashable
//) -> Effect<TransactionListAction, Never> {
//    var transactionItemStates = [TransactionItemState]()
//    let useCase = environment.transactionListUseCase()
//    
//    let transactionSymbol = "BTC_KRW"
//    
//    return useCase
//        .getTransactionHistorySinglePublisher(
//            symbol: transactionSymbol
//        )
//        .map { transcations in
//            transcations.map { transcation in
//                transcation.toTransactionItemState()
//            }
//        }
//        .handleEvents(
//            receiveOutput: {
//                transactionItemStates = $0
//            }
//        )
//        .flatMap { _ in
//            useCase.getTransactionStreamPublisher(
//                symbols: [transactionSymbol]
//            )
//        }
//        .map { transcations in
//            transcations.map { transcation in
//                transcation.toTransactionItemState()
//            }
//        }
//        .map { newStates -> [TransactionItemState] in
//            transactionItemStates.append(contentsOf: newStates)
//            return transactionItemStates
//        }
//        .eraseToAnyPublisher()
//        .mapError { error in
//            Log.error("Error: \(error)")
//            return TransactionListError.description("다시 연결 중...")
//        }
//        .receive(on: DispatchQueue.main)
//        .eraseToEffect()
//        .catchToEffect()
//        .map(TransactionListAction.updateTransactionItems(result:))
//        .cancellable(id: cancelId, cancelInFlight: true)
//}
//
//struct TransactionListView: View {
//    var body: some View {
//        WithViewStore(self.store) { viewStore in
//            ZStack(alignment: .top) {
//                List {
//                    ForEachStore(
//                        self.store.scope(
//                            state: \.items,
//                            action: CoinListAction.coinItem(id:action:)
//                        ),
//                        content: { itemStore in
//                            NavigationLink(destination: {
//                                CoinItemView(store: itemStore)
//                            }) {
//                                CoinItemView(store: itemStore)
//                            }
//                        }
//                    )
//                }
//                .alert(store.scope(state: \.alert), dismiss: CoinListAction.dismissAlert)
//                .listStyle(.plain)
//                .buttonStyle(.plain)
//                .onAppear {
//                    viewStore.send(.onAppear)
//                }
//                .onDisappear {
//                    viewStore.send(.onDisappear)
//                }
//                if let toastMessage = viewStore.toastMessage {
//                    ToastView(message: toastMessage)
//                }
//            }
//            
//        }
//    }
//}
//
//struct TransactionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionListView()
//    }
//}
