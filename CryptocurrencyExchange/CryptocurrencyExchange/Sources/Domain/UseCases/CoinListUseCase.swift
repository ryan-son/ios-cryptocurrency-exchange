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
        type: BithumbWebSocketTopicType,
        symbols: [String],
        tickTypes: [TickType]
    ) -> AnyPublisher<[BithumbTicker], Error>
    func getTransactionPublisher(
        type: BithumbWebSocketTopicType,
        symbols: [String]
    ) -> AnyPublisher<BithumbTransactionsResponseDTO, Error>
    func getOrderBookDepthPublisher(
        type: BithumbWebSocketTopicType,
        symbols: [String]
    ) -> AnyPublisher<BithumbOrderBookDepthsResponseDTO, Error>
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
        type: BithumbWebSocketTopicType,
        symbols: [String],
        tickTypes: [TickType]
    ) -> AnyPublisher<[BithumbTicker], Error> {
        let filter = BithumbWebSocketFilter(type: type, symbols: symbols, tickTypes: tickTypes)
        return bithumbRepository.getTickerPublisher(with: filter)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getTransactionPublisher(
        type: BithumbWebSocketTopicType,
        symbols: [String]
    ) -> AnyPublisher<BithumbTransactionsResponseDTO, Error> {
        let filter = BithumbWebSocketFilter(type: type, symbols: symbols, tickTypes: nil)
        return bithumbRepository.getTransactionPublisher(with: filter)
    }
    
    func getOrderBookDepthPublisher(
        type: BithumbWebSocketTopicType,
        symbols: [String]
    ) -> AnyPublisher<BithumbOrderBookDepthsResponseDTO, Error> {
        let filter = BithumbWebSocketFilter(type: type, symbols: symbols, tickTypes: nil)
        return bithumbRepository.getOrderBookDepthPublisher(with: filter)
    }
}
