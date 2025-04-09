//
//  Endpoint.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-07.
//

import Foundation

// Endpoint protocol to define API endpoints
protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var baseURL: String { "https://fakestoreapi.com" }
    var queryItems: [URLQueryItem]? { nil }
    
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
}
