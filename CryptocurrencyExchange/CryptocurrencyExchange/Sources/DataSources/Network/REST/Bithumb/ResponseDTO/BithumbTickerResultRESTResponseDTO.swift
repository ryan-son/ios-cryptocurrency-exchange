//
//  BithumbTickerResultRESTResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/13.
//

import Foundation
import AnyCodable

struct BithumbTickerResultRESTResponseDTO: BithumbDataResponse {
    let status: String
    let resmsg: String?
    let data: BithumbTickerRESTResponseDTO?
}

struct BithumbTickerRESTResponseDTO: Decodable {
    let openingPrice, closingPrice, minPrice, maxPrice: String
    let unitsTraded, accTradeValue, prevClosingPrice, unitsTraded24H: String
    let accTradeValue24H, fluctate24H, fluctateRate24H: String

    enum CodingKeys: String, CodingKey {
        case openingPrice = "opening_price"
        case closingPrice = "closing_price"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case unitsTraded = "units_traded"
        case accTradeValue = "acc_trade_value"
        case prevClosingPrice = "prev_closing_price"
        case unitsTraded24H = "units_traded_24H"
        case accTradeValue24H = "acc_trade_value_24H"
        case fluctate24H = "fluctate_24H"
        case fluctateRate24H = "fluctate_rate_24H"
    }
}

extension BithumbTickerResultRESTResponseDTO {
    func toDomain(
        symbol: String
    ) -> BithumbTickerSingle {
        return BithumbTickerSingle(
            name: symbol.symbolToName(),
            closingPrice: Double(data?.closingPrice ?? "") ?? 0,
            changeRate: Double(data?.fluctateRate24H ?? "") ?? 0,
            changeAmount: Double(data?.fluctate24H ?? "") ?? 0
        )
    }
}

