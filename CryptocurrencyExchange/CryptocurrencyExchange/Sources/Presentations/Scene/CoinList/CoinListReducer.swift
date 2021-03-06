//
//  CoinListReducer.swift
//  CryptocurrencyExchange
//
//  Created by 김정상 on 2022/03/12.
//

import ComposableArchitecture

let coinListReducer = Reducer<
    CoinListState, CoinListAction, CoinListEnvironment
>.combine(
    coinItemReducer.forEach(
        state: \.refinedItems,
        action: /CoinListAction.coinItem(id:action:),
        environment: { _ in
            CoinItemEnvironment(
                tickerUseCase: { TickerUseCase() }
            )
        }
    ),
    Reducer { state, action, environment in
        struct CancelId: Hashable {}
        let cancelId = CancelId()
        switch action {
        case let .search(query):
            state.searchedQuery = query
            return Effect(value: .refinedCoinItems(state.items))
        case let .updateSortType(sortType):
            state.sortType = sortType
            return Effect(value: .refinedCoinItems(state.items))
        case let .updateCoinItems(result):
            switch result {
            case let .success(items):
                return Effect(value: .refinedCoinItems(items))
            case let .failure(error):
                return Effect.merge(
                    Effect(value: .onAppear),
                    Effect(value: .showToast(message: "\(error.localizedDescription)"))
                )
            }
        case let .refinedCoinItems(items):
            refineItems(
                stateRefinedItems: &state.refinedItems,
                items: items,
                searchQuery: state.searchedQuery,
                sortType: state.sortType
            )
            return .none
        case .coinItem:
            return .none
        case .onAppear:
            return fetchTickers(
                searchAction: action,
                environment: environment,
                cancelId: cancelId
            )
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
    searchAction: CoinListAction,
    environment: CoinListEnvironment,
    cancelId: AnyHashable
) -> Effect<CoinListAction, Never> {
    var coinItemStates = [CoinItemState]()
    let useCase = environment.tickerUseCase()
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
        .eraseToAnyPublisher()
        .mapError { error in
            Log.error("Error: \(error)")
            return CoinListError.description("다시 연결 중...")
        }
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
        .catchToEffect()
        .map(CoinListAction.updateCoinItems(result:))
        .cancellable(id: cancelId, cancelInFlight: true)
}

fileprivate func refineItems(
    stateRefinedItems: inout IdentifiedArray<CoinItemState.ID, CoinItemState>,
    items: [CoinItemState],
    searchQuery: String,
    sortType: CoinListSortType
) {
    let refinedItems = items
        .filter { item in
            if searchQuery.isEmpty {
                return true
            }
            return item.name.lowercased()
                .contains(searchQuery.lowercased())
        }
        .sorted(by: {
            switch sortType {
            case .priceASC:
                return $0.price < $1.price
            case .priceDESC:
                return $0.price > $1.price
            case .changeRateASC:
                return $0.changeRate < $1.changeRate
            case .changeRateDESC:
                return $0.changeRate > $1.changeRate
            case .like:
                if $0.isLiked {
                    return true
                }
                return $0.price > $1.price
            }
        })
    stateRefinedItems = IdentifiedArray(uniqueElements: refinedItems)
}
