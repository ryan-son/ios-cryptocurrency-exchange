//
//  BithumbTransactionTypeResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/27.
//

import Foundation

/// Example Response (orderbookdepth)
/// https://apidocs.bithumb.com/docs/websocket_public
struct BithumbOrderBookDepthSocketResponseDTO: Decodable {
    let type: BithumbWebSocketTopicType
    let content: OrderBookDepths
    
    struct OrderBookDepths: Codable {
        let list: [OrderBookDepth]
        let datetime: String
    }

    struct OrderBookDepth: Codable {
        let symbol, orderType, price, quantity: String
        let total: String
    }
}

extension BithumbOrderBookDepthSocketResponseDTO {
    func toDomain() -> [BithumbOrderBookDepthStream] {
        content.list.map{
            BithumbOrderBookDepthStream(
                symbol: $0.symbol,
                orderType: BithumbOrderType(rawValue: $0.orderType) ?? .none,
                price: Double($0.price) ?? 0,
                quantity: Double($0.quantity) ?? 0
            )
        }
    }
}


