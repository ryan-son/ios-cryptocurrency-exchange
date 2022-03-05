//
//  AnyPublisher+Validate.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/26.
//

import Combine
import CombineMoya
import Moya

extension AnyPublisher where Output == Response, Failure == MoyaError {
    func validate() -> AnyPublisher<Response, Error> {
        tryMap { response -> Response in
            let successRange = 200..<300
            guard successRange.contains(response.statusCode) else {
                throw MoyaError.statusCode(response)
            }
            return response
        }
        .eraseToAnyPublisher()
    }
}
