//
//  BithumbTickerAllResultRESTResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/26.
//

import Foundation
import AnyCodable

struct BithumbTickerAllResultRESTResponseDTO: BithumbDataResponse {
    let status: String
    let resmsg: String?
    let data: [String: AnyCodable]?
}

struct BithumbTickerAllRESTResponseDTO: Decodable {
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

extension BithumbTickerAllResultRESTResponseDTO {
    func toDomain() -> [BithumbTickerSingle] {
        let filteredKeys = data?.keys
            .filter { $0 != "date" } ?? []
        let responses = filteredKeys
            .compactMap { data?[$0] }
            .compactMap { try? JSONEncoder().encode($0) }
            .compactMap { try? JSONDecoder().decode(BithumbTickerAllRESTResponseDTO.self, from: $0) }
        return zip(filteredKeys, responses)
            .map { key, response in
                BithumbTickerSingle(
                    name: key,
                    closingPrice: Double(response.closingPrice) ?? 0,
                    changeRate: Double(response.fluctateRate24H) ?? 0,
                    changeAmount: Double(response.fluctate24H) ?? 0
                )
            }
    }
}
