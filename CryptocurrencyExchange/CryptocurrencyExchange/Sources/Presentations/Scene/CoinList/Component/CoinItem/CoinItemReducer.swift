//
//  CoinItemReducer.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/01.
//

import ComposableArchitecture

let coinItemReducer = Reducer<
    CoinItemState, CoinItemAction, CoinItemEnvironment
> { state, action, environment in
    switch action {
    case .likeButtonTapped:
        let useCase = environment.tickerUseCase()
        state.isLiked.toggle()
        useCase.saveCoinIsLikeState(for: state.name, isLike: state.isLiked)
        return .none
    }
}
