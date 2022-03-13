//
//  CoinCurrentTickerAction.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/13.
//

import Foundation

enum CoinCurrentTickerAction: Equatable {
    case onAppear
    case onDisappear
    case responseTickerSingle(Result<BithumbTickerSingle, OrderBookListError>)
    case responseTickerStream(Result<BithumbTickerStream, OrderBookListError>)
}
