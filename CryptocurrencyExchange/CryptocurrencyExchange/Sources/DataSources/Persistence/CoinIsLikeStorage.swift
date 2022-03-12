//
//  CoinIsLikeCoreDataStorage.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

import Foundation
import Combine
import CoreData

enum CoreDataStorageError: Error {
    case loadFailed(Error)
    case saveFailed(Error)
}

protocol CoinIsLikeCoreDataStorageProtocol {
    func fetchCoinIsLike(for coinName: String) -> Bool
    func saveCoinIsLikeState(
        _ coinIsLikeState: CoinIsLikeState
    ) -> Future<CoinIsLikeStateEntity, Error>
    func cleanUpStorage(in context: NSManagedObjectContext) throws
}

final class CoinIsLikeCoreDataStorage: CoinIsLikeCoreDataStorageProtocol {
    typealias CoinName = String

    private let storage: CoreDataStorageProtocol
    private static var cache: [CoinName: Bool] = [:]
    
    init(storage: CoreDataStorageProtocol = CoreDataStorage.shared) {
        self.storage = storage
        loadEntities()
    }

    private func loadEntities() {
        do {
            let request = CoinIsLikeStateEntity.fetchRequest()
            let result = try storage.viewContext.fetch(request).map { $0.toDomain() }
            for item in result {
                CoinIsLikeCoreDataStorage.cache[item.name] = item.isLike
            }
        } catch {
            Log.error(error)
        }
    }
    
    func fetchCoinIsLike(
        for coinName: String
    ) -> Bool {
        return CoinIsLikeCoreDataStorage.cache[coinName] ?? false
    }
    
    @discardableResult
    func saveCoinIsLikeState(
        _ coinIsLikeState: CoinIsLikeState
    ) -> Future<CoinIsLikeStateEntity, Error> {
        return Future { promise in
            do {
                CoinIsLikeCoreDataStorage.cache[coinIsLikeState.name] = coinIsLikeState.isLike
                try self.removeDuplicates(for: coinIsLikeState.name, in: self.storage.viewContext)
                
                let entity = CoinIsLikeStateEntity(
                    coinIsLikeState: coinIsLikeState,
                    insertInto: self.storage.viewContext
                )
                try self.storage.viewContext.save()
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
