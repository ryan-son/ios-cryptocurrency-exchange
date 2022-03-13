//
//  ToastView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/09.
//

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        GeometryReader { proxy in
            HStack {
                Text(message)
                    .font(.body)
                    .fontWeight(.semibold)
                    .padding()
            }
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(proxy.size.height / 2)
            .shadow(color: .gray, radius: 3)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .transition(.move(edge: .top))
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(message: "다시 시도해주세요")
            .previewLayout(.sizeThatFits)
    }
}
