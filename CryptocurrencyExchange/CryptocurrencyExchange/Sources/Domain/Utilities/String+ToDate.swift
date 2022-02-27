//
//  String+ToDate.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/28.
//

import Foundation

extension String {
    enum DateFormat: String {
        case yyyyMMddHHmmss
    }

    func toDate(format: DateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.date(from: self)
    }
}
