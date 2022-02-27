//
//  TickerRepository.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/26.
//

import Combine

protocol TickerRepositoryProtocol {
    func getSymbols() -> AnyPublisher<TickerSymbolsResponseDTO, Error>
}

struct TickerRepository: TickerRepositoryProtocol {
    private let provider: TickerProvider
    
    init(
        provider: TickerProvider = TickerProvider()
    ) {
        self.provider = provider
    }
    
    func getSymbols() -> AnyPublisher<TickerSymbolsResponseDTO, Error> {
        return provider.getSymbols()
    }
}
