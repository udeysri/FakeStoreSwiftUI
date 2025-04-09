//
//  NetworkManager.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-07.
//

import Foundation

// Defines different network service protocols
protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// Network manager to handle the network requests
class NetworkManager: NetworkServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Fetch data from the network
    /// - Parameter endpoint: The endpoint to fetch data from
    /// - Returns: The decoded data
    /// - Throws: NetworkError if the request fails
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw FAError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw FAError.invalidResponse
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw mapError(error)
        }
    }
    
    /// Map error to FAError
    /// - Parameter error: The error to map
    /// - Returns: The mapped error
    private func mapError(_ error: Error) -> FAError {
        if let _ = error as? DecodingError {
            return .decodingError
        }
        
        if let urlError = error as? URLError {
            let isOffline = urlError.code == .notConnectedToInternet
            return .networkError(urlError, isOffline)
        }
        
        if let networkError = error as? FAError {
            return networkError
        }
        
        return .unknown(error)
    }
    
}
