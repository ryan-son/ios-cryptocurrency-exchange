//
//  API+BithumbREST.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/26.
//

import Foundation
import Moya

extension API.BithumbREST: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.bithumb.com")!
    }
    
    var path: String {
        switch self {
        case .ticker:
            return "/public/ticker/ALL_KRW"
        case let .orderbook(symbol):
            return "/public/orderbook/\(symbol)"
        case let .transactionHistory(symbol):
            return "/public/transaction_history/\(symbol)"
        case let .candleStick(symbol):
            return "/public/candlestick/\(symbol)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .ticker:
            return .get
        case .orderbook:
            return .get
        case .transactionHistory:
            return .get
        case .candleStick:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .ticker:
            return .requestPlain
        case .orderbook:
            return .requestPlain
        case .transactionHistory:
            return .requestPlain
        case .candleStick:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .ticker:
            return nil
        case .orderbook:
            return nil
        case .transactionHistory:
            return nil
        case .candleStick:
            return nil
        }
    }
}
