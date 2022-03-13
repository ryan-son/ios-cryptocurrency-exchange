//
//  CoinListReducer.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/12.
//

import ComposableArchitecture

//var isLikedCache: [String: Bool] = [:]

let coinListReducer = Reducer<
    CoinListState, CoinListAction, CoinListEnvironment
>.combine(
    coinItemReducer.forEach(
        state: \.items,
        action: /CoinListAction.coinItem(id:action:),
        environment: { _ in
            CoinItemEnvironment(
                useCase: { CoinItemUseCase() }
            )
        }
    ),
    Reducer { state, action, environment in
        struct CancelId: Hashable {}
        let cancelId = CancelId()
        switch action {
        case let .updateCoinItems(result):
            switch result {
            case let .success(items):
                state.items = IdentifiedArray(uniqueElements: items)
                return .none
            case let .failure(error):
                return Effect.merge(
                    Effect(value: .onAppear),
                    Effect(value: .showToast(message: "\(error.localizedDescription)"))
                )
            }
        case .coinItem:
            return .none
        case .coinItemTapped:
            return .none
        case .onAppear:
            return fetchTickers(environment: environment, cancelId: cancelId)
        case .onDisappear:
            return .cancel(id: cancelId)
        case let .showToast(message):
            let model = ToastModel(duration: 3, message: message)
            return environment.toastClient.show(model)
                .fireAndForget()
        }
    }
)

fileprivate func fetchTickers(
    environment: CoinListEnvironment,
    cancelId: AnyHashable
) -> Effect<CoinListAction, Never> {
    var coinItemStates = [CoinItemState]()
    let useCase = environment.coinListUseCase()
    return useCase.getTickerAllSinglePublisher()
        .map { tickers in
            tickers.map { ticker in
                let isLiked = useCase.getCoinIsLikeState(for: ticker.name)
                return ticker.toCoinItemState(isLiked: isLiked)
            }
        }
        .handleEvents(
            receiveOutput: {
                coinItemStates = $0
            }
        )
        .flatMap {
            useCase.getTickerStreamPublisher(
                symbols: $0.map { $0.symbol },
                tickTypes: [.day]
            )
        }
        .map { ticker -> CoinItemState in
            let isLiked = useCase.getCoinIsLikeState(for: ticker.symbol.symbolToName())
            return ticker.toCoinItemState(isLiked: isLiked)
        }
        .map { updateState -> [CoinItemState] in
            // TODO: Dictionary 로 사용 시 cancel 안되는 문제 확인 필요.
            var updateState = updateState
            guard let index = coinItemStates.firstIndex(
                where: {
                    $0.symbol == updateState.symbol
                }
            ) else {
                return coinItemStates
            }
            updateState.id = coinItemStates[index].id
            coinItemStates[index] = updateState
            return coinItemStates
        }
        .map {
            $0.map { state -> CoinItemState in
                var state = state
                let isLiked = useCase.getCoinIsLikeState(for: state.name)
                state.isLiked = isLiked
                return state
            }
        }
        .map {
            $0.sorted(by: {
                $0.price > $1.price
            })
        }
        .eraseToAnyPublisher()
        .mapError { error in
            Log.error("Error: \(error)")
            // TODO: 오류 났을 때 처리 필요.
            return CoinListError.description("다시 연결 중...")
        }
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
        .catchToEffect()
        .map(CoinListAction.updateCoinItems(result:))
        .cancellable(id: cancelId, cancelInFlight: true)
}
