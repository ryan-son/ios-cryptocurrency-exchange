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
    var nowPrice: Double?
    var orderBooks: [OrderBookItem] = []
    var maxQuantity: Double = 0
    
    struct OrderBookItem: Equatable, Hashable, Comparable {
        
        let orderType: BithumbOrderType
        let price: Double
        let quantity: Double
        let ratio: CGFloat
        
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

extension OrderBookListState {
    func toViewState() -> OrderBookListViewState {
        let symbols = symbol.components(separatedBy: "_")
        let coinSymbol = symbols.first ?? ""
        let currencySymbol = symbols.last ?? ""
        let currency = Currency(rawValue: currencySymbol.lowercased()) ?? .none
        let formattedPrice = nowPrice?.format(to: currency) ?? ""
        let imageURL = URL(
            string: "https://cryptoicon-api.vercel.app/api/icon/\(coinSymbol.lowercased())"
        )
        return OrderBookListViewState(
            symbolName: coinSymbol,
            nowPrice: formattedPrice,
            imageURL: imageURL
        )
    }
}

struct OrderBookListViewState {
    let symbolName: String
    var nowPrice: String
    let imageURL: URL?
}
