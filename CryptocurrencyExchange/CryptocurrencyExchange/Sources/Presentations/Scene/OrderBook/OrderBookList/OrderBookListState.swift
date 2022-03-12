//
//  OrderBookListState.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/12.
//

import Foundation
import SwiftUI

enum OrderBookListError: Error, Equatable {
    case description(String)
}

extension OrderBookListError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .description(message):
            return message
        }
    }
}

struct OrderBookListState: Equatable {
    let symbol: String
    var coinPriceState: CoinPriceState
    var orderBooks: [OrderBookItem] = []
    var maxQuantity: Double = 0
    
    init(symbol: String) {
        self.symbol = symbol
        coinPriceState = CoinPriceState(symbol: symbol)
    }
    
    struct OrderBookItem: Equatable, Hashable, Comparable {
        let orderType: BithumbOrderType
        let price: Double
        let quantity: Double
        var ratio: CGFloat
        
        func toViewItem() -> OrderBookView.OrderBookViewItem {
            OrderBookView.OrderBookViewItem(
                orderType: orderType,
                price: "\(price)",
                quantity: "\(quantity)",
                ratio: ratio
            )
        }
        
        static func < (
            lhs: OrderBookListState.OrderBookItem,
            rhs: OrderBookListState.OrderBookItem
        ) -> Bool {
            if lhs.orderType < rhs.orderType {
                return true
            }
            
            if lhs.price < rhs.price {
                return true
            }
            
            return false
        }
    }
    
    func getRatio(quantity: Double) -> CGFloat {
        maxQuantity == 0 ? 0 : CGFloat(quantity / maxQuantity)
    }
}
