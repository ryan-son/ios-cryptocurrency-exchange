//
//  CoinPriceAction.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/12.
//

import Foundation

enum CoinPriceAction: Equatable {
    case onAppear
    case onDisappear
    case responseTickerSingle(Result<BithumbTickerSingle, OrderBookListError>)
    case responseTickerStream(Result<BithumbTickerStream, OrderBookListError>)
}
