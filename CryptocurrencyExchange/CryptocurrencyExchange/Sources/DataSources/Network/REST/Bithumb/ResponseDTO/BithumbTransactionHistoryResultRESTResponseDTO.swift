//
//  BithumbTransactionHistoryResultRESTResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import Foundation

struct BithumbTransactionHistoryResultRESTResponseDTO: BithumbDataResponse {
    let status: String
    let resmsg: String?
    let data: [BithumbTransactionHistoryRESTResponseDTO]?
}

struct BithumbTransactionHistoryRESTResponseDTO: Codable {
    let transactionDate, type, unitsTraded, price: String
    let total: String

    enum CodingKeys: String, CodingKey {
        case transactionDate = "transaction_date"
        case type
        case unitsTraded = "units_traded"
        case price, total
    }
}

extension BithumbTransactionHistoryResultRESTResponseDTO {
    func toDomain(
        symbol: String
    ) -> [BithumbTransactionHistroySingle] {
        return data?.map { transactionHistory -> BithumbTransactionHistroySingle in
            let contDate = transactionHistory.transactionDate.toDate(
                format: "yyyy-MM-dd HH:mm:ss"
            ) ?? Date()
            let contPrice = Double(
                transactionHistory.price
            ) ?? 0
            let contQuantity = Double(transactionHistory.unitsTraded) ?? 0
            return BithumbTransactionHistroySingle(
                symbol: symbol,
                contDate: contDate,
                contPrice: contPrice,
                contQuantity: contQuantity
            )
        } ?? []
    }
}

