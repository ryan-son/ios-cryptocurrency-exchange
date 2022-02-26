//
//  API.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//

import Foundation
import CombineMoya
import Moya

enum API {

    enum WebSocket {
        case `public`
    }
}

extension API.WebSocket: BithumbSocketType {

    var path: String {
        switch self {
        case .public:
            return "/pub/ws"
        }
    }
}
