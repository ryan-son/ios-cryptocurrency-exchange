//
//  URL+Extensions.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//

import Foundation

enum URLComponentsError: Error {
    case invalidBaseURL
    case creationFailed
}

extension URL {
    static func make(
        with webSocketAPI: SocketTargetType
    ) throws -> URL {
        guard var urlComponents = URLComponents(string: webSocketAPI.baseURL) else {
            throw URLComponentsError.invalidBaseURL
        }
        urlComponents.scheme = webSocketAPI.scheme
        urlComponents.path += webSocketAPI.path

        guard let url = urlComponents.url else {
            throw URLComponentsError.creationFailed
        }
        return url
    }
}
