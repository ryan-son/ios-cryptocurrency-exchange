//
//  TransactionItemView.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import SwiftUI

import ComposableArchitecture

struct TransactionItemView: View {
    let store: Store<TransactionItemState, TransactionItemAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            let viewState = viewStore.state.toViewState()
            VStack(spacing: 10) {
                Text("시간 : \(viewState.contDate)")
                Text("체결량 : \(viewState.contQuantity)")
                Text("체결가 : \(viewState.contPrice)")
            }
            .padding()
        }
    }
}

struct TransactionItemView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionItemView(
            store: Store(
                initialState: TransactionItemState(
                    id: UUID(),
                    symbol: "BTC_KRW",
                    contDate: Date(),
                    contPrice: 200000,
                    contQuantity: 1
                ),
                reducer: transactionReducer,
                environment: TransactionItemEnviroment()
            )
        )
            .previewLayout(.sizeThatFits)
    }
}
