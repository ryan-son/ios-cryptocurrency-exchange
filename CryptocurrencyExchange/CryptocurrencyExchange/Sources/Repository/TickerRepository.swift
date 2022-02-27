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
    
    func getSymbols() -> AnyPublisher<TickerSymbolsResponseDTO, Error> {
        provider.getSymbols()
    }
}
