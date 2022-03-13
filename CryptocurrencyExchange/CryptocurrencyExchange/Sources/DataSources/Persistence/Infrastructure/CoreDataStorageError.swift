//
//  CoreDataStorageError.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/13.
//

enum CoreDataStorageError: Error {
    case loadFailed(Error)
    case saveFailed(Error)
}
