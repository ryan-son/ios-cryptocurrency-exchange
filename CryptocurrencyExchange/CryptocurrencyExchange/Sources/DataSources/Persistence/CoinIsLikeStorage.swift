//
//  CoinIsLikeCoreDataStorage.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

import Foundation
import Combine
import CoreData

protocol CoinIsLikeCoreDataStorageProtocol {
    func fetchCoinIsLike(for coinName: String) -> Bool
    func saveCoinIsLikeState(
        _ coinIsLikeState: CoinIsLikeState
    ) -> Future<CoinIsLikeStateEntity, Error>
    func cleanUpStorage(in context: NSManagedObjectContext) throws
}

final class CoinIsLikeCoreDataStorage: CoinIsLikeCoreDataStorageProtocol {
    typealias CoinName = String

    static let shared = CoinIsLikeCoreDataStorage()
    private let storage: CoreDataStorageProtocol
    private var cache: [CoinName: Bool] = [:]
    
    private init(storage: CoreDataStorageProtocol = CoreDataStorage.shared) {
        self.storage = storage
        loadEntities()
    }
    
    private func loadEntities() {
        do {
            let request = CoinIsLikeStateEntity.fetchRequest()
            let result = try storage.viewContext.fetch(request).map { $0.toDomain() }
            for item in result {
                cache[item.name] = item.isLike
            }
        } catch {
            Log.error(error)
        }
    }
    
    func fetchCoinIsLike(
        for coinName: String
    ) -> Bool {
        return cache[coinName] ?? false
    }
    
    @discardableResult
    func saveCoinIsLikeState(
        _ coinIsLikeState: CoinIsLikeState
    ) -> Future<CoinIsLikeStateEntity, Error> {
        return Future { promise in
            do {
                self.cache[coinIsLikeState.name] = coinIsLikeState.isLike
                try self.removeDuplicates(for: coinIsLikeState.name, in: self.storage.viewContext)
                
                let entity = CoinIsLikeStateEntity(
                    coinIsLikeState: coinIsLikeState,
                    insertInto: self.storage.viewContext
                )
                self.storage.saveContext()
                promise(.success(entity))
            } catch {
                Log.error(error)
                promise(.failure(error))
            }
        }
    }
    
    func cleanUpStorage(
        in context: NSManagedObjectContext
    ) throws {
        let request: NSFetchRequest = CoinIsLikeStateEntity.fetchRequest()
        let result = try context.fetch(request)
        result.forEach { context.delete($0) }
        try context.save()
    }
    
    func removeDuplicates(
        for coinName: String,
        in context: NSManagedObjectContext
    ) throws {
        let request = CoinIsLikeStateEntity.fetchRequest()
        let results = try context.fetch(request).filter { $0.name == coinName }
        results.forEach { context.delete($0) }
        try context.save()
    }
}
