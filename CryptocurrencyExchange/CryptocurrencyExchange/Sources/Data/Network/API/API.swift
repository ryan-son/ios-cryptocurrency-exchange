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
    
    enum Ticker {
        case symbols
    }
}
