//
//  DataManager.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-07.
//

import Foundation
import SwiftData

// Protocol for data manager that saves and fetches items to and from the databases
protocol DataManagerProtocol {
    func save<T>(_ items: [T]) async where T: PersistentModel
    func fetch<T>() async -> [T] where T: PersistentModel
    func clear<T>(_ type: T.Type) async where T: PersistentModel
}

// Data manager that saves and fetches items to and from the databases
@ModelActor
actor DataManager: DataManagerProtocol {
    
    /// Save items to the database
    /// - Parameters:
    ///   - items: The items to save
    /// - Throws: An error if the save fails
    func save<T>(_ items: [T]) async where T: PersistentModel {
        for item in items {
            modelContext.insert(item)
        }
        try? modelContext.save()
    }
    
    /// Fetch items from the database
    /// - Returns: An array of items
    func fetch<T>() async -> [T] where T: PersistentModel {
        let descriptor = FetchDescriptor<T>(
            sortBy: [SortDescriptor(\T.id)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    /// Clear items from the database
    /// - Parameter type: The type of items to clear
    func clear<T>(_ type: T.Type) async where T: PersistentModel {
        try? modelContext.delete(model: type)
        try? modelContext.save()
    }
}

