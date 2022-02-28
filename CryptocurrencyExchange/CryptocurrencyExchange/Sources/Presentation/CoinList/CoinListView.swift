//
//  CoinListView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/01.
//

import ComposableArchitecture
import SwiftUI

struct CoinListState: Equatable {
    
}

enum CoinListAction {
    
}

enum CoinListEnvironment {
    
}

let coinListReducer = Reducer<
    CoinListState, CoinListAction, CoinListEnvironment
> { state, action, environment in
    switch action {
        
    }
}

struct CoinListView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CoinListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView()
    }
}
