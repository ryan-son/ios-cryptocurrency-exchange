//
//  BithumbDataResponse.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/02/26.
//

import Foundation

protocol BithumbDataResponse: Decodable {
    associatedtype AnyData: Decodable
    var status: String { get }
    var resmsg: String? { get }
    var data: AnyData? { get }
}
