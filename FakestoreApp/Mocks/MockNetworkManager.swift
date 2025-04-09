//
//  MockNetworkService.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-08.
//

import Foundation

enum MockEndpoint: String {
    case products = "/products"
}

final class MockNetworkManager: NetworkServiceProtocol {
    var mockResponses: [String: Any] = [:]
    var mockError: Error?
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if let error = mockError {
            // Always throw FAError for consistency
            if let faError = error as? FAError {
                throw faError
            } else {
                throw FAError.unknown(error)
            }
        }
        
        guard let mockResponse = mockResponses[endpoint.path] else {
            throw FAError.invalidResponse
        }
        
        if let typed = mockResponse as? T {
            return typed
        }
        
        if let data = mockResponse as? Data {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw FAError.decodingError
            }
        }
        
        throw FAError.invalidData
    }
    
}
