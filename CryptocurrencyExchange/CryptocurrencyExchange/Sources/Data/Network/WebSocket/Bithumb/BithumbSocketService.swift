//
//  BithumbSocketService.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//

import Foundation

import Combine

struct BithumbSocketService {
    private let socketConnector: WebSocketConnectable
    private let tickerSubject = PassthroughSubject<BithumbTickerSocketResponseDTO, Error>()
    private let transactionSubject = PassthroughSubject<BithumbTransactionSocketResponseDTO, Error>()
    private let orderBookDepthSubject = PassthroughSubject<BithumbOrderBookDepthSocketResponseDTO, Error>()

    init(
        socketConnector: WebSocketConnectable = WebSocketConnector<API.BithumbWebSocket>(api: .`public`)
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
    ) -> AnyPublisher<BithumbTickerSocketResponseDTO, Error> {
        return Just(filter)
            .encode(encoder: encoder)
            .flatMap { data -> AnyPublisher<Data, Never> in
                socketConnector.write(data: data)
                return socketConnector.dataPublisher
            }
            .compactMapDecode(type: BithumbTickerSocketResponseDTO.self, decoder: decoder)
    }
    
    func getTransactionPublisher(
        with filter: BithumbWebSocketFilter,
        encodeWith encoder: JSONEncoder = JSONEncoder(),
        decodedWith decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<BithumbTransactionSocketResponseDTO, Error> {
        return Just(filter)
            .encode(encoder: encoder)
            .flatMap { data -> AnyPublisher<Data, Never> in
                socketConnector.write(data: data)
                return socketConnector.dataPublisher
            }
            .compactMapDecode(type: BithumbTransactionSocketResponseDTO.self, decoder: decoder)
    }
    
    func getOrderBookDepthPublisher(
        with filter: BithumbWebSocketFilter,
        encodeWith encoder: JSONEncoder = JSONEncoder(),
        decodedWith decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<BithumbOrderBookDepthSocketResponseDTO, Error> {
        return Just(filter)
            .encode(encoder: encoder)
            .flatMap { data -> AnyPublisher<Data, Never> in
                socketConnector.write(data: data)
                return socketConnector.dataPublisher
            }
            .compactMapDecode(type: BithumbOrderBookDepthSocketResponseDTO.self, decoder: decoder)
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
