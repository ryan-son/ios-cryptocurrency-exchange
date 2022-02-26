//
//  SocketTargetType.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//

import Foundation

public protocol SocketTargetType {

    var scheme: String { get }

    /// The target's base `URL`.
    var baseURL: String { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
}

extension SocketTargetType {
    var scheme: String {
        return "wss"
    }
}
