//
//  CoinItemView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/01.
//

import ComposableArchitecture
import SwiftUI

struct CoinItemView: View {
    let store: Store<CoinItemState, CoinItemAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            let viewState = viewStore.state.toViewState()

            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewState.name)
                        .font(.headline)
                    HStack {
                        Text(viewState.price)
                        Text(viewState.changeRate)
                    }
                    .font(.body)
                }
                Spacer()
                Button(action: { viewStore.send(.likeButtonTapped) }) {
                    let heartFillImage = Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 35, height: 30)
                    let heartImage = Image(systemName: "heart")
                        .resizable()
                        .frame(width: 35, height: 30)
                    viewStore.isLiked ? heartFillImage : heartImage
                }
            }
        }
    }
}

struct CoinItemView_Previews: PreviewProvider {
    static var previews: some View {
        CoinItemView(
            store: Store(
                initialState: CoinItemState(
                    name: "비트코인",
                    price: 78427482.42,
                    changeRate: 1.24,
                    isPlus: true,
                    isLiked: true,
                    symbol: "BTC"
                ),
                reducer: coinItemReducer,
                environment: CoinItemEnvironment()
            )
        )
            .previewLayout(.sizeThatFits)
    }
}
