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
    var connectedPublisher: AnyPublisher<Void, Error> { get }
    
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
    
    private let dataSubject = PassthroughSubject<Data, Error>()
    var dataPublisher: AnyPublisher<Data, Error> {
        dataSubject.receive(on: DispatchQueue.global()).eraseToAnyPublisher()
    }
    private let connectedSubject = PassthroughSubject<Void, Error>()
    var connectedPublisher: AnyPublisher<Void, Error> {
        connectedSubject.eraseToAnyPublisher()
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
            connectedSubject.send()
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
//            print("---------------------")
            switch event {
            case .connected(let headers):
                print("websocket is connected: \(headers)")
                self.isConnected = true
                self.connectedSubject.send()
            case .disconnected(let reason, let code):
                print("websocket is disconnected: \(reason) with code: \(code)")
                self.isConnected = false
                guard let error = CloseCode(rawValue: code)?.asSocketConnectorError else {
                    self.connectedSubject.send(
                        completion: .failure(SocketConnectorError.unknown(nil))
                    )
                    return
                }
                self.connectedSubject.send(completion: .failure(error))
            case .text(let string):
//                print("Received text: \(string)")
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
                self.connectedSubject.send(
                    completion: .failure(SocketConnectorError.cancelled)
                )
            case .error(let error):
                self.dataSubject.send(
                    completion: .failure(SocketConnectorError.unknown(error))
                )
            }
        }
    }
}

extension CloseCode {
    var asSocketConnectorError: SocketConnectorError {
        return .webSocketDisconnected(code: self)
    }
}

enum SocketConnectorError: Error {
    case webSocketDisconnected(code: CloseCode)
    case cancelled
    case unknown(Error?)
}
