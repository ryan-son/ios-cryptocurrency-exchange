//
//  BithumbOrderbookSingle.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import Foundation

struct BithumbOrderbookSingle: Equatable {
    let buy: [OrderbookRow]
    let sell: [OrderbookRow]
    
    struct OrderbookRow: Equatable {
        let quantity: Double
        let price: Double
    }
}


