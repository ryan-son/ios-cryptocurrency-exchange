//
//  OrderLayoutState.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/12.
//

import Foundation

struct OrderLayoutState: Equatable {
    let symbol: String
    var selection = OrderLayoutView.TapBarList.transaction
}
