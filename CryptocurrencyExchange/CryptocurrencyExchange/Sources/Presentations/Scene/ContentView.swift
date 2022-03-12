//
//  ContentView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//
import Combine
import SwiftUI

import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        NavigationView {
            CoinListView(
                store: Store(
                    initialState: CoinListState(items: []),
                    reducer: coinListReducer,
                    environment: CoinListEnvironment(
                        coinListUseCase: {
                            CoinListUseCase()
                        },
                        toastClient: .live
                    )
                )
            )
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
