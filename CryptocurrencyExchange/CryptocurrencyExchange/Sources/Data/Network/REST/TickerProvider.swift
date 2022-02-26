//
//  MoyaProvider.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/26.
//

import Foundation

import Combine
import CombineMoya
import Moya

struct TickerProvider {
    private let provider = MoyaProvider<API.Ticker>.makeProvider()
        
    func getSymbols() -> AnyPublisher<TickerSymbolsResponseDTO, Error> {
        return provider.requestPublisher(.symbols)
            .vaildate()
            .map(\.data)
            .decode(type: TickerSymbolsResponseDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}





