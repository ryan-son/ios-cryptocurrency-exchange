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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .ticker:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .ticker:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .ticker:
            return nil
        }
    }
}
