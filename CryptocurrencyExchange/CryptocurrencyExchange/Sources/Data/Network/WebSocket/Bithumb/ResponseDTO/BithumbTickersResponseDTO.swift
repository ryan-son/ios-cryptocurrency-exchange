//
//  BithumbTickerTypeResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/27.
//

import Foundation

struct BithumbTickersResponseDTO: Decodable {
    let type: BithumbWebSocketTopicType
    let content: [BithumbTickersDTO]
    
    struct BithumbTickersDTO: Decodable {
        let symbol, tickType, date, time: String
        let openPrice, closePrice, lowPrice, highPrice: String
        let value, volume, sellVolume, buyVolume: String
        let prevClosePrice, chgRate, chgAmt, volumePower: String
    }
}
