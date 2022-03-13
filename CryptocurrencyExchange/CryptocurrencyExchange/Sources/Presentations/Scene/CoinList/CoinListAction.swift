//
//  CoinListAction.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/12.
//

import Foundation

enum CoinListAction: Equatable {
    case search(query: String)
    case updateSortType(CoinListSortType)
    case coinItem(id: CoinItemState.ID, action: CoinItemAction)
    case onAppear
    case onDisappear
    case updateCoinItems(result: Result<[CoinItemState], CoinListError>)
    case refinedCoinItems([CoinItemState])
    case showToast(message: String)
}
