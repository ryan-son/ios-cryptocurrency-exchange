//
//  OrderBookListView.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/09.
//

import SwiftUI
import Kingfisher

struct OrderBookListView: View {
    var body: some View {
            VStack {
                HStack(spacing: 16) {
                    KFImage.url(URL(string: "https://cryptoicon-api.vercel.app/api/icon/btc"))
                        .resizable()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("현재가격")
                            .foregroundColor(Color(#colorLiteral(red: 0.6147381663, green: 0.6195807457, blue: 0.6412109733, alpha: 1)))
                        Text("\(1038269)원")
                            .bold()
                            .font(.title3)
                            .foregroundColor(Color(#colorLiteral(red: 0.764742434, green: 0.7645910382, blue: 0.7776351571, alpha: 1)))
                    }
                    Spacer()
                }
                .padding(.vertical, 20)
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
        OrderBookListView()
            .preferredColorScheme(.dark)
    }
}
