//
//  AnyPublisher+Decode.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/05.
//

import Foundation

import Combine
import CombineMoya
import Moya


extension Publisher where Output == Data, Failure == Error {
    func compactMapDecode<T: Decodable>(type: T.Type, decoder: JSONDecoder) -> AnyPublisher<T, Error> {
        compactMap { data -> T? in
            do {
                let decoded = try decoder.decode(T?.self, from: data)
                return decoded
            } catch {
                Log.error(error)
                return nil
            }
        }
        .eraseToAnyPublisher()
    }
}
