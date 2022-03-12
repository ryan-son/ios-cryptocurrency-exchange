//
//  CoinPriceView.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/12.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct CoinPriceState: Equatable {
    let symbol: String
    var nowPrice: Double?
}

extension CoinPriceState {
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

enum CoinPriceAction: Equatable {
    case onAppear
    case onDisappear
    case responseTransactionSingle(Result<[BithumbTransactionHistroySingle], OrderBookListError>)
    case responseTransactionStream(Result<[BithumbTransactionStream], OrderBookListError>)
}

struct CoinPriceEnvironment {
    let useCase: TransactionListUseCaseProtocol
}

let coinPriceReducer = Reducer<
    CoinPriceState, CoinPriceAction, CoinPriceEnvironment
> { state, action, environment in
    
    struct CoinPriceCancelId: Hashable {}
    
    switch action {
    case .onAppear:
        return .merge(
            environment.useCase
                .getTransactionHistorySinglePublisher(symbol: state.symbol)
                .receive(on: DispatchQueue.main)
                .mapError { OrderBookListError.description($0.localizedDescription) }
                .catchToEffect(CoinPriceAction.responseTransactionSingle)
            ,
            environment.useCase
                .getTransactionStreamPublisher(symbols: [state.symbol])
                .receive(on: DispatchQueue.main)
                .mapError { OrderBookListError.description($0.localizedDescription) }
                .catchToEffect(CoinPriceAction.responseTransactionStream)
                .cancellable(id: CoinPriceCancelId())
        )
        
    case .onDisappear:
        return .cancel(id: CoinPriceCancelId())
        
    case let .responseTransactionSingle(.success(transactions)):
        if let nowPrice = transactions.first?.contPrice {
            state.nowPrice = nowPrice
        }
        return .none
        
    case let .responseTransactionSingle(.failure(error)):
        Log.error(error)
        return .none
        
    case let .responseTransactionStream(.success(transactions)):
        if let nowPrice = transactions.first?.contPrice {
            state.nowPrice = nowPrice
        }
        return .none
        
    case let .responseTransactionStream(.failure(error)):
        Log.error(error)
        return .none
        
    }
}

struct CoinPriceView: View {
    let store: Store<CoinPriceState, CoinPriceAction>
    
    var body: some View {
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
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        }
    }
}

struct CoinPriceView_Previews: PreviewProvider {
    static var previews: some View {
        CoinPriceView(
            store: Store(
                initialState: CoinPriceState(symbol: "BTC_KRW"),
                reducer: coinPriceReducer,
                environment: CoinPriceEnvironment(
                    useCase: TransactionListUseCase()
                )
            )
        )
    }
}
