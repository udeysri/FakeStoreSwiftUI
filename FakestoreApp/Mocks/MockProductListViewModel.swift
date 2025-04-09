//
//  MockProductListViewModel.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-09.
//

import Foundation

@MainActor
final class MockProductListViewModel: ProductListViewModel {
    
    init(state: ProductListState, products: [Product] = []) {
        let mockNetworkService = MockNetworkManager()
        let mockDataManager = MockDataManager()
        super.init(networkService: mockNetworkService, dataManager: mockDataManager)
        self.products = products
        self.state = state
    }
    
    static func createLoadingState() -> MockProductListViewModel {
        MockProductListViewModel(state: .loading)
    }

    static func createErrorState() -> MockProductListViewModel {
        MockProductListViewModel(state: .error("Server error. Please try again later", offline: false))
    }

    static func createOfflineState() -> MockProductListViewModel {
        MockProductListViewModel(state: .error("You're offline. Showing cached data", offline: true))
    }

    static func createProductsListState() -> MockProductListViewModel {
        MockProductListViewModel(state: .loaded, products: MockDataFactory.testProducts)
    }
}
