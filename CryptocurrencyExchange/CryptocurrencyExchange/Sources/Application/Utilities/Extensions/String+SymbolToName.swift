//
//  String+SymbolToName.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/13.
//

import Foundation

extension String {
    func symbolToName() -> String {
        return self.replacingOccurrences(of: "_KRW", with: "")
    }
}
