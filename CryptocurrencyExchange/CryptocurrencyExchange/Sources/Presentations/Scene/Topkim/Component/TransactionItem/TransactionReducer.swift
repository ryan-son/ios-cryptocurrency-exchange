//
//  TransactionReducer.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/09.
//

import ComposableArchitecture

let transactionReducer = Reducer<
    TransactionItemState, TransactionItemAction, TransactionItemEnviroment
> { state, action, environment in
    return .none
}
