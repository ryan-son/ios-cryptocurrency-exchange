//
//  CoinListUseCase.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/27.
//

import Combine
import Foundation

protocol CoinListUseCaseProtocol {
    func getSymbols() -> AnyPublisher<[TickerSymbol], Error>
    func getTickerPublisher(
        symbols: [String],
        tickTypes: [TickType]
    ) -> AnyPublisher<BithumbTicker, Error>
    func getTransactionPublisher(
        symbols: [String]
    ) -> AnyPublisher<[BithumbTransaction], Error>
    func getOrderBookDepthPublisher(
        symbols: [String]
    ) -> AnyPublisher<[BithumbOrderBookDepth], Error>
}

struct CoinListUseCase: CoinListUseCaseProtocol {
    private let tickerRepository: TickerRepositoryProtocol
    private let bithumbRepository: BithumbRepositoryProtocol

    init(
        tickerRepository: TickerRepositoryProtocol = TickerRepository(),
        bithumbRepository: BithumbRepositoryProtocol = BithumbRepository()
    ) {
        self.tickerRepository = tickerRepository
        self.bithumbRepository = bithumbRepository
    }

    func getSymbols() -> AnyPublisher<[TickerSymbol], Error> {
        return tickerRepository.getSymbols()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }

    func getTickerPublisher(
        symbols: [String],
        tickTypes: [TickType]
    ) -> AnyPublisher<BithumbTicker, Error> {
        let filter = BithumbWebSocketFilter(
            type: .ticker,
            symbols: symbols,
            tickTypes: tickTypes
        )
        return bithumbRepository
            .getTickerPublisher(with: filter)
            .map { $0.content.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getTransactionPublisher(
        symbols: [String]
    ) -> AnyPublisher<[BithumbTransaction], Error> {
        let filter = BithumbWebSocketFilter(
            type: .transaction,
            symbols: symbols,
            tickTypes: nil
        )
        return bithumbRepository
            .getTransactionPublisher(with: filter)
            .map{ $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getOrderBookDepthPublisher(
        symbols: [String]
    ) -> AnyPublisher<[BithumbOrderBookDepth], Error> {
        let filter = BithumbWebSocketFilter(
            type: .orderBookDepth,
            symbols: symbols,
            tickTypes: nil
        )
        return bithumbRepository
            .getOrderBookDepthPublisher(with: filter)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
