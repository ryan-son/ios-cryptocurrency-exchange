//
//  CoinPriceView.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/12.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher







struct CoinPriceView: View {
    let store: Store<CoinPriceState, CoinPriceAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            let viewState = viewStore.state.toViewState()
            HStack(spacing: 16) {
                KFImage.url(viewState.imageURL)
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 8) {
                    Text("현재가격")
                        .font(.headline)
                    Text(viewState.nowPrice)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.vertical, 20)
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        }
    }
}

struct CoinPriceView_Previews: PreviewProvider {
    static var previews: some View {
        CoinPriceView(
            store: Store(
                initialState: CoinPriceState(symbol: "BTC_KRW"),
                reducer: coinPriceReducer,
                environment: CoinPriceEnvironment(
                    useCase: TransactionListUseCase()
                )
            )
        )
    }
}
