//
//  OrderBookListAction.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/12.
//

import Foundation

enum OrderBookListAction: Equatable {
    case onAppear
    case onDisappear
    case responseOrderBookSingle(Result<BithumbOrderBookSingle, OrderBookListError>)
    case responseOrderBookStream(Result<[BithumbOrderBookDepthStream], OrderBookListError>)
    case responseTicker(Result<BithumbTickerStream, OrderBookListError>)
    case sortOrderBooks
}
