//
//  OrderBookListReducer.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/12.
//

import Foundation

import ComposableArchitecture

let orderBookListReducer = Reducer<
    OrderBookListState, OrderBookListAction, OrderBookListEnvironment
> { state, action, environment in
    
    struct OrderBookCancelId: Hashable {}
    
    switch action {
    case .onAppear:
        return environment.useCase
                .getOrderBookDepthStreamPublisher(symbols: [state.symbol])
                .receive(on: RunLoop.main)
                .mapError { OrderBookListError.description($0.localizedDescription) }
                .map { $0.filter { $0.quantity > 0 } }
                .catchToEffect(OrderBookListAction.responseOrderBookStream)
                .cancellable(id: OrderBookCancelId())
        
    case .onDisappear:
        return .cancel(id: OrderBookCancelId())
        
    case let .responseOrderBookSingle(.success(orderBooks)):
        
        let sellOrderBooks = orderBooks.sell.prefix(10).reversed()
        let buyOrderBooks = orderBooks.buy.prefix(10)
        
        state.maxQuantity = [
            sellOrderBooks.map(\.quantity).max() ?? 0,
            buyOrderBooks.map(\.quantity).max() ?? 0
        ]
            .max() ?? 0
        
        let sellOrderBookItems = sellOrderBooks.map {
            OrderBookListState.OrderBookItem(
                orderType: .sell,
                price: $0.price,
                quantity: $0.quantity,
                ratio: state.getRatio(quantity: $0.quantity)
            )
        }
        
        let buyOrderBookItems = buyOrderBooks.map {
            OrderBookListState.OrderBookItem(
                orderType: .buy,
                price: $0.price,
                quantity: $0.quantity,
                ratio: state.getRatio(quantity: $0.quantity)
            )
        }
        
        var newOrderBookItems = sellOrderBookItems
        newOrderBookItems += buyOrderBookItems
        state.orderBooks = newOrderBookItems
        
        return Effect(value: .sortOrderBooks)
        
    case let .responseOrderBookSingle(.failure(error)):
        Log.error(error)
        return .none
        
    case let .responseOrderBookStream(.success(orderBooks)):
        orderBooks.forEach { orderBook in
            if let index = state.orderBooks.firstIndex(where: {
                $0.price == orderBook.price && $0.orderType == orderBook.orderType
            }) {
                state.orderBooks[index] = orderBook.toOrderBookItem(
                    ratio: state.getRatio(
                        quantity: orderBook.quantity
                    )
                )
                return
            }
            
            switch orderBook.orderType {
            case .sell:
                if orderBook.price < state.orderBooks.map({ $0.price }).max() ?? Double(Int.max) {
                    state.orderBooks.append(
                        orderBook.toOrderBookItem(
                            ratio: state.getRatio(quantity: orderBook.quantity)
                        )
                    )
                    if state.orderBooks.count > 20 {
                        state.orderBooks.removeFirst()
                    }
//                    if let indexForRemove = state.orderBooks.firstIndex(where: {
//                        $0.orderType == .buy && $0.price > orderBook.price
//                    }) {
//                        state.orderBooks.remove(at: indexForRemove)
//                    }
                }
            case .buy:
                if orderBook.price > state.orderBooks.map({ $0.price }).min() ?? 0 {
                    state.orderBooks.append(
                        orderBook.toOrderBookItem(
                            ratio: state.getRatio(quantity: orderBook.quantity)
                        )
                    )
                    if state.orderBooks.count > 20 {
                        state.orderBooks.removeLast()
                    }
//                    if let indexForRemove = state.orderBooks.firstIndex(where: {
//                        $0.orderType == .sell && $0.price < orderBook.price
//                    }) {
//                        state.orderBooks.remove(at: indexForRemove)
//                    }
                }
            case .none:
                break
            }
        }
        
//        print("---------------------")
//        print(state.orderBooks.map { "price: \($0.price), quantity: \($0.quantity)\n" })
//        print("---------------------")
        if state.orderBooks.count != 20 {
            return environment.useCase
                .getOrderbookSinglePublisher(symbol: state.symbol)
                .mapError { OrderBookListError.description($0.localizedDescription) }
                .catchToEffect(OrderBookListAction.responseOrderBookSingle)
        }
        
        return Effect(value: .sortOrderBooks)
        
    case let .responseOrderBookStream(.failure(error)):
        Log.error(error)
        return .none
        
    case .sortOrderBooks:
        state.orderBooks.sort(by: >)
        state.maxQuantity = state.orderBooks.map(\.quantity).max() ?? state.maxQuantity
        return .none
    }
}
