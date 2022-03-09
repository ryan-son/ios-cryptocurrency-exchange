//
//  TransactionListUseCase.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/27.
//

import Combine
import Foundation

protocol TransactionListUseCaseProtocol {
    func getTickerSinglePublisher() -> AnyPublisher<[BithumbTickerSingle], Error>
    func getOrderbookSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbOrderbookSingle, Error>
    func getTransactionHistorySinglePublisher(
        symbol: String
    ) -> AnyPublisher<[BithumbTransactionHistroySingle], Error>
    func getTickerStreamPublisher(
        symbols: [String],
        tickTypes: [TickType]
    ) -> AnyPublisher<BithumbTickerStream, Error>
    func getTransactionStreamPublisher(
        symbols: [String]
    ) -> AnyPublisher<[BithumbTransactionStream], Error>
    func getOrderBookDepthStreamPublisher(
        symbols: [String]
    ) -> AnyPublisher<[BithumbOrderBookDepthStream], Error>
}

struct TransactionListUseCase: TransactionListUseCaseProtocol {
    private let repository: BithumbRepositoryProtocol

    init(
        repository: BithumbRepositoryProtocol = BithumbRepository()
    ) {
        self.repository = repository
    }

    func getTickerSinglePublisher() -> AnyPublisher<[BithumbTickerSingle], Error> {
        return repository.getTickerSinglePublisher()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getOrderbookSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbOrderbookSingle, Error> {
        return repository
            .getOrderbookSinglePublisher(
                symbol: symbol
            )
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getTransactionHistorySinglePublisher(
        symbol: String
    ) -> AnyPublisher<[BithumbTransactionHistroySingle], Error> {
        return repository
            .getTransactionHistorySinglePublisher(
                symbol: symbol
            )
            .map {
                $0.toDomain(
                    symbol: symbol
                )
            }
            .eraseToAnyPublisher()
    }

    func getTickerStreamPublisher(
        symbols: [String],
        tickTypes: [TickType]
    ) -> AnyPublisher<BithumbTickerStream, Error> {
        let filter = BithumbWebSocketFilter(
            type: .ticker,
            symbols: symbols,
            tickTypes: tickTypes
        )
        return repository
            .getTickerStreamPublisher(with: filter)
            .map { $0.content.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getTransactionStreamPublisher(
        symbols: [String]
    ) -> AnyPublisher<[BithumbTransactionStream], Error> {
        let filter = BithumbWebSocketFilter(
            type: .transaction,
            symbols: symbols,
            tickTypes: nil
        )
        return repository
            .getTransactionStreamPublisher(with: filter)
            .map{ $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getOrderBookDepthStreamPublisher(
        symbols: [String]
    ) -> AnyPublisher<[BithumbOrderBookDepthStream], Error> {
        let filter = BithumbWebSocketFilter(
            type: .orderBookDepth,
            symbols: symbols,
            tickTypes: nil
        )
        return repository
            .getOrderBookDepthStreamPublisher(with: filter)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}