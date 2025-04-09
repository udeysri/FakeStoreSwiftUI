//
//  DependencyContainer.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-07.
//

import SwiftUI
import SwiftData

// Dependency container for the app
// NOTE:- Centralized dependency injection for the app
@MainActor
class DependencyContainer {
    
    private let modelContainer: ModelContainer
    private let dataManager: DataManagerProtocol
    private let networkService: NetworkServiceProtocol
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Product.self, Rating.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        
        dataManager = DataManager(modelContainer: modelContainer)
        networkService = NetworkManager()
    }
    
    func makeProductListViewModel() -> ProductListViewModel {
        ProductListViewModel(
            networkService: networkService,
            dataManager: dataManager
        )
    }
    
    var modelContext: ModelContext {
        modelContainer.mainContext
    }
    
    var container: ModelContainer {
        modelContainer
    }
}
