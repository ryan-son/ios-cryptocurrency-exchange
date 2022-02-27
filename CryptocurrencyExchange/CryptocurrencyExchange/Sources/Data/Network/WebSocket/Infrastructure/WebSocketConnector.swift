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
    var dataPublisher: AnyPublisher<Data, Never> { get }
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    func connect()
    func write(data: Data)
}

final class WebSocketConnector<API: SocketTargetType>: WebSocketConnectable {
    private let socket: WebSocket
    
    private let dataSubject = PassthroughSubject<Data, Never>()
    var dataPublisher: AnyPublisher<Data, Never> {
        dataSubject.eraseToAnyPublisher()
    }
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(false)
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }
    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
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
    
    deinit {
        socket.disconnect()
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
                isConnectedSubject.send(true)
            case .disconnected(let reason, let code):
                print("websocket is disconnected: \(reason) with code: \(code)")
                isConnectedSubject.send(false)
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
                isConnectedSubject.send(false)
            case .error(let error):
                isConnectedSubject.send(false)
                guard let error = error else {
                    return
                }
                errorSubject.send(error)
            }
        }
    }
}
