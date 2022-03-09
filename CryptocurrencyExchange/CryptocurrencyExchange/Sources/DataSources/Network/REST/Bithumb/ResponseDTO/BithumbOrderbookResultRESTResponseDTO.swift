//
//  BithumbOrderbookResultRESTResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import Foundation

struct BithumbOrderbookResultRESTResponseDTO: Codable {
    let status: String
    let resmsg: String?
    let data: BithumbOrderbookRESTResponseDTO?
}

struct BithumbOrderbookRESTResponseDTO: Codable {
    let timestamp: Int
    let orderCurrency, paymentCurrency: String
    let bids, asks: [Orderbook]

    enum CodingKeys: String, CodingKey {
        case timestamp
        case orderCurrency = "order_currency"
        case paymentCurrency = "payment_currency"
        case bids, asks
    }
}

struct Orderbook: Codable {
    let quantity, price: String
}

extension BithumbOrderbookResultRESTResponseDTO {
    func toDomain() -> BithumbOrderbookSingle {
        return BithumbOrderbookSingle()
    }
}


