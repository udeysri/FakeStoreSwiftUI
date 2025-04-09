//
//  MockDataFactory.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-08.
//

// Mock products
enum MockDataFactory {
    static var testProducts: [Product] {
        [
            Product(id: 1,
                    title: "Fjallraven - Foldsack No. 1 Backpack",
                    price: 109.95,
                    productDescription: "Everyday pack",
                    category: "men's clothing",
                    image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
                    rating: Rating(rate: 3.9, count: 120)),
            Product(id: 2,
                    title: "Mens Casual Premium Slim Fit T-Shirts with a very long title that should wrap to multiple lines to test the layout",
                    price: 22.30,
                    productDescription: "Made in Portugal",
                    category: "men's clothing",
                    image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
                    rating: Rating(rate: 4.1, count: 259))
        ]
    }
}
