//
//  CoinListView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/01.
//

import ComposableArchitecture
import SwiftUI
import IdentifiedCollections

struct CoinListState: Equatable {
    var items: IdentifiedArrayOf<CoinItemState>
    var selectedItem: Identified<CoinItemState.ID, CoinItemState>?
}

enum CoinListAction {
    case coinItem(id: CoinItemState.ID, action: CoinItemAction)
    case coinItemTapped
}

struct CoinListEnvironment {

}

let coinListReducer = Reducer<
    CoinListState, CoinListAction, CoinListEnvironment
>.combine(
    coinItemReducer.forEach(
        state: \.items,
        action: /CoinListAction.coinItem(id:action:),
        environment: { _ in CoinItemEnvironment() }
    ),
    Reducer { state, action, enviroment in
        switch action {
        case .coinItem:
            return .none
        case .coinItemTapped:
            return .none
        }
    }
)

struct CoinListView: View {
    let store: Store<CoinListState, CoinListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                ForEachStore(
                    self.store.scope(
                        state: \.items,
                        action: CoinListAction.coinItem(id:action:)
                    ),
                    content: CoinItemView.init
                )
            }
            .listStyle(.plain)
            .buttonStyle(.plain)
            
        }
    }
}

extension IdentifiedArray where ID == CoinItemState.ID, Element == CoinItemState {
    static let mock: Self = [
        CoinItemState(
            rank: nil,
            name: "비트코인",
            price: 78427482.42,
            changeRate: 1.24,
            isLiked: false,
            symbol: "BTC_USD"
        ),
        CoinItemState(
            rank: nil,
            name: "이더리움",
            price: 78427482.42,
            changeRate: -1.24,
            isLiked: true,
            symbol: "ETH_USD"
        )
    ]
}


struct CoinListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView(
            store: Store(
                initialState: CoinListState(items: .mock),
                reducer: coinListReducer,
                environment: CoinListEnvironment()
            )
        )
            .preferredColorScheme(.dark)
    }
}


//NavigationLink(
//    tag: <#T##Hashable#>,
//    selection: <#T##Binding<Hashable?>#>,
//    destination: <#T##() -> _#>, label: {
//
//    })
//ForEachStore(
//    self.store.scope(
//        state: \.items,
//        action: CoinListAction.coinItem(id:action:)
//    ),
//    content: CoinItemView.init
//)
//
//
//ForEach(viewStore.items) { item in
//    NavigationLink(
//        tag: item.id,
//        selection: viewStore.binding(
//            get: \.selectedItem?.id,
//            send: viewStore.send(.coinItemTapped)
//        ),
//        destination: Text("디테일")
//    ) {
//        CoinItemView(
//            store: Store(
//        )
//    }
//}
