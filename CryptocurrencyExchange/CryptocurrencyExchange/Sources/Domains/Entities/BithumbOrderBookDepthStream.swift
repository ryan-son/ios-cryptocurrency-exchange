//
//  BithumbOrderBookDepthStream.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/28.
//

import Foundation

struct BithumbOrderBookDepthStream {
    let symbol: String
    let orderType: BithumbOrderType
    let price: Double
    let quantity: Double
}

enum BithumbOrderType: String {
    case buy = "bid"
    case sell = "ask"
    case none
}
