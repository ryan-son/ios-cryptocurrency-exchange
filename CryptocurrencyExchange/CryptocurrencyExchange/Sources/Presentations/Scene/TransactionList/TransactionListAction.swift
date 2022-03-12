//
//  TransactionListAction.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/11.
//

import Foundation

enum TransactionListAction: Equatable {
    case transactionItem(id: TransactionItemState.ID, action: TransactionItemAction)
    case onAppear
    case onDisappear
    case updateTransactionItems(result: Result<[TransactionItemState], TransactionListError>)
}
