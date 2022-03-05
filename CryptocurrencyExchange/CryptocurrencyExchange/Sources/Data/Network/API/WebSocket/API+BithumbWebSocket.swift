//
//  BithumbWebSocketAPI.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/26.
//

import Foundation

extension API.BithumbWebSocket: BithumbSocketType {
    var path: String {
        switch self {
        case .public:
            return "/pub/ws"
        }
    }
}
