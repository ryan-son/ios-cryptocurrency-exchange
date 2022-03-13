//
//  BithumbOrderBookResultRESTResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import Foundation

struct BithumbOrderBookResultRESTResponseDTO: Codable {
    let status: String
    let resmsg: String?
    let data: BithumbOrderBookRESTResponseDTO?
}

struct BithumbOrderBookRESTResponseDTO: Codable {
    let timestamp: String
    let orderCurrency, paymentCurrency: String
    let bids, asks: [OrderBook]

    enum CodingKeys: String, CodingKey {
        case timestamp
        case orderCurrency = "order_currency"
        case paymentCurrency = "payment_currency"
        case bids, asks
    }
}

struct OrderBook: Codable, Equatable {
    let quantity, price: String
}

extension BithumbOrderBookResultRESTResponseDTO {
    func toDomain() -> BithumbOrderBookSingle {
        return BithumbOrderBookSingle(
            buy: data?.bids.map {
                BithumbOrderBookSingle.OrderBookRow(
                    quantity: Double($0.quantity) ?? 0,
                    price: Double($0.price) ?? 0
                )
            } ?? [],
            sell: data?.asks.map {
                BithumbOrderBookSingle.OrderBookRow(
                    quantity: Double($0.quantity) ?? 0,
                    price: Double($0.price) ?? 0
                )
            } ?? []
        )
    }
}


