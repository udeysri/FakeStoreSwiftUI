//
//  Rating.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-09.
//

import Foundation
import SwiftData

@Model
final class Rating: Codable {
    var rate: Double
    var count: Int
    
    init(rate: Double, count: Int) {
        self.rate = rate
        self.count = count
    }
    
    enum CodingKeys: String, CodingKey {
        case rate
        case count
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rate = try container.decode(Double.self, forKey: .rate)
        count = try container.decode(Int.self, forKey: .count)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rate, forKey: .rate)
        try container.encode(count, forKey: .count)
    }
}
