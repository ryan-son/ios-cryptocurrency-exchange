//
//  CoinCandleChartReducer.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

import ComposableArchitecture

let coinCandleChartReducer = Reducer<
    CoinCandleChartState, CoinCandleChartAction, CoinCandleChartEnvironment
> { state, action, environment in
    struct CancelId: Hashable { }
    switch action {
    case .onAppear:
//        let useCase = environment.useCase()
        return environment.useCase
            .getCandleStickSinglePublisher(symbol: state.symbol)
            .receive(on: DispatchQueue.main)
            .catchToEffect(CoinCandleChartAction.coinCandleResponse)
            .cancellable(id: CancelId())
    case let .coinCandleResponse(.success(candleStickSingle)):
//        state.dataEntries = candleStickSingle.data.map { $0.toDataEntry() }
        state.dataEntries = candleStickSingle.data
        return .none
    case let .coinCandleResponse(.failure(error)):
        return Effect.merge(
            Effect(value: .onAppear),
            Effect(value: .showToast(message: "\(error.localizedDescription)"))
        )
    case .onDisappear:
        return .cancel(id: CancelId())
    case let .showToast(message):
        let model = ToastModel(duration: 3, message: message)
        return environment.toastClient.show(model)
            .fireAndForget()
    }
}
