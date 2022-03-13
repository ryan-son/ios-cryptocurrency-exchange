//
//  CoinCandleChartUseCase.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/13.
//

import Combine

protocol CoinCandleChartUseCaseProtocol {
    func getCandleStickSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbCandleStickSingle, Error>
}

struct CoinCandleChartUseCase: CoinCandleChartUseCaseProtocol {
    let repository: BithumbRepositoryProtocol

    init(
        repository: BithumbRepositoryProtocol = BithumbRepository()
    ) {
        self.repository = repository
    }
    
    func getCandleStickSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbCandleStickSingle, Error> {
        return repository.getCandleStickSinglePublisher(symbol: symbol)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
