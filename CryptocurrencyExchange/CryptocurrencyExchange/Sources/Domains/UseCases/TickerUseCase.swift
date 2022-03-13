//
//  TickerUseCase.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/13.
//

import Combine
import Foundation

protocol TickerUseCaseProtocol {
    func getTickerAllSinglePublisher() -> AnyPublisher<[BithumbTickerSingle], Error>
    func getTickerSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbTickerSingle, Error>
    func getTickerStreamPublisher(
        symbols: [String],
        tickTypes: [TickType]
    ) -> AnyPublisher<BithumbTickerStream, Error>
    func getCoinIsLikeState(for coinName: String) -> Bool
    func saveCoinIsLikeState(for coinName: String, isLike: Bool)
}

struct TickerUseCase: TickerUseCaseProtocol {
    private let repository: BithumbRepositoryProtocol

    init(
        repository: BithumbRepositoryProtocol = BithumbRepository()
    ) {
        self.repository = repository
    }

    func getTickerAllSinglePublisher() -> AnyPublisher<[BithumbTickerSingle], Error> {
        return repository.getTickerAllSinglePublisher()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getTickerSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbTickerSingle, Error> {
        return repository
            .getTickerSinglePublisher(
                symbol: symbol
            )
            .map { $0.toDomain(symbol: symbol) }
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
    
    func getCoinIsLikeState(for coinName: String) -> Bool {
        return repository.getCoinIsLikeState(for: coinName)
    }
    
    func saveCoinIsLikeState(for coinName: String, isLike: Bool) {
        repository.saveCoinIsLikeState(for: coinName, isLike: isLike)
    }
}
