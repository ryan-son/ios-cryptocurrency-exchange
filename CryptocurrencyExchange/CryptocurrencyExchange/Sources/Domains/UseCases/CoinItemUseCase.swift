//
//  CoinItemUseCase.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

import Foundation

protocol CoinItemUseCaseProtocol {
    func getCoinIsLikeState(for coinName: String) -> Bool
    func saveCoinIsLikeState(for coinName: String, isLike: Bool)
}

struct CoinItemUseCase: CoinItemUseCaseProtocol {
    
    private let repository: BithumbRepositoryProtocol
    
    init(
        repository: BithumbRepositoryProtocol = BithumbRepository()
    ) {
        self.repository = repository
    }
    
    func getCoinIsLikeState(for coinName: String) -> Bool {
        return repository.getCoinIsLikeState(for: coinName)
    }
    
    func saveCoinIsLikeState(for coinName: String, isLike: Bool) {
        repository.saveCoinIsLikeState(for: coinName, isLike: isLike)
    }
}
