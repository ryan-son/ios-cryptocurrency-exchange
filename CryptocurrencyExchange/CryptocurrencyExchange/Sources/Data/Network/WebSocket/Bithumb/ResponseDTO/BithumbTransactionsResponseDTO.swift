//
//  BithumbTransactionTypeResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/27.
//

import Foundation

struct BithumbTransactionsResponseDTO: Decodable {
    let type: BithumbWebSocketTopicType
    let content: Content
    
    struct Content: Codable {
        let list: [List]
        let datetime: Int
    }

    struct List: Codable {
        let symbol, orderType, price, quantity: String
        let total: String
    }
}
