//
//  BithumbTransactionSocketResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/27.
//

import Foundation

/// Example Response (transaction)
/// https://apidocs.bithumb.com/docs/websocket_public
struct BithumbTransactionSocketResponseDTO: Decodable {
    let type: BithumbWebSocketTopicType
    let content: Transactions
    
    struct Transactions: Codable {
        let list: [Transaction]
    }
    
    struct Transaction: Codable {
        let symbol, buySellGB, contPrice, contQty: String
        let contAmt, contDtm, updn: String
        
        enum CodingKeys: String, CodingKey {
            case symbol
            case buySellGB = "buySellGb"
            case contPrice, contQty, contAmt, contDtm, updn
        }
    }
}

extension BithumbTransactionSocketResponseDTO {
    func toDomain() -> [BithumbTransactionStream] {
        return content.list.map{
            $0.toDomain()
        }
    }
}

extension BithumbTransactionSocketResponseDTO.Transaction {
    func toDomain() -> BithumbTransactionStream {
        return BithumbTransactionStream(
            symbol: symbol,
            transactionType: BithumbTransactionType.from(
                value: Int(buySellGB) ?? -1
            ),
            contPrice: Double(contPrice) ?? 0,
            contQuantity: Double(contQty) ?? 0,
            contAmount: Double(contAmt) ?? 0,
            transactionDate: contDtm.toDate(format: "yyyy-MM-dd HH:mm:ss.SSSSSS") ?? Date(),
            priceUpDown: BithumbTransactionPriceUpDown(rawValue: updn) ?? .none
        )
    }
}
