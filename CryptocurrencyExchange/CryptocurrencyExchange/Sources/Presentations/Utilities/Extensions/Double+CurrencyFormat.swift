//
//  Double+CurrencyFormat.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/01.
//

import Foundation

enum Currency: String {
    case krw
    case usd
    case none
}

extension Double {
    func format(to currency: Currency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        switch currency {
        case .krw:
            formatter.locale = Locale(identifier: "ko_KR")
        case .usd:
            formatter.locale = Locale(identifier: "en_US")
        case .none:
            return String(self)
        }

        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
