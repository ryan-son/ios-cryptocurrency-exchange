//
//  OrderLayoutReducer.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/12.
//

import Foundation

import ComposableArchitecture

let orderLayoutReducer = Reducer<
    OrderLayoutState, OrderLayoutAction, OrderLayoutEnvironment
> { state, action, environment in
    switch action {
    case let .tapBarTapped(tapBarItem):
        state.selection = tapBarItem
        return .none
    }
}
