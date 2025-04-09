//
//  Product.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-07.
//

import Foundation
import SwiftData

@Model
final class Product: Codable {
    var id: Int
    var title: String
    var price: Double
    var productDescription: String
    var category: String
    var image: String
    var rating: Rating
    
    init(id: Int,
         title: String,
         price: Double,
         productDescription: String,
         category: String,
         image: String,
         rating: Rating) {
        self.id = id
        self.title = title
        self.price = price
        self.productDescription = productDescription
        self.category = category
        self.image = image
        self.rating = rating
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case productDescription = "description"
        case category
        case image
        case rating
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(Double.self, forKey: .price)
        productDescription = try container.decode(String.self, forKey: .productDescription)
        category = try container.decode(String.self, forKey: .category)
        image = try container.decode(String.self, forKey: .image)
        rating = try container.decode(Rating.self, forKey: .rating)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(price, forKey: .price)
        try container.encode(productDescription, forKey: .productDescription)
        try container.encode(category, forKey: .category)
        try container.encode(image, forKey: .image)
        try container.encode(rating, forKey: .rating)
    }
}
