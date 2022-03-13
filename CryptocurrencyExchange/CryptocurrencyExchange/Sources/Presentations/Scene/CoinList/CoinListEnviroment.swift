//
//  CoinListEnviroment.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/12.
//

import Foundation

struct CoinListEnvironment {
    let tickerUseCase: () -> TickerUseCaseProtocol
    let toastClient: ToastClient
}
