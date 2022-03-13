//
//  CoinListAction.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/12.
//

import Foundation

import ComposableArchitecture

enum CoinListAction: Equatable {
    case coinItem(id: CoinItemState.ID, action: CoinItemAction)
    case coinDetail(CoinDetailAction)
    case setCoinDetailViewSelection(symbol: String?)
    case onAppear
    case onDisappear
    case updateCoinItems(result: Result<[CoinItemState], CoinListError>)
    case showToast(message: String)
}
