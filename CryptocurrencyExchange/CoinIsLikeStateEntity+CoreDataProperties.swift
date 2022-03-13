//
//  CoinIsLikeStateEntity+CoreDataProperties.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//
//

import Foundation
import CoreData


extension CoinIsLikeStateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinIsLikeStateEntity> {
        return NSFetchRequest<CoinIsLikeStateEntity>(entityName: "CoinIsLikeStateEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var isLike: Bool
}

extension CoinIsLikeStateEntity : Identifiable {

}

extension CoinIsLikeStateEntity {
    convenience init(
        coinIsLikeState: CoinIsLikeState,
        insertInto context: NSManagedObjectContext
    ) {
        self.init(context: context)
        name = coinIsLikeState.name
        isLike = coinIsLikeState.isLike
    }
    
    func toDomain() -> CoinIsLikeState {
        return CoinIsLikeState(
            name: name,
            isLike: isLike
        )
    }
}
