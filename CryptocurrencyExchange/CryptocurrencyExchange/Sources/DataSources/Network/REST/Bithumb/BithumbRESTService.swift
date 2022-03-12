//
//  RESTBithumbService.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/26.
//

import Foundation

import Combine
import CombineMoya
import Moya

struct BithumbRESTService {
    private let service = MoyaProvider<API.BithumbREST>.makeService()
        
    func getTickers() -> AnyPublisher<BithumbTickerResultRESTResponseDTO, Error> {
        return service.requestPublisher(.ticker)
            .validate()
            .map(\.data)
            .decode(type: BithumbTickerResultRESTResponseDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getOrderbook(
        symbol: String
    ) -> AnyPublisher<BithumbOrderbookResultRESTResponseDTO, Error> {
        return service.requestPublisher(.orderbook(symbol: symbol))
            .validate()
            .map(\.data)
            .decode(type: BithumbOrderbookResultRESTResponseDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getTransactionHistory(
        symbol: String
    ) -> AnyPublisher<BithumbTransactionHistoryResultRESTResponseDTO, Error> {
        return service.requestPublisher(.transactionHistory(symbol: symbol))
            .validate()
            .map(\.data)
            .decode(type: BithumbTransactionHistoryResultRESTResponseDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getCandleStick(
        symbol: String
    ) -> AnyPublisher<BithumbCandleStickResultResponseDTO, Error> {
        return service.requestPublisher(.candleStick(symbol: symbol))
            .validate()
            .map(\.data)
            .receive(on: DispatchQueue.global())
            .decode(type: BithumbCandleStickResultResponseDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}





