//
//  OrderBookView.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/09.
//

import SwiftUI
import UIKit

struct OrderBookView: View {
    let orderBookItem: OrderBookViewItem
    
    var body: some View {
        HStack(spacing: 12) {
            sellItem()
            Text(orderBookItem.price)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .foregroundColor(Color(#colorLiteral(red: 0.6196818948, green: 0.6193746924, blue: 0.6454313397, alpha: 1)))
            buyItem()
        }
        .frame(height: 50)
    }
}

extension OrderBookView {
    func sellItem() -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .trailing) {
                Group {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.blue.opacity(0.3))
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            Color.blue.opacity(0.15),
                            lineWidth: 2
                        )
                }
                .frame(width: proxy.size.width * orderBookItem.ratio)
                Text(orderBookItem.quantity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .foregroundColor(Color.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
            }
        }
        .opacity(orderBookItem.orderType == .sell ? 1 : 0)
    }
    
    func buyItem() -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Group {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.red.opacity(0.3))
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            Color.red.opacity(0.15),
                            lineWidth: 2
                        )
                }
                .frame(width: proxy.size.width * orderBookItem.ratio)
                
                Text(orderBookItem.quantity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .foregroundColor(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
        }
        .opacity(orderBookItem.orderType == .buy ? 1 : 0)
    }
}

extension OrderBookView {
    struct OrderBookViewItem: Equatable, Hashable {
        let orderType: BithumbOrderType
        let price: String
        let quantity: String
        let ratio: CGFloat
    }
}

struct OrderBookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookView(
            orderBookItem: OrderBookView.OrderBookViewItem(
                orderType: .sell,
                price: "386,000",
                quantity: "120",
                ratio: 0.8
            )
        )
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
