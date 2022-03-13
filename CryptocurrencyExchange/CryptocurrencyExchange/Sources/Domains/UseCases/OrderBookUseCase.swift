//
//  OrderBookUseCase.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/13.
//

import Combine
import Foundation

protocol OrderBookUseCaseProtocol {
    func getOrderBookSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbOrderBookSingle, Error>
    func getOrderBookDepthStreamPublisher(
        symbols: [String]
    ) -> AnyPublisher<[BithumbOrderBookDepthStream], Error>
}

struct OrderBookUseCase: OrderBookUseCaseProtocol {
    private let repository: BithumbRepositoryProtocol

    init(
        repository: BithumbRepositoryProtocol = BithumbRepository()
    ) {
        self.repository = repository
    }

    func getOrderBookSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbOrderBookSingle, Error> {
        return repository
            .getOrderBookSinglePublisher(
                symbol: symbol
            )
            .map { $0.toDomain() }
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
