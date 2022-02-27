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
            .decode(type: BithumbTickersResponseDTO?.self, decoder: decoder)
            .compactMap { $0 }
            .eraseToAnyPublisher()
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
            .decode(type: BithumbTransactionsResponseDTO?.self, decoder: decoder)
            .compactMap { $0 }
            .eraseToAnyPublisher()
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
            .decode(type: BithumbOrderBookDepthsResponseDTO?.self, decoder: decoder)
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}

struct BithumbWebSocketFilter: Codable {
    let type: BithumbWebSocketTopicType
    let symbols: [String]
    let tickTypes: [TickType]
    
    enum TickType: Codable {
        case thirtyMinute
        case hour
        case twelveHour
        case day
        case mid
    }
}

enum BithumbWebSocketTopicType: String, Codable {
    case ticker
    case transaction
    case orderBookDepth = "orderbookdepth"
}
