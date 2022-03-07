//
//  BithumbResultSocketResponseDTO.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/03/07.
//

import Foundation

struct BithumbResultSocketResponseDTO: Decodable {
    let status: String?
    let resmsg: String?
    let type: BithumbWebSocketTopicType?
}
