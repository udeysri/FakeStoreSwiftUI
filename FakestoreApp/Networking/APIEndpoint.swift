//
//  APIEndpoints.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-07.
//

import Foundation

// API Endpoints
enum APIEndpoint: Endpoint {
    case products
    case product(id: Int)
    case users
    case carts
    
    var path: String {
        switch self {
        case .products:
            return "/products"
        case .product(let id):
            return "/products/\(id)"
        case .users:
            return "/users"
        case .carts:
            return "/carts"
        }
    }
}
