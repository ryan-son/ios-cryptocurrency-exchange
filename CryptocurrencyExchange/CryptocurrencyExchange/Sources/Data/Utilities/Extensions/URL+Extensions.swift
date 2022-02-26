//
//  URL+Extensions.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//

import Foundation

extension URL {
    static func make(
        with webSocketAPI: SocketTargetType
    ) -> URL? {
        guard var urlComponents = URLComponents(string: webSocketAPI.baseURL) else {
            return nil
        }
        urlComponents.scheme = webSocketAPI.scheme
        urlComponents.path += webSocketAPI.path

        guard let url = urlComponents.url else {
            return nil
        }
        return url
    }
}
