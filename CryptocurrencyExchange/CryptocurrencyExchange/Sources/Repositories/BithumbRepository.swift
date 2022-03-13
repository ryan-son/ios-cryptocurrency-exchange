//
//  BithumbWebSocketRepository.swift
//  CryptocurrencyExchange
//
//  Created by 이경준 on 2022/02/26.
//


import Combine
import Foundation

protocol BithumbRepositoryProtocol {
    func getTickerAllSinglePublisher() -> AnyPublisher<BithumbTickerAllResultRESTResponseDTO, Error>
    func getTickerSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbTickerResultRESTResponseDTO, Error>
    func getOrderBookSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbOrderBookResultRESTResponseDTO, Error>
    func getTransactionHistorySinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbTransactionHistoryResultRESTResponseDTO, Error>
    func getCandleStickSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbCandleStickResultResponseDTO, Error>
    func getTickerStreamPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbTickerSocketResponseDTO, Error>
    func getTransactionStreamPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbTransactionSocketResponseDTO, Error>
    func getOrderBookDepthStreamPublisher(
        with filter: BithumbWebSocketFilter
    ) -> AnyPublisher<BithumbOrderBookDepthSocketResponseDTO, Error>
    func getCoinIsLikeState(for coinName: String) -> Bool
    func saveCoinIsLikeState(for coinName: String, isLike: Bool)
}

enum BithumbRepositoryError: Error {
    case notConnected
}

struct BithumbRepository: BithumbRepositoryProtocol {
    private let restService: BithumbRESTService
    private let socketService: BithumbSocketService
    private let coinIsLikeStorage: CoinIsLikeCoreDataStorageProtocol

    init(
        restService: BithumbRESTService = BithumbRESTService(),
        socketService: BithumbSocketService = BithumbSocketService(),
        coinIsLikeStorage: CoinIsLikeCoreDataStorageProtocol = CoinIsLikeCoreDataStorage.shared
    ) {
        self.restService = restService
        self.socketService = socketService
        self.coinIsLikeStorage = coinIsLikeStorage
    }
    
    // MARK: - REST
    
    func getTickerAllSinglePublisher() -> AnyPublisher<BithumbTickerAllResultRESTResponseDTO, Error> {
        return restService
            .getTickers()
            .eraseToAnyPublisher()
    }
    
    func getTickerSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbTickerResultRESTResponseDTO, Error> {
        return restService
            .getTicker(symbol: symbol)
            .eraseToAnyPublisher()
    }
    
    func getOrderBookSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbOrderBookResultRESTResponseDTO, Error> {
        return restService
            .getOrderBook(symbol: symbol)
            .eraseToAnyPublisher()
    }
    
    func getTransactionHistorySinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbTransactionHistoryResultRESTResponseDTO, Error> {
        return restService
            .getTransactionHistory(symbol: symbol)
            .eraseToAnyPublisher()
    }
    
    func getCandleStickSinglePublisher(
        symbol: String
    ) -> AnyPublisher<BithumbCandleStickResultResponseDTO, Error> {
        return restService
            .getCandleStick(symbol: symbol)
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
    
    // MARK: - Persistence
    
    func getCoinIsLikeState(for coinName: String) -> Bool {
        return coinIsLikeStorage.fetchCoinIsLike(for: coinName)
    }
    
    func saveCoinIsLikeState(for coinName: String, isLike: Bool) {
        let coinIsLikeState = CoinIsLikeState(name: coinName, isLike: isLike)
        _ = coinIsLikeStorage.saveCoinIsLikeState(coinIsLikeState)
    }
}
