//
//  BithumbTransactionTypeResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/27.
//

import Foundation

struct BithumbTransactionsResponseDTO: Decodable {
    let type: BithumbWebSocketTopicType
    let content: Transactions
    
    struct Transactions: Codable {
        let list: [Transaction]
        let datetime: Int
    }

    struct Transaction: Codable {
        let symbol, orderType, price, quantity: String
        let total: String
    }
}
