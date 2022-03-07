//
//  AnyPublisher+FilterSocketTopicType.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/07.
//

import Foundation

import Combine

extension Publisher where Output == Data, Failure == Error {
    func filterSocketTopicType(
        filter: BithumbWebSocketFilter,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<Data, Error> {
        self.filter { data in
            do {
                let decoded = try decoder.decode(
                    BithumbResultSocketResponseDTO.self,
                    from: data
                )
                return decoded.type == filter.type
            } catch {
                Log.error(error)
                return false
            }
        }
        .eraseToAnyPublisher()
    }
}
