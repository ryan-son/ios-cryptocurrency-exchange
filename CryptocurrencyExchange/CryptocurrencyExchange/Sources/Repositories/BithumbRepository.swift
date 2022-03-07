//
//  BithumbWebSocketRepository.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/26.
//


import Combine
import Foundation

protocol BithumbRepositoryProtocol {
    func getTickerSinglePublisher() -> AnyPublisher<BithumbTickerResultRESTResponseDTO, Error>
    func getTickerStreamPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbTickerSocketResponseDTO, Error>
    func getTransactionStreamPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbTransactionSocketResponseDTO, Error>
    func getOrderBookDepthStreamPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbOrderBookDepthSocketResponseDTO, Error>
}

enum BithumbRepositoryError: Error {
    case notConnected
}

struct BithumbRepository: BithumbRepositoryProtocol {
    private let restService: BithumbRESTService
    private let socketService: BithumbSocketService

    init(
        restService: BithumbRESTService = BithumbRESTService(),
        socketService: BithumbSocketService = BithumbSocketService()
    ) {
        self.restService = restService
        self.socketService = socketService
    }
    
    // MARK: - REST
    
    func getTickerSinglePublisher() -> AnyPublisher<BithumbTickerResultRESTResponseDTO, Error> {
        return restService
            .getTickers()
            .eraseToAnyPublisher()
    }
    

    // MARK: - WebSocket
    
    func getTickerStreamPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbTickerSocketResponseDTO, Error> {
        return socketService.connect()
            .flatMap{ _ in
                socketService.getTickerPublisher(with: filter)
            }
            .eraseToAnyPublisher()
    }
    
    func getTransactionStreamPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbTransactionSocketResponseDTO, Error> {
        return socketService.connect()
            .flatMap{ _ in
                socketService.getTransactionPublisher(with: filter)
            }
            .eraseToAnyPublisher()
    }
    
    func getOrderBookDepthStreamPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbOrderBookDepthSocketResponseDTO, Error> {
        return socketService.connect()
            .flatMap{ _ in
                socketService.getOrderBookDepthPublisher(with: filter)
            }
            .eraseToAnyPublisher()
    }
}
