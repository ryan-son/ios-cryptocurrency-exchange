//
//  CoinListState.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/12.
//

import IdentifiedCollections

import ComposableArchitecture

struct CoinListState: Equatable {
    var items: IdentifiedArrayOf<CoinItemState>
    var toastMessage: String?
}
