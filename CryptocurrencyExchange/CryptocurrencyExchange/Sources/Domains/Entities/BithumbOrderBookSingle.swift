//
//  BithumbOrderBookSingle.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import Foundation

struct BithumbOrderBookSingle: Equatable {
    let buy: [OrderBookRow]
    let sell: [OrderBookRow]
    
    struct OrderBookRow: Equatable {
        let quantity: Double
        let price: Double
    }
}


