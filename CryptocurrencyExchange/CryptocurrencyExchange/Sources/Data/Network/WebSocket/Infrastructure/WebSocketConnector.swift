//
//  WebSocketConnector.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//

import Combine
import Foundation

import Starscream

protocol WebSocketConnectable {
    var dataPublisher: AnyPublisher<Data, Error> { get }
    
    func connect()
    func write(data: Data)
}

final class WebSocketConnector<API: SocketTargetType>: WebSocketConnectable {
    private let socket: WebSocket
    private var isConnected: Bool = false
    private let dataSubject = PassthroughSubject<Data, Error>()
    var dataPublisher: AnyPublisher<Data, Error> {
        dataSubject.eraseToAnyPublisher()
    }
    
    init?(
        api: API,
        timeoutInterval: TimeInterval = 5
    ) {
        guard var request = URLRequest.make(with: api) else {
            return nil
        }
        request.timeoutInterval = timeoutInterval
        socket = WebSocket(request: request)
    }
    
    func connect() {
        socket.connect()
        setOnEvent()
    }
    
    func write(
        data: Data
    ) {
        socket.write(data: data)
    }
    
    private func setOnEvent() {
        socket.onEvent = { [self] event in
            switch event {
            case .connected(let headers):
                print("websocket is connected: \(headers)")
                isConnected = true
            case .disconnected(let reason, let code):
                print("websocket is disconnected: \(reason) with code: \(code)")
                isConnected = false
            case .text(let string):
                print("Received text: \(string)")
            case .binary(let data):
                print("Received data: \(data.count)")
                dataSubject.send(data)
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnected = false
            case .error(let error):
                isConnected = false
                handleError(error)
            }
        }
    }
    
    private func handleError(
        _ error: Error?
    ) {
        guard let error = error else {
            return
        }
        print(error)
    }
}
