//
//  BithumbOrderBookDepthTypeResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/27.
//

import Foundation

struct BithumbOrderBookDepthsResponseDTO: Decodable {
    let type: BithumbWebSocketTopicType
    let content: Content
    
    struct Content: Codable {
        let list: [List]
    }

    struct List: Codable {
        let symbol, buySellGB, contPrice, contQty: String
        let contAmt, contDtm, updn: String

        enum CodingKeys: String, CodingKey {
            case symbol
            case buySellGB = "buySellGb"
            case contPrice, contQty, contAmt, contDtm, updn
        }
    }
}
