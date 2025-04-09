//
//  ProductListViewModel.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-07.
//

import Foundation
import SwiftData

// State of the product list view
enum ProductListState: Equatable {
    case loading
    case error(String, offline: Bool)
    case loaded
}

@MainActor
class ProductListViewModel: ObservableObject {

    // Network service to fetch products
    private let networkService: NetworkServiceProtocol
    
    // Data manager to save and fetch products
    private let dataManager: DataManagerProtocol

    @Published var state: ProductListState = .loading
    @Published var products: [Product] = []
    
    init(networkService: NetworkServiceProtocol, dataManager: DataManagerProtocol) {
        self.networkService = networkService
        self.dataManager = dataManager
    }

    // Fetch products from the network and save to the cache
    func fetchProducts() async {
        self.state = .loading
        
        do {
            // Try to fetch from network first
            products = try await networkService.fetch(APIEndpoint.products)
            // Save to cache
            await dataManager.save(products)
            self.state = .loaded
        } catch let error {
            do {
                // In any error try to load the products from the cache.
                let cachedProducts: [Product] = await dataManager.fetch()
                if !cachedProducts.isEmpty {
                    products = cachedProducts
                    self.state = .loaded
                } else {
                    // No cached data available
                    products = []
                    let (message, offline) = mapErrors(error)
                    self.state = .error(message, offline: offline)
                    
                }
            }
        }
    }
    
    // Clean the current cached products & refetched the products
    func refreshProducts() async {
        // Clear existing data
        await dataManager.clear(Product.self)
        await fetchProducts()
    }
    
    /// Map errors to a proper localised descriptions and offline state.
    /// - Parameter error: The error to map
    /// - Returns: A tuple of message and offline status
    private func mapErrors(_ error: Error) -> (message: String, offline: Bool) {
        if let networkError = error as? FAError {
            return (networkError.localizedDescription, networkError.isOffline)
        } else {
            return ("Unexpected error occurred.", false)
        }
    }
}
