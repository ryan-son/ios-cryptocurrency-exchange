//
//  BithumbCandleStickResultResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/10.
//

import Foundation

///{
///    "status": "0000",
///    "data" : {
///        [
///            1576823400000,  // 기준 시간
///            "8284000",        // 시가
///            "8286000",        // 종가
///            "8289000",        // 고가
///            "8276000",        // 저가
///            "15.41503692"     // 거래량
///        ],
///        [
///            1576824000000,  // 기준 시간
///            "8284000",        // 시가
///            "8281000",        // 종가
///            "8289000",        // 고가
///            "8275000",        // 저가
///            "6.19584467"      // 거래량
///        ]
///    }
///}
struct BithumbCandleStickResultResponseDTO: Decodable {
    let status: String
    let data: [[BithumbCandleStickResponseDTO]]
}

extension BithumbCandleStickResultResponseDTO {
    func toDomain() -> BithumbCandleStickSingle {
        return BithumbCandleStickSingle(
            data: data.map { $0.toBithumbCandleStickDataSingle() }
        )
    }
}

fileprivate extension Array where Element == BithumbCandleStickResponseDTO {
    func toBithumbCandleStickDataSingle() -> BithumbCandleStickDataSingle {
        let converted = self.map { item -> Double in
            switch item {
            case let .time(time):
                return Double(time)
            case let .information(info):
                return Double(info) ?? 0
            }
        }
        return BithumbCandleStickDataSingle(
            date: converted[safe: 0] ?? 0,
            openPrice: converted[safe: 1] ?? 0,
            closePrice: converted[safe: 2] ?? 0,
            lowPrice: converted[safe: 3] ?? 0,
            highPrice: converted[safe: 4] ?? 0,
            transactionVolume: converted[safe: 5] ?? 0
        )
    }
}

enum BithumbCandleStickResponseDTO: Decodable {
    case time(TimeInterval)
    case information(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let time = try? container.decode(Double.self) {
            self = .time(time)
            return
        }
        if let information = try? container.decode(String.self) {
            self = .information(information)
            return
        }
        throw DecodingError.typeMismatch(
            BithumbCandleStickResponseDTO.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Type mismatch"
            )
        )
    }
}
