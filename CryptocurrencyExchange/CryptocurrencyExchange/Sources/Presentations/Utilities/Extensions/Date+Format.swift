//
//  Date+Format.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import Foundation

extension Date {
    func format(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
