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
    private var isConnected: Bool = false {
        didSet {
            isConnecting = false
        }
    }
    private var isConnecting: Bool = false
    
    private let dataSubject = PassthroughSubject<Data, Never>()
    var dataPublisher: AnyPublisher<Data, Never> {
        dataSubject.receive(on: DispatchQueue.global()).eraseToAnyPublisher()
    }
    private let isConnectedSubject = PassthroughSubject<Bool, Never>()
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }
    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(
        api: API,
        timeoutInterval: TimeInterval = 5
    ) {
        var request = URLRequest.make(with: api)
        request.timeoutInterval = timeoutInterval
        socket = WebSocket(request: request)
    }
    
    deinit {
        socket.disconnect()
    }
    
    func connect() {
        guard isConnecting == false else {
            return
        }
        isConnecting = true
        guard isConnected == false else {
            isConnectedSubject.send(true)
            return
        }
        setOnEvent()
        socket.connect()
    }
    
    func write(
        data: Data
    ) {
        socket.write(data: data)
    }
    
    private func setOnEvent() {
        socket.onEvent = { [weak self] event in
            guard let self = self else { return }
            print("---------------------")
            switch event {
            case .connected(let headers):
                print("websocket is connected: \(headers)")
                self.isConnected = true
                self.isConnectedSubject.send(true)
            case .disconnected(let reason, let code):
                print("websocket is disconnected: \(reason) with code: \(code)")
                self.isConnected = false
                self.isConnectedSubject.send(false)
            case .text(let string):
                print("Received text: \(string)")
                guard let data = string.data(using: .utf8) else {
                    return
                }
                self.dataSubject.send(data)
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                self.isConnectedSubject.send(false)
            case .error(let error):
                self.isConnectedSubject.send(false)
                guard let error = error else {
                    return
                }
                self.errorSubject.send(error)
            }
        }
    }
}
