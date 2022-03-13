//
//  CoinPriceReducer.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/12.
//

import Foundation

import ComposableArchitecture

let coinPriceReducer = Reducer<
    CoinPriceState, CoinPriceAction, CoinPriceEnvironment
> { state, action, environment in
    
    struct CoinPriceCancelId: Hashable {}
    
    let tickerUseCase = environment.tickerUseCase()
    
    switch action {
    case .onAppear:
        return .merge(
            tickerUseCase
                .getTickerSinglePublisher(symbol: state.symbol)
                .receive(on: DispatchQueue.main)
                .mapError { OrderBookListError.description($0.localizedDescription) }
                .catchToEffect(CoinPriceAction.responseTickerSingle)
            ,
            tickerUseCase
                .getTickerStreamPublisher(
                    symbols: [state.symbol],
                    tickTypes: [.day]
                )
                .receive(on: DispatchQueue.main)
                .mapError { OrderBookListError.description($0.localizedDescription) }
                .catchToEffect(CoinPriceAction.responseTickerStream)
                .cancellable(id: CoinPriceCancelId())
        )
        
    case .onDisappear:
        return .cancel(id: CoinPriceCancelId())
        
    case let .responseTickerSingle(.success(ticker)):
        state.nowPrice = ticker.closingPrice
        return .none
        
    case let .responseTickerSingle(.failure(error)):
        Log.error(error)
        return .none
        
    case let .responseTickerStream(.success(ticker)):
        state.nowPrice = ticker.closePrice
        return .none
        
    case let .responseTickerStream(.failure(error)):
        Log.error(error)
        return .none
        
    }
}
