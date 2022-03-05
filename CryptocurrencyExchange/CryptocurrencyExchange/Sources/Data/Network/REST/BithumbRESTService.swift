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
}





