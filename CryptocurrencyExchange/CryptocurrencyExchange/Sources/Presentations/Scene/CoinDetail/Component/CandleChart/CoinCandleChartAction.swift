//
//  CoinCandleChartAction.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

import Foundation

enum CoinCandleChartAction {
    case onAppear
    case onDisappear
    case updateCoinCandleChartItemStates(result: Result<[CoinCandleChartItemState], CoinCandleChartError>)
    case showToast(message: String)
}
