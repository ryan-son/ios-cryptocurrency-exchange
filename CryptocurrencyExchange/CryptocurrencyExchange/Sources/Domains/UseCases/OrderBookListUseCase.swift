//
//  OrderBookListUseCase.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/09.
//

import Combine
import Foundation

protocol OrderBookListUseCaseProtocol {
    func getLatelyTransactionSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbTransactionHistroySingle?, Error>
    
    func getOrderbookSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbOrderbookSingle, Error>
    
    func getOrderBookDepthStreamPublisher(
        symbols: [String]
    ) -> AnyPublisher<[BithumbOrderBookDepthStream], Error>
}

struct OrderBookListUseCase: OrderBookListUseCaseProtocol {
    private let repository: BithumbRepositoryProtocol

    init(
        repository: BithumbRepositoryProtocol = BithumbRepository()
    ) {
        self.repository = repository
    }
    
    func getLatelyTransactionSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbTransactionHistroySingle?, Error> {
        return repository
            .getTransactionHistorySinglePublisher(symbol: symbol)
            .map { $0.toDomain(symbol: symbol).first }
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
