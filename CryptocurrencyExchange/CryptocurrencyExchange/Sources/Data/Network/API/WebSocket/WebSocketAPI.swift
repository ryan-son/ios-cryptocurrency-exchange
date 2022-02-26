//
//  WebSocketAPI.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/26.
//

import Foundation

extension API.WebSocket: BithumbSocketType {
    var path: String {
        switch self {
        case .public:
            return "/pub/ws"
        }
    }
}
