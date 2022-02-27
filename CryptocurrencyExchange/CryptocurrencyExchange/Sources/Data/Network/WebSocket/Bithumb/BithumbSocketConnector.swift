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
    
    func connect() {
        socketConnector.connect()
    }
    
    func getTickerPublisher(
        with filter: BithumbWebSocketFilter,
        encodeWith encoder: JSONEncoder = JSONEncoder(),
        decodedWith decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<BithumbTickersResponseDTO, Error> {
        do {
            let converted = try encoder.encode(filter)
            socketConnector.write(data: converted)
        } catch {
            return Fail<BithumbTickersResponseDTO, Error>(error: error)
                .eraseToAnyPublisher()
        }
        
        return socketConnector.dataPublisher
            .decode(type: BithumbTickersResponseDTO?.self, decoder: decoder)
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func getTransactionPublisher(
        with filter: BithumbWebSocketFilter,
        encodeWith encoder: JSONEncoder = JSONEncoder(),
        decodedWith decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<BithumbTransactionsResponseDTO, Error> {
        do {
            let converted = try encoder.encode(filter)
            socketConnector.write(data: converted)
        } catch {
            return Fail<BithumbTransactionsResponseDTO, Error>(error: error)
                .eraseToAnyPublisher()
        }
        
        return socketConnector.dataPublisher
            .decode(type: BithumbTransactionsResponseDTO?.self, decoder: decoder)
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func getOrderBookDepthPublisher(
        with filter: BithumbWebSocketFilter,
        encodeWith encoder: JSONEncoder = JSONEncoder(),
        decodedWith decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<BithumbOrderBookDepthsResponseDTO, Error> {
        do {
            let converted = try encoder.encode(filter)
            socketConnector.write(data: converted)
        } catch {
            return Fail<BithumbOrderBookDepthsResponseDTO, Error>(error: error)
                .eraseToAnyPublisher()
        }
        
        return socketConnector.dataPublisher
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
