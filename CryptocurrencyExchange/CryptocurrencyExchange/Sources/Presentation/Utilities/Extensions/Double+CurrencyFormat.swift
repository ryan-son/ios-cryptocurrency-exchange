//
//  Double+CurrencyFormat.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/01.
//

import Foundation

enum Currency {
    case won
    case dollar
}

extension Double {
    func format(to currency: Currency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting

        switch currency {
        case .won:
            formatter.locale = Locale(identifier: "ko_KR")
        case .dollar:
            formatter.locale = Locale(identifier: "en_US")
        }

        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
