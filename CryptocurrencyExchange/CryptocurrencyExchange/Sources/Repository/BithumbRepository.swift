//
//  BithumbWebSocketRepository.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/26.
//


import Combine
import Foundation

protocol BithumbRepositoryProtocol {
    func getTickerPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbTickersResponseDTO, Error>
    func getTransactionPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbTransactionsResponseDTO, Error>
    func getOrderBookDepthPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbOrderBookDepthsResponseDTO, Error>
}

enum BithumbRepositoryError: Error {
    case notConnected
}

struct BithumbRepository: BithumbRepositoryProtocol {
    private let socketConnector: BithumbSocketConnector

    init(
        socketConnector: BithumbSocketConnector = BithumbSocketConnector()
    ) {
        self.socketConnector = socketConnector
    }
    
    func getTickerPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbTickersResponseDTO, Error> {
        return socketConnector.connect()
            .checkConnect()
            .retry(3)
            .flatMap{ _ in
                socketConnector.getTickerPublisher(with: filter)
            }
            .eraseToAnyPublisher()
    }
    
    func getTransactionPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbTransactionsResponseDTO, Error> {
        return socketConnector.connect()
            .checkConnect()
            .retry(3)
            .flatMap{ _ in
                socketConnector.getTransactionPublisher(with: filter)
            }
            .eraseToAnyPublisher()
    }
    
    func getOrderBookDepthPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbOrderBookDepthsResponseDTO, Error> {
        return socketConnector.connect()
            .checkConnect()
            .retry(3)
            .flatMap{ _ in
                socketConnector.getOrderBookDepthPublisher(with: filter)
            }
            .eraseToAnyPublisher()
    }
}

extension AnyPublisher where Output == Bool, Failure == Never {
    func checkConnect() -> AnyPublisher<Bool, Error> {
        return tryMap { isConnected -> Bool in
            guard isConnected else {
                throw BithumbRepositoryError.notConnected
            }
            return true
        }
        .eraseToAnyPublisher()
    }
}
