//
//  CoinListState.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/12.
//

import IdentifiedCollections

import ComposableArchitecture

struct CoinListState: Equatable {
    var searchedQuery: String = ""
    var sortType: CoinListSortType = .priceDESC
    var refinedItems: IdentifiedArrayOf<CoinItemState> = IdentifiedArrayOf<CoinItemState>()
    var items: [CoinItemState]
    var toastMessage: String?
}

enum CoinListSortType: Equatable, CaseIterable {
    case priceDESC
    case priceASC
    case changeRateDESC
    case changeRateASC
    case like
    
    var displayValue: String {
        switch self {
        case .priceDESC:
            return "가격순 ↓"
        case .priceASC:
            return "가격순 ↑"
        case .changeRateDESC:
            return "변동률순 ↓"
        case .changeRateASC:
            return "변동률순 ↑"
        case .like:
            return "관심"
        }
    }
}
