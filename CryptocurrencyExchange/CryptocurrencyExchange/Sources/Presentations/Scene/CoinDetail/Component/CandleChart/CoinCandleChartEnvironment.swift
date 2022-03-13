//
//  CoinCandleChartEnvironment.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

struct CoinCandleChartEnvironment {
    var candleChartUseCase: CoinCandleChartUseCaseProtocol
    var tickerUseCase: () -> TickerUseCaseProtocol
    var toastClient: ToastClient
}
