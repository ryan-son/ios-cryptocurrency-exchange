//
//  BithumbOrderBookDepthStream.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/28.
//

import Foundation
import SwiftUI

struct BithumbOrderBookDepthStream: Equatable, Hashable {
    let symbol: String
    let orderType: BithumbOrderType
    let price: Double
    let quantity: Double
}

enum BithumbOrderType: String {
    case buy = "bid"
    case sell = "ask"
    case none
    
    private var comparisonValue: Int {
        switch self {
        case .sell:
            return 1
        case .buy:
            return 0
        case .none:
            return -1
        }
    }
}

extension BithumbOrderType: Comparable {
    static func < (lhs: BithumbOrderType, rhs: BithumbOrderType) -> Bool {
        lhs.comparisonValue < rhs.comparisonValue
    }
}

extension BithumbOrderBookDepthStream {
    func toOrderBookItem(ratio: CGFloat) -> OrderBookListState.OrderBookItem {
        OrderBookListState.OrderBookItem(
            orderType: orderType,
            price: price,
            quantity: quantity,
            ratio: ratio
        )
    }
}
