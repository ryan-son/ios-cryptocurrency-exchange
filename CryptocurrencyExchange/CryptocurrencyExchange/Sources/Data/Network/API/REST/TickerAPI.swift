//
//  TickerAPI.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/26.
//

import Foundation
import Moya

extension API.Ticker: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.bithumb.com")!
    }
    
    var path: String {
        switch self {
        case .symbols:
            return "/public/ticker/ALL_KRW"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .symbols:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .symbols:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .symbols:
            return nil
        }
    }
}
