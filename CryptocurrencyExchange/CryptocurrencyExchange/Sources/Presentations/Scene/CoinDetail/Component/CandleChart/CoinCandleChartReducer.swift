//
//  CoinCandleChartReducer.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//
import Combine
import OrderedCollections

import ComposableArchitecture

let coinCandleChartReducer = Reducer<
    CoinCandleChartState, CoinCandleChartAction, CoinCandleChartEnvironment
> { state, action, environment in
    struct CancelId: Hashable { }
    switch action {
    case .onAppear:
        return fetchCandleItems(
            symbol: state.symbol,
            coinListEnvironment: CoinListEnvironment( // TODO: UseCase 정리하면서 이 부분 정리
                coinListUseCase: { CoinListUseCase() },
                toastClient: ToastClient.live
            ),
            coinCandleChartEnvironment: environment,
            cancelId: CancelId()
        )
    case let .updateCoinCandleChartItemStates(result):
        switch result {
        case let .success(items):
            state.dataEntries = items
            return .none
        case let .failure(error):
            return Effect.merge(
                Effect(value: .onAppear),
                Effect(value: .showToast(message: "\(error.localizedDescription)"))
            )
        }
    case .onDisappear:
        return .cancel(id: CancelId())
    case let .showToast(message):
        let model = ToastModel(duration: 3, message: message)
        return environment.toastClient.show(model)
            .fireAndForget()
    }
}

fileprivate func fetchCandleItems(
    symbol: String,
    coinListEnvironment: CoinListEnvironment,
    coinCandleChartEnvironment: CoinCandleChartEnvironment,
    cancelId: AnyHashable
) -> Effect<CoinCandleChartAction, Never> {
    var coinCandleChartItemStates = OrderedDictionary<String, CoinCandleChartItemState>()
    
    let coinListUseCase = coinListEnvironment.coinListUseCase()
    let coinCandleChartUseCase = coinCandleChartEnvironment.useCase
    
    return coinCandleChartUseCase.getCandleStickSinglePublisher(symbol: symbol)
        .map { result in
            result.data.map {
                $0.toCoinCandleChartItemState()
            }
        }
        .handleEvents(
            receiveOutput: {
                $0.forEach {
                    let key = $0.date.format(with: "yyyy-MM-dd")
                    coinCandleChartItemStates[key] = $0
                }
            }
        )
        .flatMap { it in
            coinListUseCase
                .getTickerStreamPublisher(
                    symbols: [symbol],
                    tickTypes: [.day]
                )
                .map { [$0] }
                .merge(
                    with: Just([]).setFailureType(to: Error.self)
                )
        }
        .map { tickers in
            tickers.map { $0.toCoinCandleChartItemState() }
        }
        .map { updateStates -> [CoinCandleChartItemState] in
            guard let updateState = updateStates.first else {
                return Array(coinCandleChartItemStates.values)
            }
            let key = updateState.date.format(with: "yyyy-MM-dd")
            coinCandleChartItemStates[key] = updateState
            return Array(coinCandleChartItemStates.values)
        }
        .eraseToAnyPublisher()
        .mapError { error in
            Log.error("Error: \(error)")
            return CoinCandleChartError.description("다시 연결 중...")
        }
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
        .catchToEffect()
        .map(CoinCandleChartAction.updateCoinCandleChartItemStates(result:))
        .cancellable(id: cancelId, cancelInFlight: true)
}
