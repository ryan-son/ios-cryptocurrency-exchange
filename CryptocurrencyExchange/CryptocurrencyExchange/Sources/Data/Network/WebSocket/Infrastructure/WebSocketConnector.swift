//
//  WebSocketConnector.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/02/26.
//

import Foundation

import Starscream

protocol WebSocketConnectable {
    func connect()
    func write(data: Data)
}

final class WebSocketConnector<API: SocketTargetType>: WebSocketConnectable {

    private let socket: WebSocket
    private var isConnected: Bool = false

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
        socket.delegate = self
        socket.connect()
    }

    func write(data: Data) {
        socket.write(data: data)
    }
}

extension WebSocketConnector: WebSocketDelegate {

    func didReceive(
        event: WebSocketEvent,
        client: WebSocket
    ) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
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
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
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
