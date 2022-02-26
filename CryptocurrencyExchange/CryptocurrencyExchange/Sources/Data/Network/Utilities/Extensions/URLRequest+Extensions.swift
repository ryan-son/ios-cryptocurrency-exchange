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
    ) -> URLRequest? {
        guard let url = URL.make(with: webSocketAPI) else {
            return nil
        }
        return URLRequest(url: url)
    }
}
