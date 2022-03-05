//
//  BithumbSocketConnector.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//

import Foundation

import Combine

struct BithumbSocketConnector {
    private let socketConnector: WebSocketConnectable
    private let tickerSubject = PassthroughSubject<BithumbTickersResponseDTO, Error>()
    private let transactionSubject = PassthroughSubject<BithumbTransactionsResponseDTO, Error>()
    private let orderBookDepthSubject = PassthroughSubject<BithumbOrderBookDepthsResponseDTO, Error>()

    init(
        socketConnector: WebSocketConnectable = WebSocketConnector<API.WebSocket>(api: .`public`)
    ) {
        self.socketConnector = socketConnector
    }
    
    func connect() -> AnyPublisher<Bool, Never> {
        socketConnector.connect()
        return socketConnector.isConnectedPublisher
    }
    
    func getTickerPublisher(
        with filter: BithumbWebSocketFilter,
        encodeWith encoder: JSONEncoder = JSONEncoder(),
        decodedWith decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<BithumbTickersResponseDTO, Error> {
        return Just(filter)
            .encode(encoder: encoder)
            .flatMap { data -> AnyPublisher<Data, Never> in
                socketConnector.write(data: data)
                return socketConnector.dataPublisher
            }
            .compactMapDecode(type: BithumbTickersResponseDTO.self, decoder: decoder)
    }
    
    func getTransactionPublisher(
        with filter: BithumbWebSocketFilter,
        encodeWith encoder: JSONEncoder = JSONEncoder(),
        decodedWith decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<BithumbTransactionsResponseDTO, Error> {
        return Just(filter)
            .encode(encoder: encoder)
            .flatMap { data -> AnyPublisher<Data, Never> in
                socketConnector.write(data: data)
                return socketConnector.dataPublisher
            }
            .compactMapDecode(type: BithumbTransactionsResponseDTO.self, decoder: decoder)
    }
    
    func getOrderBookDepthPublisher(
        with filter: BithumbWebSocketFilter,
        encodeWith encoder: JSONEncoder = JSONEncoder(),
        decodedWith decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<BithumbOrderBookDepthsResponseDTO, Error> {
        return Just(filter)
            .encode(encoder: encoder)
            .flatMap { data -> AnyPublisher<Data, Never> in
                socketConnector.write(data: data)
                return socketConnector.dataPublisher
            }
            .compactMapDecode(type: BithumbOrderBookDepthsResponseDTO.self, decoder: decoder)
    }
}

struct BithumbWebSocketFilter: Codable {
    let type: BithumbWebSocketTopicType
    let symbols: [String]
    let tickTypes: [TickType]?
}

enum BithumbWebSocketTopicType: String, Codable {
    case ticker
    case transaction
    case orderBookDepth = "orderbookdepth"
}

enum TickType: String, Codable {
    case thirtyMinute = "30M"
    case hour = "1H"
    case twelveHour = "12H"
    case day = "24H"
    case mid = "MID"
    case none
}
