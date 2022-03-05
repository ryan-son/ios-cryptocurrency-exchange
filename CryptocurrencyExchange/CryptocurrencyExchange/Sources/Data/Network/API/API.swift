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
    enum BithumbWebSocket {
        case `public`
    }
    
    enum BithumbREST {
        case ticker
    }
}
