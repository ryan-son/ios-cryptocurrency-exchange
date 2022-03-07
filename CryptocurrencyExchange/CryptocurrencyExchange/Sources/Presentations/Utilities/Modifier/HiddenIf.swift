//
//  HiddenIf.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/01.
//

import SwiftUI

struct HiddenIf: ViewModifier {
    var isHidden: Bool
    
    func body(content: Content) -> some View {
        if isHidden {
            EmptyView()
        } else {
            content
        }
    }
}

extension View {
    func hiddenIf(isHidden: Bool) -> some View {
        modifier(HiddenIf(isHidden: isHidden))
    }
}
