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

struct TransactionListView: View {
    let store: Store<TransactionListState, TransactionListAction>
    
    // TODO: Coin List Scoping 정리 되면 삭제 할 것.
    init(store: Store<TransactionListState, TransactionListAction>) {
        self.store = store
        let viewStore = ViewStore(store)
        viewStore.send(.onAppear)
    }
    
    var body: some View {
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
            // TODO: Coin List Scoping 정리 되면 되돌릴 것.
            //                .onAppear {
            //                    viewStore.send(.onAppear)
            //                }
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
        .navigationTitle("체결")
    }
}

extension IdentifiedArray where ID == TransactionItemState.ID, Element == TransactionItemState {
    static let mock: Self = [
        TransactionItemState(
            id: UUID(),
            symbol: "BTC_KRW",
            type: .buy,
            contDate: Date(),
            contPrice: 200000,
            contQuantity: 1
        ),
        TransactionItemState(
            id: UUID(),
            symbol: "ETH_KRW",
            type: .sell,
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
