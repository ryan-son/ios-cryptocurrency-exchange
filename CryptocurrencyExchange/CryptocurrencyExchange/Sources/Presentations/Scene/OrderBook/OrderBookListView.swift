//
//  OrderBookListView.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/09.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

enum OrderBookListError: Error, Equatable {
    case description(String)
}

extension OrderBookListError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .description(message):
            return message
        }
    }
}

struct OrderBookListState: Equatable {
    let symbol: String
    var nowPrice: Double?
}

extension OrderBookListState {
    func toViewState() -> OrderBookListViewState {
        let symbols = symbol.components(separatedBy: "_")
        let coinSymbol = symbols.first ?? ""
        let currencySymbol = symbols.last ?? ""
        let currency = Currency(rawValue: currencySymbol.lowercased()) ?? .none
        let formattedPrice = nowPrice?.format(to: currency) ?? ""
        let imageURL = URL(
            string: "https://cryptoicon-api.vercel.app/api/icon/\(coinSymbol.lowercased())"
        )
        return OrderBookListViewState(
            symbolName: coinSymbol,
            nowPrice: formattedPrice,
            imageURL: imageURL
        )
    }
}

struct OrderBookListViewState {
    let symbolName: String
    var nowPrice: String
    let imageURL: URL?
}

enum OrderBookListAction: Equatable {
    case onAppear
    case responseNowPrice(Result<BithumbTransactionHistroySingle?, OrderBookListError>)
}

struct OrderBookListEnvironment {
    let useCase: OrderBookListUseCaseProtocol
}

let orderBookListReducer = Reducer<
    OrderBookListState, OrderBookListAction, OrderBookListEnvironment
> { state, action, environment in
    switch action {
    case .onAppear:
        return environment.useCase
            .getLatelyTransactionSinglePublisher(symbol: state.symbol)
            .mapError { OrderBookListError.description($0.localizedDescription) }
            .catchToEffect(OrderBookListAction.responseNowPrice)
    case let .responseNowPrice(.success(transaction)):
        if let nowPrice = transaction?.contPrice {
            state.nowPrice = nowPrice
        }
        return .none
    case let .responseNowPrice(.failure(error)):
        Log.error(error)
        return .none
    }
}

struct OrderBookListView: View {
    let store: Store<OrderBookListState, OrderBookListAction>
    
    init(store: Store<OrderBookListState, OrderBookListAction>) {
        self.store = store
        let viewStore = ViewStore(store)
        viewStore.send(.onAppear)
    }
    
    var body: some View {
            VStack {
                WithViewStore(store) { viewStore in
                    let viewState = viewStore.state.toViewState()
                    HStack(spacing: 16) {
                        KFImage.url(viewState.imageURL)
                            .resizable()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("현재가격")
                                .foregroundColor(Color(#colorLiteral(red: 0.6147381663, green: 0.6195807457, blue: 0.6412109733, alpha: 1)))
                            Text(viewState.nowPrice)
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color(#colorLiteral(red: 0.764742434, green: 0.7645910382, blue: 0.7776351571, alpha: 1)))
                        }
                        Spacer()
                    }
                    .padding(.vertical, 20)
                }
                HStack {
                    Spacer()
                    Text("판매 잔여 수량")
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Text("구매 잔여 수량")
                    Spacer()
                }
                ScrollView {
                    ForEach(0..<20) { _ in
                        OrderBookView()
                    }
                }
            }
            .padding()
    }
}

struct OrderBookListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookListView(
            store: Store(
                initialState: OrderBookListState(
                    symbol: "BTC_KRW"
                ),
                reducer: orderBookListReducer,
                environment: OrderBookListEnvironment(
                    useCase: OrderBookListUseCase()
                )
            )
        )
            .preferredColorScheme(.dark)
    }
}
