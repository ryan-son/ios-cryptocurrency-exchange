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
}
