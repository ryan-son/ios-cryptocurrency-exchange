//
//  BithumbWebSocketRepository.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/26.
//

import Foundation

struct BithumbRepository {
    private let socketConnector: BithumbSocketConnector
    
    func connect() {
        socketConnector.connect()
    }
    
    func filter() {
    }
}
