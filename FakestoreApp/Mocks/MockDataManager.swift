//
//  MockDataManager.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-08.
//

import Foundation
import SwiftData

final actor MockDataManager: DataManagerProtocol {
    private var storage: [String: [any PersistentModel]] = [:]
    private var fetchOverride: (() -> [any PersistentModel])?
    
    var wasClearCalled = false

    func setFetchOverride(_ block: @escaping () -> [any PersistentModel]) {
        self.fetchOverride = block
    }

    func save<T>(_ items: [T]) async where T : PersistentModel {
        let key = String(describing: T.self)
        storage[key] = items
    }

    func fetch<T>() async -> [T] where T : PersistentModel {
        if let override = fetchOverride?(), let typed = override as? [T] {
            return typed
        }

        let key = String(describing: T.self)
        return (storage[key] as? [T]) ?? []
    }

    func clear<T>(_ type: T.Type) async where T : PersistentModel {
        let key = String(describing: T.self)
        storage[key] = []
        wasClearCalled = true
    }
}

