//
//  NetworkError.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-07.
//

import Foundation

// All Errors related to FakeStoreApp
public enum FAError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError
    case networkError(Error, Bool)
    case unknown(Error)
}

extension FAError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Server error. Please try again later"
        case .invalidData:
            return "Invalid data received"
        case .decodingError:
            return "Error processing data"
        case .networkError(let message, _):
            return message.localizedDescription
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
    public var isOffline: Bool {
        switch self {
        case .networkError(_, let offline):
            return offline
        default:
            return false
        }
    }
}
