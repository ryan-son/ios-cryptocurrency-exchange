//
//  TransactionListState.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/11.
//

import IdentifiedCollections

struct TransactionListState: Equatable {
    var symbol: String
    var items: IdentifiedArrayOf<TransactionItemState>
    var toastMessage: String?
}
