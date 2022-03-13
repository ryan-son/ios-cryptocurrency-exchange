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
        
    func getTickers() -> AnyPublisher<BithumbTickerAllResultRESTResponseDTO, Error> {
        return service.requestPublisher(.tickerAll)
            .validate()
            .map(\.data)
            .decode(type: BithumbTickerAllResultRESTResponseDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getTicker(
        symbol: String
    ) -> AnyPublisher<BithumbTickerResultRESTResponseDTO, Error> {
        return service.requestPublisher(.ticker(symbol: symbol))
            .validate()
            .map(\.data)
            .decode(type: BithumbTickerResultRESTResponseDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getOrderBook(
        symbol: String
    ) -> AnyPublisher<BithumbOrderBookResultRESTResponseDTO, Error> {
        return service.requestPublisher(.orderBook(symbol: symbol))
            .validate()
            .map(\.data)
            .decode(type: BithumbOrderBookResultRESTResponseDTO.self, decoder: JSONDecoder())
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





