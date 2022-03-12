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
            HStack(spacing: 10) {
                VStack(alignment: .leading) {
                    Text(viewState.contDate)
                        .font(.body)
                    Text(viewState.type)
                        .font(.caption)
                        .foregroundColor(viewState.typeColor)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(viewState.contPrice)
                        .font(.body)
                    Text(viewState.contQuantity)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
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
                    type: .buy,
                    contDate: Date(),
                    contPrice: 200000,
                    contQuantity: 1
                ),
                reducer: transactionItemReducer,
                environment: TransactionItemEnviroment()
            )
        )
            .previewLayout(.sizeThatFits)
    }
}
