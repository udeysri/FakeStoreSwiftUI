//
//  ProductListViewModelTests.swift
//  FakestoreAppTests
//
//  Created by Udaya Sri Senarathne on 2025-04-09.
//

import SwiftUI
import Testing
@testable import FakestoreApp

@Suite("ProductListViewModel Tests")
final class ProductListViewModelTests {
    @Test("Fetch products success")
    func testFetchProductsSuccess() async throws {
        let mockNetworkManager = MockNetworkManager()
        let mockDataManager = MockDataManager()
        let expectedProducts = [
            Product(id: 1,
                    title: "Test Product",
                    price: 99.99,
                    productDescription: "Test Description",
                    category: "test",
                    image: "test.jpg",
                    rating: Rating(rate: 4.5, count: 100))
        ]
        mockNetworkManager.mockResponses[MockEndpoint.products.rawValue] = expectedProducts
        
        let sut = await ProductListViewModel(networkService: mockNetworkManager, dataManager: mockDataManager)
        await sut.fetchProducts()
        await #expect(sut.products == expectedProducts)
        await #expect(sut.state == .loaded)
    }
    
    @Test("Fetch products failure with cached data")
    func testFetchProductsFailureWithCachedData() async throws {
        let mockNetworkManager = MockNetworkManager()
        let mockDataManager = MockDataManager()
        mockNetworkManager.mockError = FAError.invalidResponse
        let cachedProducts = [
            Product(id: 2,
                    title: "Cached Product",
                    price: 49.99,
                    productDescription: "Cached Description",
                    category: "test",
                    image: "cached.jpg",
                    rating: Rating(rate: 4.0, count: 50))
        ]
        
        // Override the fetch method to return cached products
        await mockDataManager.setFetchOverride {
            cachedProducts
        }
        
        let sut = await ProductListViewModel(networkService: mockNetworkManager, dataManager: mockDataManager)
        await sut.fetchProducts()
        await #expect(sut.products == cachedProducts)
        await #expect(sut.state == .loaded)
    }
    
    @Test("Fetch products failure with no cached data")
    func testFetchProductsFailureWithNoCachedData() async throws {
        
        let mockNetworkManager = MockNetworkManager()
        let mockDataManager = MockDataManager()
        mockNetworkManager.mockError = FAError.invalidResponse
        
        let sut = await ProductListViewModel(networkService: mockNetworkManager, dataManager: mockDataManager)
        await sut.fetchProducts()
        await #expect(sut.products.isEmpty)
        await #expect(sut.state == .error("Server error. Please try again later", offline: false))
    }
    
    @Test("Loading state changes")
    func testLoadingState() async throws {
        
        let mockNetworkManager = MockNetworkManager()
        let mockDataManager = MockDataManager()
        let expectedProducts = [
            Product(id: 1,
                    title: "Test Product",
                    price: 99.99,
                    productDescription: "Test Description",
                    category: "test",
                    image: "test.jpg",
                    rating: Rating(rate: 4.5, count: 100))
        ]
        mockNetworkManager.mockResponses["/products"] = expectedProducts
        let sut = await ProductListViewModel(networkService: mockNetworkManager, dataManager: mockDataManager)
        
        let task = Task {
            await sut.fetchProducts()
        }
        
        // Add waiting time so we get the loading state.
        try await Task.sleep(nanoseconds: 1000)
        
        // Check loading state
        await #expect(sut.state == .loading)
        
        // Wait for completion
        await task.value
        
        // Last check the completed state
        await #expect(sut.state == .loaded)
        await #expect(sut.products == expectedProducts)
    }
    
    @Test("Refresh products clears cache and fetches new data")
    func testRefreshProducts() async throws {
        let mockNetworkManager = MockNetworkManager()
        let mockDataManager = MockDataManager()
        let expectedProducts = [
            Product(id: 3,
                    title: "Refreshed Product",
                    price: 149.99,
                    productDescription: "Refreshed Description",
                    category: "test",
                    image: "refreshed.jpg",
                    rating: Rating(rate: 4.8, count: 200))
        ]
        mockNetworkManager.mockResponses["/products"] = expectedProducts
        let sut = await ProductListViewModel(networkService: mockNetworkManager, dataManager: mockDataManager)
        await sut.refreshProducts()
        await #expect(sut.products == expectedProducts)
        await #expect(sut.state == .loaded)
    }
    
    @Test("Fetch products fails due to decoding error")
    func testFetchProductsDecodingFailure() async throws {
        let mockNetworkManager = MockNetworkManager()
        let mockDataManager = MockDataManager()
        
        // Invalida json
        let invalidJSON = Data("{ invalid json }".utf8)
        mockNetworkManager.mockResponses["/products"] = invalidJSON
        
        let sut = await ProductListViewModel(networkService: mockNetworkManager, dataManager: mockDataManager)
        await sut.fetchProducts()
        await #expect(sut.state == .error("Error processing data", offline: false))
        await #expect(sut.products.isEmpty)
    }
    
    
    @Test("Fetch products returns empty list")
    func testFetchProductsEmptyList() async throws {
        
        let mockNetworkManager = MockNetworkManager()
        let mockDataManager = MockDataManager()
        mockNetworkManager.mockResponses["/products"] = [Product]()
        
        let sut = await ProductListViewModel(networkService: mockNetworkManager, dataManager: mockDataManager)
        await sut.fetchProducts()
        await #expect(sut.products.isEmpty)
        await #expect(sut.state == .loaded)
    }
    
    @Test("Refresh clears the cache")
    func testRefreshCallsClear() async throws {
        let mockNetworkManager = MockNetworkManager()
        let mockDataManager = MockDataManager()
        let expectedProducts = MockDataFactory.testProducts
        mockNetworkManager.mockResponses["/products"] = expectedProducts
        
        let sut = await ProductListViewModel(networkService: mockNetworkManager, dataManager: mockDataManager)
        await sut.refreshProducts()
        await #expect(mockDataManager.wasClearCalled == true)
        await #expect(sut.products == expectedProducts)
        await #expect(sut.state == .loaded)
    }
    
}
