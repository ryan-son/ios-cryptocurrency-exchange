//
//  BithumbSocketType.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//

import Foundation

protocol BithumbSocketType: SocketTargetType { }

extension BithumbSocketType {
    var baseURL: String {
        return "pubwss.bithumb.com"
    }
}
