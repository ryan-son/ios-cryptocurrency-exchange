//
//  Array+SafeSubscription.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/13.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
