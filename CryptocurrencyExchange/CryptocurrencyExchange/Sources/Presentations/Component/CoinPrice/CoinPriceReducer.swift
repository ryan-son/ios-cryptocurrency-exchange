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
    
    switch action {
    case .onAppear:
        return .merge(
            environment.useCase
                .getTransactionHistorySinglePublisher(symbol: state.symbol)
                .receive(on: DispatchQueue.main)
                .mapError { OrderBookListError.description($0.localizedDescription) }
                .catchToEffect(CoinPriceAction.responseTransactionSingle)
            ,
            environment.useCase.getTickerStreamPublisher(
                symbols: [state.symbol],
                tickTypes: [.day]
            )
                .receive(on: DispatchQueue.main)
                .mapError { OrderBookListError.description($0.localizedDescription) }
                .catchToEffect(CoinPriceAction.responseTransactionStream)
                .cancellable(id: CoinPriceCancelId())
        )
        
    case .onDisappear:
        return .cancel(id: CoinPriceCancelId())
        
    case let .responseTransactionSingle(.success(transactions)):
        if let nowPrice = transactions.first?.contPrice {
            state.nowPrice = nowPrice
        }
        return .none
        
    case let .responseTransactionSingle(.failure(error)):
        Log.error(error)
        return .none
        
    case let .responseTransactionStream(.success(ticker)):
        state.nowPrice = ticker.closePrice
        return .none
        
    case let .responseTransactionStream(.failure(error)):
        Log.error(error)
        return .none
        
    }
}
