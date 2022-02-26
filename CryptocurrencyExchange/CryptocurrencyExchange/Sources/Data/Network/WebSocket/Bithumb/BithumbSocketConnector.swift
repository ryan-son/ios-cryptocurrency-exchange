//
//  BithumbSocketConnector.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//

import Foundation

struct BithumbSocketConnector {
    private let socketConnector: WebSocketConnectable

    func connect() {
        socketConnector.connect()
    }

    func filter(
        with filter: BithumbWebSocketFilter,
        encodeWith encoder: JSONEncoder = JSONEncoder()
    ) throws {
        let converted = try encoder.encode(filter)
        socketConnector.write(data: converted)
    }
}

struct BithumbWebSocketFilter: Codable {
    let type: SubscribeSubjectType
    let symbols: [String]
    let tickTypes: [TickType]

    enum SubscribeSubjectType: String, Codable {
        case ticker
        case transaction
        case orderBookDepth = "orderbookdepth"
    }

    enum TickType: Codable {
        case thirtyMinute
        case hour
        case twelveHour
        case day
        case mid
    }
}
