//
//  ToastClient.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/09.
//

import Foundation

import ComposableArchitecture
import UIKit

struct ToastModel {
    var duration: TimeInterval = 2
    var message: String
}

struct ToastClient {
    var show: (ToastModel) -> Effect<Never, Never>
}

extension ToastClient {
    static let live: ToastClient = {
        return ToastClient { toastModel in
                .fireAndForget {
                    guard let scenes = UIApplication.shared.connectedScenes
                            .compactMap({ $0 as? UIWindowScene }).first,
                        let window = scenes.windows.first else {
                            return
                        }
                    ToastUIView.show(with: toastModel, on: window)
                }
        }
    }()
}
