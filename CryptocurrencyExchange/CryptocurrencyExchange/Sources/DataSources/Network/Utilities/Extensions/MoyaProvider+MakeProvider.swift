//
//  MoyaProvider+makeService.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/26.
//

import Moya

extension MoyaProvider {
    static func makeService() -> MoyaProvider {
        return MoyaProvider(
            plugins: [
                NetworkLoggerPlugin()
            ]
        )
    }
}

