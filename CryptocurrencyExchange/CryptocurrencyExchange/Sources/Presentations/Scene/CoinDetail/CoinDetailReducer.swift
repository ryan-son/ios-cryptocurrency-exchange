//
//  CoinDetailReducer.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

import ComposableArchitecture

let coinDetailReducer = Reducer<
    CoinDetailState, CoinDetailAction, CoinDetailEnvironment
>.combine([
//    coinCurrentTickerReducer
////        .optional()
//        .pullback(
//            state: \.coinCurrentTicker,
//            action: /CoinDetailAction.coinCurrentTicker,
//            environment: { _ in
//                CoinCurrentTickerEnvironment(
//                    useCase: TransactionUseCase()
//                )
//            }
//        ),
//    coinCandleChartReducer
////        .optional()
//        .pullback(
//            state: \.coinCandleChart,
//            action: /CoinDetailAction.coinCandleChart,
//            environment: { _ in
//                CoinCandleChartEnvironment(
//                    candleChartUseCase: CoinCandleChartUseCase(),
//                    tickerUseCase: { TickerUseCase() },
//                    toastClient: .live
//                )
//            }
//        ),
    Reducer { state, action, environment in
        switch action {
//        case .onAppear:
//            state.coinCurrentTicker = CoinCurrentTickerState(symbol: state.symbol)
//            state.coinCandleChart = CoinCandleChartState(symbol: state.symbol)
//            return .none
//        case .coinCurrentTicker:
//            return .none
//        case .coinCandleChart:
//            return .none
        }
    }
])









