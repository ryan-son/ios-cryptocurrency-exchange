//
//  TransactionListEnviroment.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/11.
//

import Foundation

struct TransactionListEnvironment {
    let transactionListUseCase: () -> TransactionListUseCaseProtocol
    let toastClient: ToastClient
}
