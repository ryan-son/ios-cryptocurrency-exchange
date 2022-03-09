//
//  OrderBookView.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/09.
//

import SwiftUI
import UIKit

struct OrderBookView: View {
    var body: some View {
        HStack(spacing: 12) {
            GeometryReader { proxy in
                ZStack(alignment: .trailing) {
                    Group {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.09545593709, green: 0.141261071, blue: 0.2428939939, alpha: 1)))
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(
                                Color(#colorLiteral(red: 0.1310761869, green: 0.1766343713, blue: 0.2784407139, alpha: 1)),
                                lineWidth: 2
                            )
                    }
                    .frame(width: proxy.size.width * 0.3)
                    Text("\(10000)")
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .foregroundColor(Color(#colorLiteral(red: 0.1032625362, green: 0.3436104059, blue: 0.7600500584, alpha: 1)))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                }
            }
            Text("69,660")
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .foregroundColor(Color(#colorLiteral(red: 0.6196818948, green: 0.6193746924, blue: 0.6454313397, alpha: 1)))
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(#colorLiteral(red: 0.218341738, green: 0.09102953225, blue: 0.1211696193, alpha: 1)))
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        Color(#colorLiteral(red: 0.2544833422, green: 0.1267328262, blue: 0.1652044058, alpha: 1)),
                        lineWidth: 2
                    )
                Text("402")
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .foregroundColor(Color(#colorLiteral(red: 0.7383909822, green: 0.1068297848, blue: 0.1604961157, alpha: 1)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
        }
        .frame(height: 50)
    }
}

struct OrderBookView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookView()
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
