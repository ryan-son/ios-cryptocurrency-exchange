//
//  CoinItemView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/01.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct CoinItemView: View {
    let store: Store<CoinItemState, CoinItemAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            let viewState = viewStore.state.toViewState()
            
            HStack(spacing: 10) {
                Text(viewState.rank ?? "")
                    .bold()
                    .foregroundColor(.blue)
                    .frame(width: 30)
                    .hiddenIf(isHidden: viewState.rank == nil)
                
                KFImage.url(viewState.imageURL)
                    .resizable()
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewState.name)
                        .font(.headline)
                    HStack {
                        Text(viewState.price)
                            .foregroundColor(.gray)
                        Text(viewState.changeRate)
                            .foregroundColor(viewState.isPlus ? .red : .blue)
                    }
                    .font(.body)
                }
                Spacer()
                
                Button(action: { viewStore.send(.likeButtonTapped) }) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 35, height: 30)
                        .foregroundColor(viewState.isLiked ? .red : .gray)
                }
            }
            .padding()
        }
    }
}

struct CoinItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinItemView(
                store: Store(
                    initialState: CoinItemState(
                        rank: 1,
                        name: "비트코인",
                        price: 78427482.42,
                        changeRate: -1.24,
                        isLiked: true,
                        symbol: "BTC_KRW"
                    ),
                    reducer: coinItemReducer,
                    environment: CoinItemEnvironment(
                        tickerUseCase: { TickerUseCase() }
                    )
                )
            )
            CoinItemView(
                store: Store(
                    initialState: CoinItemState(
                        rank: nil,
                        name: "비트코인",
                        price: 78427482.42,
                        changeRate: 1.24,
                        isLiked: false,
                        symbol: "BTC_USD"
                    ),
                    reducer: coinItemReducer,
                    environment: CoinItemEnvironment(
                        tickerUseCase: { TickerUseCase() }
                    )
                )
            )
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        
    }
}

