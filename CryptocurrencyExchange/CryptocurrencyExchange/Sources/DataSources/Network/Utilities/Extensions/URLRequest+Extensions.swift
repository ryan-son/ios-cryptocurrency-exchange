//
//  URLRequest+Extensions.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//

import Foundation

extension URLRequest {
    static func make(
        with webSocketAPI: SocketTargetType
    ) -> URLRequest {
        do {
            let url = try URL.make(with: webSocketAPI)
            return URLRequest(url: url)
        } catch {
            preconditionFailure("URLRequest generation failure: \(error)")
        }
    }
}
