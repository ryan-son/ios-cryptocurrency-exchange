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
        case .tickerAll:
            return "/public/ticker/ALL_KRW"
        case let .ticker(symbol):
            return "/public/ticker/\(symbol)"
        case let .orderBook(symbol):
            return "/public/orderbook/\(symbol)"
        case let .transactionHistory(symbol):
            return "/public/transaction_history/\(symbol)"
        case let .candleStick(symbol):
            return "/public/candlestick/\(symbol)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .tickerAll:
            return .get
        case .ticker:
            return .get
        case .orderBook:
            return .get
        case .transactionHistory:
            return .get
        case .candleStick:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .tickerAll:
            return .requestPlain
        case .ticker:
            return .requestPlain
        case .orderBook:
            return .requestPlain
        case .transactionHistory:
            return .requestPlain
        case .candleStick:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .tickerAll:
            return nil
        case .ticker:
            return nil
        case .orderBook:
            return nil
        case .transactionHistory:
            return nil
        case .candleStick:
            return nil
        }
    }
}
