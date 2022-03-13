//
//  CoinCurrentTickerReducer.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/13.
//

import Foundation

import ComposableArchitecture

let CoinCurrentTickerReducer = Reducer<
    CoinCurrentTickerState, CoinCurrentTickerAction, CoinCurrentTickerEnvironment
> { state, action, environment in
    
    struct CoinCurrentTickerCancelId: Hashable {}
    
    switch action {
    case .onAppear:
        return .merge(
            environment.useCase
                .getTickerSinglePublisher(symbol: state.symbol)
                .receive(on: DispatchQueue.main)
                .mapError { OrderBookListError.description($0.localizedDescription) }
                .catchToEffect(CoinCurrentTickerAction.responseTickerSingle)
            ,
            environment.useCase
                .getTickerStreamPublisher(
                    symbols: [state.symbol],
                    tickTypes: [.day]
                )
                .receive(on: DispatchQueue.main)
                .mapError { OrderBookListError.description($0.localizedDescription) }
                .catchToEffect(CoinCurrentTickerAction.responseTickerStream)
                .cancellable(id: CoinCurrentTickerCancelId())
        )
        
    case .onDisappear:
        return .cancel(id: CoinCurrentTickerCancelId())
        
    case let .responseTickerSingle(.success(ticker)):
        state.nowPrice = ticker.closingPrice
        state.changeRate = ticker.changeRate
        state.changeAmount = ticker.changeAmount
        return .none
        
    case let .responseTickerSingle(.failure(error)):
        Log.error(error)
        return .none
        
    case let .responseTickerStream(.success(ticker)):
        state.nowPrice = ticker.closePrice
        state.changeRate = ticker.changeRate
        state.changeAmount = ticker.changeAmount
        return .none
        
    case let .responseTickerStream(.failure(error)):
        Log.error(error)
        return .none
        
    }
}
